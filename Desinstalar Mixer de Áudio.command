#!/bin/bash
# ============================================================================
#  Desinstalador COMPLETO do "Mixer de Áudio"  (ferramenta EXTERNA — não faz parte do app)
#
#  Remove TODAS as versões, instâncias e dependências em QUALQUER Mac:
#    • o app em qualquer local, identificado por BUNDLE ID — NUNCA por nome, para JAMAIS remover
#      software de terceiros parecido (Voicemod COMERCIAL net.voicemod.desktop, Parrot, etc.);
#    • o dispositivo próprio (MixerDeAudioDriver.driver);
#    • o item de "Iniciar no login" (SMAppService — via o próprio binário, com --unregister-login);
#    • preferências, permissão de microfone (TCC) e itens de login legados;
#    • ATALHOS (symlinks) na Mesa que apontem para os apps removidos — pelo ALVO do link, nunca
#      pelo nome (um atalho da usuária com nome parecido apontando para outra coisa não é tocado);
#    • encerra a INSTÂNCIA ABERTA do app.
#
#  BlackHole, Voicemod comercial e outros drivers/apps de terceiros são preservados.
#  TUDO-OU-NADA QUANTO À SENHA: a remoção destrutiva (app + driver próprio) acontece num único
#  bloco com privilégios; se a senha for cancelada, NADA disso é removido.
#  PARIDADE com o desinstalador INTERNO (enum Uninstaller em Bootstrap.swift) — manter os dois iguais.
# ============================================================================
set -u

OUR_IDS=("com.local.mixerdeaudio" "com.local.mixerdeaudio1024" "com.local.voicemod" "com.local.voicemod1024")
LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

is_ours() { local b="$1" o; for o in "${OUR_IDS[@]}"; do [ "$b" = "$o" ] && return 0; done; return 1; }

# Quota um caminho com ASPAS SIMPLES preservando os bytes LITERAIS (igual ao shellQuote do Swift).
# Mais robusto que `printf %q` do bash 3.2, que reescrevia caracteres acentuados (Á) em octal e, sob o
# locale C do `do shell script` root, NÃO casava o arquivo — deixando cópias acentuadas para trás.
sq() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }

echo "════════════════════════════════════════════════════════════"
echo "   Desinstalador completo — Mixer de Áudio"
echo "════════════════════════════════════════════════════════════"
echo
echo "Vai remover (todas as versões): o app, o dispositivo \"Mixer de Áudio\","
echo "preferências, permissão de microfone e item de login,"
echo "e vai FECHAR o app aberto. NÃO toca em softwares de terceiros."
echo

# Confirmação robusta: só pergunta se houver terminal (stdin é um tty). Sem tty (pipe/automação),
# assume que a execução foi deliberada e prossegue — em vez de cair em "cancelado" silencioso por EOF.
if [ -t 0 ]; then
  printf "Digite  s  e Enter para confirmar (qualquer outra coisa cancela): "
  if ! read -r ans || { [ "${ans:-}" != "s" ] && [ "${ans:-}" != "S" ]; }; then
    echo "Cancelado."; exit 0
  fi
else
  echo "(sem terminal interativo — prosseguindo)"
fi
echo

# 1) Descobre os apps NOSSOS por BUNDLE ID (nunca por nome → ignora o Voicemod comercial).
echo "1) Procurando apps do Mixer de Áudio (por bundle id)…"
APPS=()
while IFS= read -r app; do
  bid=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$app/Contents/Info.plist" 2>/dev/null)
  if [ -n "${bid:-}" ] && is_ours "$bid"; then APPS+=("$app"); fi
done < <(find /Applications "$HOME/Applications" "$HOME/Downloads" "$HOME/Desktop" \
              -maxdepth 3 -name "*.app" -type d 2>/dev/null)
