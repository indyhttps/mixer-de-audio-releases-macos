# Histórico do Mixer de Áudio

**Navegação:** [Mapa do projeto](INDEX.md) · [Manual de uso](../README.md) · [Notas atuais](releases/5.12.4.md)

Este arquivo preserva integralmente as entradas de versão que estavam no README. Elas descrevem o comportamento e as verificações de cada época; os procedimentos atuais ficam no [manual](../README.md) e no [guia de desenvolvimento](DEVELOPMENT.md).

---

## Versão 5.12.4 — desinstalação e envio de suporte — 2026-10-06

- **Remover só o app** respeita o cancelamento da autorização e confere os bundles restantes antes de limpar o estado de usuário ou anunciar sucesso. A identificação das cópias que precisam de autorização acontece antes de começar a remoção.
- O desinstalador externo espera a autorização e revalida as identidades antes de executar os utilitários de login/agregado como usuário e remover os arquivos. LaunchServices, preferências, permissão de microfone, atalhos e encerramento dependem da ausência confirmada dos bundles. Cancelar a senha preserva o estado; uma falha posterior informa que login/agregado podem já ter sido alterados e interrompe a limpeza restante.
- O marcador de conclusão dos utilitários é publicado por troca atômica, evitando que o passo autorizado leia um arquivo ainda vazio e interrompa a remoção indevidamente.
- O relay revalida o relógio depois do consumo do identificador do desafio e da checagem de limites, antes de encaminhar o relatório. Desafios que expirem durante essas esperas são recusados, impedindo replay após a limpeza do identificador usado.
- Metadados de versão, manuais e notas de distribuição atualizados. Captura, buffers, WSOLA, gate, presets, interface e driver 1.5 permanecem no estado da 5.12.3. Os resultados próprios desta correção ficam nas [notas 5.12.4](releases/5.12.4.md).
- Publicação e instalação concluídas: os dois ZIPs e seus downloads foram conferidos, a assinatura Ed25519 passou e a CI do commit da entrega aprovou os quatro jobs. O relay Sites v3 foi publicado separadamente; a release do Sentry foi sincronizada e o token temporário revogado. A documentação em `main` registra esses resultados após a publicação, preservando os ZIPs e a tag `v5.12.4` do repositório de fonte no commit `f011bf8186f3a3cf748ea0a488e723b26df0b6c0`.

## Versão 5.12.3 — limpeza e organização do projeto — 2026-10-06

- [Mapa do projeto](INDEX.md) reúne componentes, comandos, testes, distribuição, conectores e histórico. README e guia de desenvolvimento passam a oferecer navegação direta e tabelas de consulta. O visual aprovado do app e a disposição dos arquivos de fonte e recursos são preservados.
- Removidos os dois scripts e o workflow usados somente para testar uma skill de revisão, além de dois scripts históricos de remoção do driver de teste e do BlackHole.
- Metadados de versão, manuais e notas de distribuição atualizados. Fontes do aplicativo, motor WSOLA, gate, interface e driver 1.5 preservados em relação à 5.12.2.
- A limpeza dos caches e produtos locais de desenvolvimento libera espaço na máquina e não representa redução do aplicativo distribuído. Escopo, verificações e pendências ficam nas [notas 5.12.3](releases/5.12.3.md).

## Versão 5.12.2 — menor espera no áudio — 2026-10-06

- Captura e saída virtual solicitam ciclos equivalentes a 64 frames a 48 kHz, com fallback para ciclos maiores quando recusados. A captura normaliza o pedido pela taxa nativa do dispositivo.
- A fila de transmissão usa os ciclos concedidos de captura e saída, com reserva maior para Bluetooth. Faltas elevam a reserva automaticamente, sem descartar PCM pendente; rajadas maiores também ampliam o piso e o teto de recuperação.
- Falhas repetidas de prazo aumentam os ciclos de captura ou saída até o perfil de 256 frames. A primeira janela é aquecimento; picos isolados não provocam reconstruções.
- Leitura e escrita do buffer circular usam cópias contíguas em até dois segmentos, reduzindo a duração da seção crítica e a disputa entre callbacks. Ordem, bits, overflow e silêncio de underflow são preservados.
- Diagnóstico passa a medir também o prazo do processamento completo, incluindo WSOLA e gate.
- Motor WSOLA, reamostrador, gate, formato mono Float32/48 kHz, presets e driver 1.5 preservados. Evidências e limites ficam nas [notas 5.12.2](releases/5.12.2.md).

