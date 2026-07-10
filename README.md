# Mixer de Áudio — downloads (macOS)

Alterador de voz em tempo real para macOS: altura (tom) e timbre, entregues aos outros
programas (Discord, OBS, navegador, jogos) por um microfone virtual próprio.

> Este repositório é **só de downloads**. Pegue a versão mais nova na página de
> [**Releases**](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases) —
> arquivo `mixer-de-audio-macos.zip` (app + desinstalador + instruções).

## Instalar

1. Baixe o `mixer-de-audio-macos.zip` da release mais recente e descompacte.
2. Arraste **Mixer de Áudio.app** para a pasta **Aplicativos**.
3. Na primeira vez: **botão direito → Abrir** (o app não é notarizado) e autorize o
   microfone em Ajustes do Sistema → Privacidade e Segurança → Microfone.

Requisitos: **macOS 15 ou mais novo** (Apple Silicon e Intel).

## Atualizações

O app confere este repositório ao abrir e **se atualiza sozinho** quando há versão nova
(baixa, valida e reabre — sem cliques). Para desligar:

```
defaults write com.local.mixerdeaudio mixerdeaudio.autoUpdate -bool false
```

## Desinstalar

O desinstalador completo (`Desinstalar Mixer de Áudio.command`) vem dentro do zip —
remove o app, o dispositivo virtual e as preferências, sem deixar resíduos.