# rede de segurança: garante o caminho canônico instalado, mesmo que o find não o pegue.
CANON="/Applications/Mixer de Áudio.app"
if [ -d "$CANON" ]; then
  cbid=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$CANON/Contents/Info.plist" 2>/dev/null)
  if is_ours "${cbid:-}"; then
    seen=0; for a in ${APPS[@]+"${APPS[@]}"}; do [ "$a" = "$CANON" ] && seen=1; done
    [ "$seen" = "0" ] && APPS+=("$CANON")
  fi
fi
if [ "${#APPS[@]}" -eq 0 ]; then echo "   (nenhum app encontrado)"; else printf "   • %s\n" "${APPS[@]}"; fi

# 2) Prepara somente scripts e coordenação privados. Até a confirmação da senha, não executa
#    utilitários do app nem altera login, agregado, LaunchServices, preferências ou processos.
WORK="$(mktemp -d "${TMPDIR:-/tmp}/mixer-uninstall-work.XXXXXX")" || { echo "erro: mktemp"; exit 1; }
PRIV=""
UTILITY_WORKER=""
cleanup() {
  if [ -n "$UTILITY_WORKER" ]; then
    if [ ! -f "${UTILITY_DONE:-}" ]; then
      kill -TERM "$UTILITY_WORKER" >/dev/null 2>&1 || true
    fi
    wait "$UTILITY_WORKER" >/dev/null 2>&1 || true
  fi
  [ -n "$PRIV" ] && rm -f "$PRIV"
  rm -rf "$WORK"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
AUTHORIZED="$WORK/authorized"
UTILITY_DONE="$WORK/utility-done"

# Os utilitários rodam como a usuária, nos caminhos ORIGINAIS: SMAppService.mainApp pertence
# ao bundle em execução. Uma cópia temporária não comprova a identidade do login item original.
# O trabalhador espera o marcador escrito só pelo comando autorizado, após revalidar os IDs.
run_authorized_utilities() {
  mixer_utility_pid=""
  trap '[ -z "$mixer_utility_pid" ] || kill -KILL "$mixer_utility_pid" >/dev/null 2>&1 || true' EXIT
  trap 'exit 1' INT TERM
  while [ ! -f "$AUTHORIZED" ]; do sleep 0.1; done
  mixer_utility_status=0
  for app in ${APPS[@]+"${APPS[@]}"}; do
    bid=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$app/Contents/Info.plist" 2>/dev/null)
    if ! is_ours "${bid:-}"; then mixer_utility_status=1; break; fi
    exe="$app/Contents/MacOS/MixerDeAudio"
    [ -x "$exe" ] || continue
    "$exe" --unregister-login --destroy-legacy-aggregate >/dev/null 2>&1 &
    mixer_utility_pid=$!
    mixer_wait=0
    while kill -0 "$mixer_utility_pid" >/dev/null 2>&1 && [ "$mixer_wait" -lt 150 ]; do
      sleep 0.1
      mixer_wait=$((mixer_wait + 1))
    done
    if kill -0 "$mixer_utility_pid" >/dev/null 2>&1; then
      kill -KILL "$mixer_utility_pid" >/dev/null 2>&1 || true
      wait "$mixer_utility_pid" >/dev/null 2>&1 || true
      mixer_utility_status=1
    elif ! wait "$mixer_utility_pid"; then
      mixer_utility_status=1
    fi
    mixer_utility_pid=""
    [ "$mixer_utility_status" = 0 ] || break
  done
  # Publica o status inteiro de uma vez: existir não pode significar arquivo ainda vazio.
  printf '%s\n' "$mixer_utility_status" > "$WORK/utility-result" &&
    mv "$WORK/utility-result" "$UTILITY_DONE" || exit 1
  exit "$mixer_utility_status"
}

# 3) PARTE DESTRUTIVA — UMA senha (diálogo do macOS). Remove somente bundles comprovados por id.
#    CoreAudio é recarregado só se o driver próprio foi removido. Nenhum processo é morto por nome.
echo "2) Removendo o app e o driver próprio (vai pedir a sua senha)…"
PRIV="$(mktemp "${TMPDIR:-/tmp}/mixer-uninstall-priv.XXXXXX")" || { echo "erro: mktemp"; exit 1; }
{
  echo '#!/bin/bash'
  echo 'mixer_driver_removed=0'
  echo 'if [ "$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver/Contents/Info.plist" 2>/dev/null)" = "com.local.mixerdeaudio.driver" ]; then'
  echo '  rm -rf "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" && mixer_driver_removed=1'
  echo 'fi'
  # Revalida o id dentro do passo autorizado: a lista antiga não basta se o caminho mudou.
  for app in ${APPS[@]+"${APPS[@]}"}; do
    printf 'mixer_app_id=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" %s 2>/dev/null)\n' "$(sq "$app/Contents/Info.plist")"
    printf 'case "$mixer_app_id" in com.local.mixerdeaudio|com.local.mixerdeaudio1024|com.local.voicemod|com.local.voicemod1024) rm -rf %s ;; esac\n' "$(sq "$app")"
  done
  echo 'if [ "$mixer_driver_removed" = 1 ]; then /usr/bin/killall coreaudiod >/dev/null 2>&1 || true; fi'
  echo "exit 0"
} > "$PRIV"
chmod +x "$PRIV"
GATE="$WORK/authorized-removal.sh"
{
  echo '#!/bin/bash'
  # Nenhum marcador é publicado se um bundle foi substituído desde a descoberta.
  for app in ${APPS[@]+"${APPS[@]}"}; do
    printf '[ -d %s ] && [ ! -L %s ] || exit 1\n' "$(sq "$app")" "$(sq "$app")"
    printf 'mixer_app_id=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" %s 2>/dev/null)\n' "$(sq "$app/Contents/Info.plist")"
    echo 'case "$mixer_app_id" in com.local.mixerdeaudio|com.local.mixerdeaudio1024|com.local.voicemod|com.local.voicemod1024) ;; *) exit 1 ;; esac'
  done
  echo 'if [ -e "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" ] || [ -L "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" ]; then'
  echo '  [ ! -L "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" ] || exit 1'
  echo '  [ "$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver/Contents/Info.plist" 2>/dev/null)" = "com.local.mixerdeaudio.driver" ] || exit 1'
  echo 'fi'
  printf ': > %s || exit 1\n' "$(sq "$AUTHORIZED")"
  echo 'mixer_wait=0'
  printf 'while [ ! -f %s ]; do\n' "$(sq "$UTILITY_DONE")"
  echo '  [ "$mixer_wait" -lt 1200 ] || exit 1'
  echo '  sleep 0.1; mixer_wait=$((mixer_wait + 1))'
  echo 'done'
  printf '[ "$(cat %s)" = 0 ] || exit 1\n' "$(sq "$UTILITY_DONE")"
  printf '/bin/bash %s\n' "$(sq "$PRIV")"
} > "$GATE"
run_authorized_utilities &
UTILITY_WORKER=$!
if osascript -e "do shell script \"/bin/bash '$GATE'\" with administrator privileges" >/dev/null 2>&1; then
  wait "$UTILITY_WORKER" >/dev/null 2>&1 || true
  UTILITY_WORKER=""
  # O exit autorizado não comprova remoção. Se houver resíduo, preserva as demais configurações.
  RESIDUO=""
  if [ -e "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" ] || [ -L "/Library/Audio/Plug-Ins/HAL/MixerDeAudioDriver.driver" ]; then RESIDUO="o dispositivo de áudio"; fi
  for app in ${APPS[@]+"${APPS[@]}"}; do
    if [ -e "$app" ] || [ -L "$app" ]; then
      RESIDUO="${RESIDUO:+$RESIDUO e }uma cópia do app"
      break
    fi
  done
  if [ -n "$RESIDUO" ]; then
    echo "   ⚠ remoção incompleta: $RESIDUO ainda está no disco. Login/agregado podem já ter sido alterados; a limpeza restante não foi executada."
    exit 1
  fi
  # Cancela somente os registros comprovados, após confirmar que os bundles foram removidos.
  for app in ${APPS[@]+"${APPS[@]}"}; do "$LSREG" -u "$app" >/dev/null 2>&1 || true; done
  # Encerra aplicações pela identidade registrada pelo AppKit, nunca pelo nome do executável.
  # O registro da aplicação em execução continua disponível após remover seu bundle.
  osascript -l JavaScript -e '
    ObjC.import("AppKit");
    var ourIds = ["com.local.mixerdeaudio", "com.local.mixerdeaudio1024", "com.local.voicemod", "com.local.voicemod1024"];
    var running = $.NSWorkspace.sharedWorkspace.runningApplications;
    var ours = [];
    for (var i = 0; i < running.count; i++) {
      var app = running.objectAtIndex(i);
      if (ourIds.indexOf(ObjC.unwrap(app.bundleIdentifier)) >= 0) { ours.push(app); app.terminate; }
    }
    for (var attempt = 0; attempt < 15; attempt++) {
      if (ours.every(function(app) { return app.isTerminated; })) break;
      delay(0.2);
    }
    ours.forEach(function(app) { if (!app.isTerminated) app.forceTerminate; });
  ' >/dev/null 2>&1 || true
  echo "   ✓ apps e driver próprios removidos; dispositivos de terceiros preservados"
else
  if [ -f "$AUTHORIZED" ]; then
    echo "   ⚠ a remoção autorizada não terminou. Login/agregado podem já ter sido alterados; a limpeza restante não foi executada."
  else
    echo "   ⚠ senha não confirmada ou validação recusada — nenhuma alteração foi iniciada."
  fi
  exit 1
fi

# 4) Só APÓS o sucesso (sem senha): preferências, permissão de microfone e itens de login legados pelos
#    caminhos dos bundles identificados antes da remoção. O nome de um login item não prova sua origem.
echo "3) Limpando preferências, permissão de microfone e itens de login…"
for bid in "${OUR_IDS[@]}"; do
  defaults delete "$bid" >/dev/null 2>&1 || true
  tccutil reset Microphone "$bid" >/dev/null 2>&1 || true
done
if [ "${#APPS[@]}" -gt 0 ]; then
  osascript -e '
    on run approvedPaths
      tell application "System Events"
        repeat with loginEntry in (get every login item)
          try
            set itemPath to path of loginEntry
            if itemPath is in approvedPaths then delete loginEntry
          end try
        end repeat
      end tell
    end run
  ' "${APPS[@]}" >/dev/null 2>&1 || true
fi

# Atalhos (symlinks) na Mesa apontando para os apps removidos — identificados pelo ALVO do link
# (readlink), nunca pelo nome. Roda após a remoção (o alvo já não existe), por isso compara o texto
# do link com a lista APPS validada ANTES. PARIDADE: removeOurShortcuts() no interno.
while IFS= read -r lnk; do
  tgt=$(readlink "$lnk") || continue
  case "$tgt" in
    /*) abs="$tgt" ;;
    *)  abs="$(dirname "$lnk")/$tgt" ;;
  esac
  ours=0
  for a in ${APPS[@]+"${APPS[@]}"}; do [ "$abs" = "$a" ] && ours=1; done
  if [ "$ours" = "1" ]; then rm -f "$lnk" && echo "   • atalho da Mesa removido: $(basename "$lnk")"; fi
done < <(find "$HOME/Desktop" -maxdepth 1 -type l 2>/dev/null)

echo
if [ -n "$RESIDUO" ]; then
  echo "⚠ A desinstalação terminou com resíduos; confira o aviso acima."
else
  echo "✅ Pronto. O Mixer de Áudio e seu driver foram removidos."
fi
echo "   Se algum ícone antigo persistir no Launchpad/Dock, reiniciar o Mac limpa o cache."
echo
if [ -t 0 ]; then printf "Pode fechar esta janela. "; read -r _ 2>/dev/null || true; fi