## Versão 5.12.1 — microfone sem repetição e rodapé compacto — 2026-10-06

- Quando o microfone escolhido está ativo, o painel mostra seu nome uma única vez e apresenta **Em uso** na linha de estado.
- Ao seguir o padrão do sistema, usar fallback ou atravessar uma troca de fonte, o estado conserva **Em uso: nome** com a fonte realmente capturada. Sem captura, conserva **Em uso: nenhum**.
- A identidade do dispositivo, pelo UID, determina quando o nome já está apresentado; microfones diferentes com o mesmo nome não são confundidos.
- O rodapé apresenta uma cápsula de vidro com símbolo do sistema e estado curto. O clique abre um popover nativo com título, estado completo, aviso recente e botão centralizados; **Todos os avisos…** conserva o acesso ao histórico da sessão. Um aviso transitório tem prioridade como **Novo aviso**.
- **Estado e avisos** conserva o formulário nativo agrupado e apresenta títulos, mensagens, horários e histórico vazio centralizados. A janela abre com altura compacta e continua permitindo rolagem e redimensionamento.
- Mensagens de estado, calibração, nível e avisos usam inicial maiúscula na apresentação, incluindo o popover e seu valor de acessibilidade. Os textos e o histórico armazenados permanecem intactos.
- O painel conserva o visual de vidro da Central de Controle e seus controles anteriores. As cinco ações são distribuídas uniformemente na linha, mantendo Reconectar, Fechar, Sair, Diagnóstico e Desinstalar.
- Driver 1.5, motor WSOLA, gate, preset calibrado e roteamento permanecem inalterados. As evidências próprias desta entrega ficam nas [notas 5.12.1](releases/5.12.1.md).

## Versão 5.12.0 — microfone único — 2026-10-06

- O driver **1.5** oferece uma única entrada: **Mixer de Áudio — Microfone**, para todos os aplicativos consumidores. Seu nome e UID dedicado são preservados.
- **Mixer de Áudio** mantém nome e UID para o motor escrever o áudio, mas passa a ter somente saída; sua antiga entrada, stream e controles de entrada deixam de ser publicados.
- Consumidores com a entrada antiga salva precisam selecionar **Mixer de Áudio — Microfone** manualmente. Reabra os aplicativos de áudio após atualizar o driver.
- O app distingue a saída de alimentação da entrada dedicada no roteamento, nas verificações e nas instruções. Ambos os dispositivos continuam excluídos da captura física do Mixer.
- Motor WSOLA, preset e gate permanecem inalterados. A topologia única não comprova funcionamento em todos os consumidores ou recuperação automática de AirPods; resultados e pendências ficam nas [notas 5.12.0](releases/5.12.0.md) e na [matriz de compatibilidade](COMPATIBILITY.md).

## Versão 5.11.2 — instalação única — 2026-10-05

- O instalador temporário é removido depois de validar a instalação definitiva. Atualizações canceladas ou falhas preservam o instalador para nova tentativa.
- Somente o caminho `/Applications/Mixer de Áudio.app` inicia o aplicativo; cópias renomeadas em Aplicativos passam pelo fluxo de instalação.
- A abertura corrige registros e atalhos duplicados do próprio Mixer, preservando os demais aplicativos e a posição do primeiro atalho no Dock.

## Versão 5.11.1 — controles visíveis e janelas nativas — 2026-10-05

- O painel principal conserva a composição compacta da Central de Controle com Liquid Glass nativo no fundo das superfícies. Preferências, Diagnóstico, Presets, Guia e Avisos usam formulários, listas e janelas nativas de SwiftUI/AppKit, tendo o UI Kit oficial do macOS 27 como referência.
- Textos e controles ficam fora da captura do material de vidro; a camada decorativa não intercepta cliques. Isso evita cartões vazios e preserva o conteúdo interativo. Reduzir Transparência e Aumentar Contraste usam superfícies opacas e cores semânticas. O app continua na barra de menus e mantém mínimo macOS 15.
- Nomes de presets importados passam a ser normalizados antes de persistir, conservando o uso após salvar novamente. Importação, troca de canal/fonte e desligamento cancelam calibrações incompatíveis; eventos de dispositivo atualizam também saídas e canais.
- Instalação usa staging verificado e backup até a validação final, inclusive no caminho elevado. Desinstalação revalida ids, encerra processos por identidade e preserva BlackHole, Voicemod comercial e outros programas/plugins de terceiros.
- O relay rejeita JSON nulo, arrays e valores primitivos com HTTP 400 antes de consultar o banco ou enviar conteúdo ao suporte.
- As notas da versão atual acompanham os dois ZIPs; a validação de distribuição rejeita pacotes sem esse documento.
- Driver 1.4, motor WSOLA, gate e valores do preset permanecem inalterados. A correção não requer reinstalar o driver 1.4 já presente.

Os resultados da verificação nativa e os limites desta correção ficam nas [notas 5.11.1](releases/5.11.1.md).

## Versão 5.11.0 — driver recompilado e distribuição verificável — 2026-10-05

- Driver **1.4** como revisão de empacotamento, para substituir o bundle 1.3 instalado por um novo bundle compilado do fonte. O código C do driver e o motor WSOLA permanecem inalterados; o binário 1.3 arquivado em Vendor não é modificado.
- Build e release compilam o driver universal obrigatoriamente, conferem o mínimo macOS 15 e associam fonte, commit, binários e ZIPs por manifestos.
- A instalação do próprio driver solicita senha na janela do macOS e faz uma única recarga do CoreAudio. Execute fora de chamadas e reabra o Safari após a atualização.

As demais alterações e os resultados da validação/publicação desta versão são registrados em suas notas e em `REVISAO-CETICA.md`.

## Versão 5.10.4 — microfone compatível com Safari/Meet — 2026-09-16

- O driver **1.3** acrescenta **"Mixer de Áudio — Microfone"**, com entrada estéreo a 48 kHz
  e nenhuma saída. O endpoint duplex original continua recebendo o áudio do app e permanece
  disponível para configurações existentes.
- A entrada dedicada evita oferecer a voz processada como referência de saída ao cancelamento
  de eco do macOS. Validada em macOS 26.5.2 com Safari 26.5.2 e Google Meet.
- Ambos os dispositivos do Mixer são excluídos das fontes do próprio app, inclusive quando
  definidos como microfone padrão do macOS, para impedir realimentação.
- O motor WSOLA, o preset e o processamento de voz permanecem inalterados.
- O ring compartilhado usa amostras atômicas para o escritor e os leitores dos dois
  dispositivos acessarem o áudio sem data race e sem travas no caminho de tempo real.
- O bundle compilado deixou de ser versionado na raiz do projeto. As releases usam staging
  temporário e distribuem ZIPs, para evitar ícones extras originados por cópias de compilação.
- Com AirPods, conecte os fones antes de abrir o Safari; a troca durante uma sessão pode
  exigir encerrar e reabrir o navegador. A recuperação automática ainda não foi validada.

## Versão 5.7 — vigia de atualização + esteira de publicação — 2026-07-10

- **Verificação periódica de atualização**: o app de barra de menu fica semanas aberto — antes,
  quem nunca reabria nunca atualizava (a checagem era só na abertura). Agora, a cada **24 h**
  (`defaults write com.local.mixerdeaudio mixerdeaudio.updateCheckHours -float <horas>`; 0
  desliga), o app pergunta se há versão nova e, havendo, **só mostra um item no menu**
  ("Atualizar para vX.Y — reabre o app") — trocar e reiniciar sozinho no meio de uma call
  derrubaria a voz; a troca acontece no seu clique, pelo mesmo caminho validado da abertura.
- **`./publicar.sh`** (espelho do `LancarRelease` do Windows): tag + release + upload + conferência
  de SHA-256 nos **dois** repositórios (privado completo + público só-app) num comando — elimina o
  risco de publicar num só e deixar o auto-update cego.
- Badge do CI no topo deste README; receita da deploy key (mudanças no workflow) no CLAUDE.md.

---

## Versão 5.6 — atualização automática — 2026-07-10

- **O app agora se atualiza sozinho** (paridade com o Windows 1.0.7): ao abrir, confere em
  segundo plano o repositório público de downloads
  ([mixer-de-audio-releases-macos](https://github.com/indyhttps/mixer-de-audio-releases-macos));
  havendo versão mais nova, baixa o zip, **valida** (bundle id, assinatura, versão de fato maior —
  anti-downgrade mesmo se a tag mentir), troca o app em `/Applications` e **reabre sozinho**.
  Qualquer falha (sem internet, API fora, disco cheio): loga e desiste em silêncio — a atualização
  nunca pode atrapalhar a voz. Só o app **instalado** se atualiza (cópias de teste ficam quietas).
  Para desligar: `defaults write com.local.mixerdeaudio mixerdeaudio.autoUpdate -bool false`.
- O `release.sh` agora gera **dois** zips validados: o completo de sempre (com código-fonte, para
  a release deste repo privado) e o `mixer-de-audio-macos.zip` **só-app** (sem código-fonte),
  publicado no repo público que o atualizador consulta.
- **CI**: os 14 testes do motor rodam no GitHub Actions a cada push (`.github/workflows/testes.yml`).

---

## Versão 5.5 — paridade com o Windows + dreno de backlog — 2026-07-10

- **Dreno de backlog nos rings** (lição medida na versão Windows): os dois lados de cada ring
  rodam em relógios nominalmente iguais, então atraso que entra (rajada Bluetooth, churn de
  dispositivos, drift) **nunca drenava sozinho** — virava latência de voz permanente, até 1 s.
  Agora a ocupação é medida **no vale** (antes de cada escrita); excesso sustentado por ~2 s
  descarta o pendente de uma vez: um pulinho único e a latência volta ao piso do colchão.
  Transientes não disparam (provado por harness: zero drenos em regime saudável e em rajadas).
  Cada dreno sai no log (`micRing`/`monRing`).
- **`Vendor/MixerDsp` re-sincronizado byte a byte com o repo Windows** (que avançou até a
  v1.0.12): `try/catch` no construtor da ponte C (um `bad_alloc` não pode atravessar a ABI C),
  `DenormalGuard` no processamento (blindagem de subnormais; **no-op fora de x86** — em Apple
  Silicon subnormal não custa nada) e `MixerConfig.h` com o preset recalibrado de lá (24/47 —
  constantes **dormentes** no macOS; o preset daqui vive em `Config.swift`, 23/47). **O motor
  WSOLA não mudou um byte** — som idêntico.

---

## Versão 5.4 — latência menor fora do DSP — 2026-07-06

- Colchão do `micRing` **adaptativo**: 15 ms em transporte de baixo jitter (mic embutido, USB,
  Thunderbolt, PCI) capturando em ciclos ≤ 256 frames; 25 ms conservadores em Bluetooth.
  Ciclos de I/O de 256 frames pedidos à captura e aos engines. Ganho de ~20–25 ms com mic
  cabeado/embutido (AirPods ≈ 5 ms). O WSOLA não foi tocado — mesmo som.

---

## Versão 5.3 — monitor ("ouvir minha voz") ainda mais rápido — 2026-07-05

- Cortes que afetam **só o monitor** (a latência para os apps/Discord não muda): colchão do
  `monRing` 25 ms → **15 ms** e rajada do tap 512 → **256 frames** (~5,3 ms). Dropout no monitor
  atinge só a própria usuária e se auto-recupera, por isso ele pode ser mais agressivo que o
  caminho da transmissão (que segue conservador em 25 ms). Falhas ao se ouvir? Os dois knobs e os
  valores de volta estão comentados em `AudioGraph.swift`.
- Latência restante do monitor é dominada pelo motor WSOLA (75 ms, compartilhado com o Windows) e,
  se a saída for **Bluetooth (AirPods), pelo próprio Bluetooth (~100–200 ms)** — para se monitorar
  com o mínimo de atraso, use fone com fio.

---

## Versão 5.2 — desinstalação sem resíduos + monitor mais rápido — 2026-07-05

- **Os DOIS desinstaladores agora removem os atalhos da Mesa** (symlinks) que apontem para os apps
  removidos — identificados pelo **alvo** do link, nunca pelo nome (atalho seu com nome parecido
  apontando para outra coisa não é tocado). Antes, desinstalar deixava um atalho quebrado na Mesa.
- **Monitor ("ouvir minha voz") mais responsivo**: o tap que o alimenta passou de rajadas de 1024
  para **512 frames** (~10,7 ms) — o monitor agora aproveita de verdade o colchão de 25 ms da v5.1.
  A latência para os apps (Discord) não muda (já era a menor).
- `project.yml` (xcodegen, opcional) dessincronizado: dizia versão 3.0 — alinhado a **5.2**. Se o
  app fosse gerado por esse caminho, nasceria "3.0" e o anti-downgrade recusaria a atualização.

---

## Versão 5.1 — latência menor + suíte de testes — 2026-07-05

- **Latência até os apps (Discord etc.) reduzida em ~25 ms**: o colchão anti-microcorte dos ring
  buffers (entre a captura do microfone e o motor, e no caminho do monitor) caiu de 50 ms para
  **25 ms** — ainda cobre a rajada do Bluetooth/HFP. O som NÃO muda (nenhum toque no DSP); apenas
  chega antes. Se aparecerem microcortes em uso real, o valor volta num único lugar
  (`AudioGraph.swift`, `primeFrames`). A latência algorítmica do motor WSOLA segue 75 ms
  (compartilhada byte-a-byte com o Windows — reduzi-la é possível, mas muda o som e exige A/B).
- **Suíte de testes permanente do motor** (`Tests/MixerDspTests`, 14 testes, ~1 s): neutro
  bit-exato, latência, determinismo, F0 pós-shift, preset 23/47, toggle sem clique, NaN/Inf.
  Rode com `./test.sh` antes de mexer no DSP. Também: `CLAUDE.md` (piso operacional), exceção do
  app pronto no `.gitignore` e comentário "correto de propósito" no driver (escopo Global).
- `CFBundleVersion` 4.2 → **5.1** (a 5.0 saiu sem o bump; o anti-downgrade do auto-instalador
  compara versões e precisa do número certo para atualizar instalações antigas).

---

## Versão 5.0 — motor WSOLA (som natural estilo Clownfish), igual ao Windows — 2026-06-27

O motor de pitch foi **trocado**: saiu o *phase vocoder* (FFT, `FormantPitchShifter`) e entrou o
**WSOLA** (*Waveform-Similarity Overlap-Add* + reamostragem com anti-aliasing, `WsolaPitchShifter`
em C++) — o mesmo tipo de algoritmo que o Clownfish/SoundTouch usa. É o que dá a **voz natural, sem
o caráter "fásico/metálico"** do vocoder. Esse é exatamente o motor da **versão Windows**: o código
em `Vendor/MixerDsp/` é **byte-idêntico** ao do repo `MixerDeAudio-Windows` (fonte única de DSP — o
Swift fala com ele por uma ponte C `extern "C"`, sem reescrever o algoritmo).

**O que muda na prática:**

1. **Som mais natural** — tom e formantes andam juntos (como uma pessoa de trato vocal maior ou
   menor), sem o "metálico" do phase vocoder.
2. **Latência do pipeline = 75 ms** (3600 amostras @ 48 kHz; geometria: overlap 10 ms, sequência
   30 ms, busca 15 ms). O vocoder antigo tinha ~85,3 ms (FFT n=4096) — ou seja, **ficou mais curta**.
3. **Tom e Timbre agora são ACOPLADOS** — o WSOLA aplica uma transposição única
   `t = Altura × Timbre`. O slider **"Timbre" deixa de ser formante independente** (não dá mais para
   "subir a Altura e segurar o Timbre contra o esquilo" — isso era específico do vocoder). É o mesmo
   comportamento da versão Windows. Por isso o preset **"Voz Feminina" (+24/+30) pode pedir um
   reajuste fino no ouvido**: os números continuam válidos, mas agora significam transposição
   combinada.
4. **"Voz mais natural" virou no-op** — aquele motor V2 (consoantes/transientes/soprosidade) era
   específico do phase vocoder; o WSOLA o ignora. A preferência (`mixerdeaudio.naturalVoice`) ainda
   é lida e salva, mas **não altera o som**.

**Preservado:** o **neutro bit-exato** (Altura 0 / Timbre 0 = sua voz crua, atrasada só pelo
pipeline, com transição suave de 5 ms) continua valendo — agora dentro do WSOLA. Transições de
parâmetro e de liga/desliga seguem **sem clique**. O *phase vocoder* foi mantido no código
(`FormantPitchShifter`, **desconectado**) só para comparação A/B e reversão rápida.

**Verificação:** harness numérico do WSOLA **7/7** (saída finita; razão de pitch correta subindo e
descendo; neutro bit-exato; determinismo; resiliência a NaN/Inf; liga/desliga sem clique); build
**universal** (arm64 + x86_64) limpo.

**Correção de distribuição (driver, 1.1):** o `.driver` foi **recompilado com
`-mmacosx-version-min=15.0`**. Antes ele saía com *deployment target* = versão do SDK (ex.: 26.x) por
falta do flag, e o `coreaudiod` **recusava carregá-lo** num Mac mais antigo que o SDK (o dispositivo
"Mixer de Áudio" não aparecia) — quebrava a instalação em máquinas de outras pessoas no macOS 15. O
binário do driver agora casa o mínimo anunciado (15.0) em Intel e Apple Silicon. (Funcionalidade do
driver inalterada — mesma 1.1.)

---

## Correções da versão 3.1 (app) / 1.1 (driver) — 2026-06-09

**Sintomas corrigidos (relatados):**

1. **"Me ouço com 'Ouvir minha voz' DESLIGADO depois que o Mac dorme/acorda"** — ao acordar, o
   coreaudiod renumera os dispositivos e o motor ficava preso ao número antigo: a voz com pitch
   vazava para os alto-falantes (não era o monitor — por isso desligar o toggle não resolvia).
   Agora: o app derruba o áudio ao dormir, reconstrói ao acordar, valida o vínculo REAL dos
   engines a cada verificação e observa o reinício do coreaudiod.
2. **"AirPods na case/fora da case não atualizam a lista"** — o app agora observa vida e canais
   de TODOS os dispositivos (a transição Bluetooth não gera evento de lista), atualiza a lista
   fora da main thread (sem congelar a UI) e faz um segundo refresh ~2,5 s depois.
3. **"Ouvir minha voz liga sozinho e não desliga"** — além da causa nº 1, o dispositivo virtual
   repetia em loop os últimos ~1,4 s de voz quando o motor parava de escrever (apps continuavam
   ouvindo a "voz fantasma"). O driver 1.1 ganhou uma marca-d'água: leitores só recebem o que o
   motor realmente escreveu — sem writer, silêncio.

**Outras correções importantes:** o macOS não pode mais promover o "Mixer de Áudio" a SAÍDA
padrão do sistema sozinho (era a causa de "o som do Mac some" quando os AirPods desconectavam;
consequência: o device não aparece mais como opção de saída em Ajustes ▸ Som — de propósito);
o instalador não rebaixa mais o app/driver para versões antigas (clicar num atalho velho só abre
o app instalado); o driver instalado é ATUALIZADO automaticamente quando o app traz uma versão
mais nova (uma senha); entrada padrão apontando para o próprio Mixer agora cai para um microfone
real em vez de travar; dezenas de correções de robustez (corridas de thread, relógio do driver,
recuperação automática com backoff, reset do DSP, instalação com staging atômico).

---

## Versão 3.2 — motor de voz "mais natural" (2026-06-10)

*(Nota histórica: o toggle saiu do painel na v3.9 e o padrão passou a ser o motor clássico. Desde a
**v5.0** (motor WSOLA) este modo "Voz mais natural" é **no-op** — eram melhorias específicas do phase
vocoder; o WSOLA já é naturalmente natural e ignora o parâmetro. Ver a seção **Versão 5.0**.)*

Novo toggle **"Voz mais natural"** no painel (ligado por padrão). Três melhorias de realismo no
motor de voz, todas com efeito imediato (sem blip) e com A/B honesto — **desligado = motor
anterior, bit-idêntico** (validado por comparação bitwise):

1. **Consoantes naturais** — s, f, ch são ruído, não têm "altura"; o motor antigo as deslocava
   junto (efeito robótico/esquilo nas consoantes). Agora um detector de vozeamento por quadro
   deixa as consoantes intactas e desloca só as vogais (validado: ruído puro atravessa o motor
   sem alteração de brilho; vogais continuam deslocadas exatamente pelo fator pedido).
2. **Ataques nítidos** — em transientes (plosivas/início de sílaba) as fases de síntese são
   realinhadas às de análise, eliminando o "borrão" acumulado do phase vocoder.
3. **Soprosidade sutil** — leve ruído de aspiração (2,5–9 kHz, moldado pelos formantes, ~−6 dB
   da estrutura fina local, com fade contínuo pelo vozeamento): assinatura acústica de voz
   feminina real, presente só nos trechos vozeados.

Se preferir o som antigo, é só desligar o toggle — a preferência fica salva.

---

## Versão 4.2 — revisão final (2026-06-10)

Auditoria cética completa do código (26 agentes + regressão bitwise do DSP + build sem
warnings): **nenhum bug funcional**. Ajustes de acabamento: o **padrão de fábrica do motor
passou a ser o clássico** (o toggle "Voz mais natural" não existe mais — instalação nova
não pode nascer com o V2 ligado sem ter como desligar; quem tem preferência salva continua
com ela) e comentários/README defasados foram atualizados (preset +24, seções antigas).

---

## Versão 4.1 — ações em círculos, como a Central de Controle real (2026-06-10)

A pedido ("esses botões não estão muito elegantes"): os quatro botões-laje (Reconectar
microfone / Fechar / Sair / Desinstalar) viraram **uma fileira de botões circulares de
vidro com ícone e legenda** — a mesma linguagem dos círculos da Central de Controle real
(captura/espelhamento). "Sair" é o único colorido (vermelho = destrutivo). Os presets
−7…+7 viraram **cápsulas** (pílulas). O painel ficou mais baixo (726). Tudo nativo.

---

## Versão 4.0 — preset "Voz Feminina" recalibrado (2026-06-10)

O preset **"Voz Feminina"** (e o padrão de fábrica de instalações novas) agora é
**Altura +24 / Timbre +30** (antes +17/+30), calibrado pela usuária. Fonte única em
`Config.swift` (`femininePitchStep`/`feminineFormantStep`).

---

## Versão 3.9 — Liquid Glass de volta, sem o toggle "Voz mais natural" (2026-06-10)

A pedido: o painel voltou ao **visual Liquid Glass estilo Central de Controle** (o design
das versões 3.3–3.5, com módulos de vidro translúcido, proporções naturais da Apple e a cor
de destaque do sistema) — o experimento "Ajustes do Sistema" da 3.8 e os cartões inflados
da 3.6/3.7 foram descartados. O interruptor **"Voz mais natural" saiu do painel** (pedido);
o **padrão agora é o motor clássico** (em instalações novas e para quem nunca mexeu no
toggle; quem já tinha preferência salva continua com ela) — **o som não muda em nada**.
Para experimentar o motor V2 sem o toggle: `defaults write com.local.mixerdeaudio
mixerdeaudio.naturalVoice -bool true` (e reabrir o app). Painel 320×802.

---

## Versão 3.8 — visual nativo "Ajustes do Sistema" (2026-06-10)

A pedido ("aparência mais próxima dos apps da Apple"): a janela foi **reescrita com o
componente nativo de formulário agrupado do macOS** — o mesmo do app Ajustes do Sistema.
Seções "Voz", "Microfone", "Opções" e app; linhas com a métrica padrão da Apple; fundo
claro/escuro automático; barra de título normal com fechar/minimizar nativos (fechar
esconde a janela; o áudio continua). Os tiles Voz/Microfone viraram interruptores nativos
("Alteração de voz" e "Silenciar microfone"); o botão "Fechar" saiu (a janela agora tem o
botão nativo); todo o visual custom anterior (vidro/Control Center) foi removido.

---

## Versão 3.7 — painel largo em duas colunas (2026-06-10)

A pedido: o painel ficou **mais largo (622 pt) e em duas colunas** para caber tudo numa
janela só, **sem rolagem**: à esquerda a voz (Voz Feminina/Neutro, Altura, Timbre, tiles
Voz/Microfone, presets); à direita o microfone e o comportamento (seletor, Voz mais
natural, Ouvir minha voz, Iniciar no login, Reconectar); embaixo, Fechar/Sair, status e
Desinstalar. Mantidas a altura única de 76 pt dos cartões (v3.6) e a UI 100% nativa.

---

## Versão 3.6 — painel com cartões de altura única (2026-06-10)

A pedido: a linha **Microfone**, os interruptores (Voz mais natural / Ouvir minha voz /
Iniciar no login) e os botões (Reconectar / Fechar / Sair / Desinstalar) agora têm
**exatamente a mesma altura** dos cartões "Altura (tom)" e "Timbre (formantes)" (76 pt,
token único `unifiedRowHeight`). O painel ficou mais alto que muitas telas de MacBook —
a janela se limita à altura visível da tela e o conteúdo **rola** quando não couber
(sem rolagem em telas grandes). Controles continuam 100% nativos do macOS.

---

## Versão 3.5 — neutro transparente + menos "esquilo" (2026-06-10)

*(Nota histórica: descreve o motor *phase vocoder* legado. Desde a **v5.0** o motor é o WSOLA — a
latência é **75 ms** (não ~85 ms), o **Timbre é acoplado ao tom** (a dica anti-"esquilo" de "segurar
o Timbre" não se aplica mais) e o lifter adaptativo de "Voz mais natural" virou no-op. O **neutro
bit-exato** continua valendo. Ver a seção **Versão 5.0**.)*

Duas melhorias no motor de voz, a partir de uma análise externa do DSP (validada e corrigida
— a proposta original tinha um erro de alinhamento de 10,7 ms e um erro de faixa na busca de
F0, ambos consertados antes de aplicar):

1. **Altura 0 / Timbre 0 agora é a sua voz DE VERDADE** — antes, mesmo "em 0", o áudio
   passava pelo motor inteiro (a fase era re-sintetizada e, com "Voz mais natural" ligado,
   ainda entrava soprosidade): sobrava um leve borrão. Agora, quando os dois sliders mostram
   0, a saída é a entrada crua **bit-exata** (só com o atraso normal do pipeline, ~85 ms),
   com uma transição suave de 5 ms ao entrar/sair do neutro. O limiar casa com o que o painel
   exibe: se a barra mostra "0", o bypass está ativo.
2. **Menos "esquilo" ao subir o tom** (só com **"Voz mais natural" LIGADO**) — o envelope de
   formantes agora se adapta ao tom da sua voz nos trechos vozeados (lifter cepstral segue o
   F0, com gate de vozeamento e histerese): o envelope acompanha os formantes mais de perto e
   menos timbre "vaza" para a parte que é deslocada. **Desligado = motor anterior bit-idêntico**,
   como sempre (a garantia vale para o toggle mantido desligado; ao alternar há ~100 ms de
   acomodação da suavização do envelope — efeito análogo ao que o motor já tinha).

Dica de uso contra o esquilo: o caminho do timbre mais natural é **subir a Altura e segurar o
Timbre** — timbre acima de ~+30 já é, por definição, formante para cima (mais "esquilo").

---

## Versão 3.4 — correções de robustez e acabamento (2026-06-10)

Resultado de uma auditoria completa do código (motor de áudio, DSP, dispositivos, UI,
scripts e driver). Três correções; **nenhuma mudança no som** (driver continua 1.1):

1. **Reinício do coreaudiod mais limpo** — quando o serviço de áudio do macOS reinicia
   (ex.: atualização de driver), os "vigias" dos dispositivos em uso ficavam apontando para
   números antigos, que o sistema pode REAPROVEITAR para outro aparelho — podia gerar um
   falso alarme de "microfone desconectado" durante o ~1 s da reconstrução. Agora eles são
   derrubados na hora e re-armados com os números novos.
2. **Nome do microfone não corta mais no fim** — no seletor de microfone, nomes longos
   (ex.: AirPods com nome de pessoa) agora encurtam no MEIO ("AirPods … Ingrid"), como nas
   demais linhas do painel.
3. **Texto do "Ouvir minha voz" cabia cortado** — o subtítulo "Toca sua voz alterada na
   saída do sistema" era mais largo que o espaço da linha (medido: 203 pt num espaço de
   ~178 pt) e truncava. Reescrito como "Sua voz alterada na saída do Mac" (cabe inteiro).

A auditoria também *confirmou como corretos* (sem mudança) os pontos mais delicados:
o descarte acima de Nyquist no pitch-shift (anti-aliasing correto), a normalização do
overlap-add (convenção smbPitchShift, validada bit-a-bit), o escopo Global nas notificações
de volume do driver (convenção oficial da Apple/NullAudio.c) e o ring buffer wait-free.

---

## Versão 3.3 — otimização e visual do sistema (2026-06-10)

- **~30% menos CPU no motor de voz, com som BIT-IDÊNTICO** — a FFT agora usa tabelas
  pré-computadas (mesma aritmética, mesmos bits na saída; provado por comparação bitwise contra
  a versão anterior nos dois modos do motor). Nenhuma mudança audível — é matematicamente o
  mesmo áudio, calculado mais rápido.
- **Visual idêntico ao do seu Mac** — a cor de destaque dos controles agora é a COR DO SISTEMA
  (a mesma dos toggles da Central de Controle real; acompanha Ajustes ▸ Aparência e o modo
  claro/escuro). Antes era um índigo fixo, mais roxo que o azul padrão. E o painel perdeu os
  3 botões de janela (fechar/minimizar/zoom) — a Central de Controle não os tem; feche pelo
  botão "Fechar" do painel, pelo ícone da barra de menus ou com Cmd+W.
