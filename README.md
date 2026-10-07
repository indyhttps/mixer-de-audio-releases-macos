# Mixer de Áudio — downloads para macOS

**Acesso rápido:** [Baixar e instalar](#instalar-ou-atualizar) · [Configurar e usar](#configurar-e-usar) · [Validação atual](#validação-da-5123) · [Mapa do projeto](docs/INDEX.md) · [Histórico](docs/CHANGELOG.md)

O Mixer altera sua voz em tempo real e entrega o resultado a chamadas, gravações e jogos pelo seu próprio microfone virtual. Este repositório distribui o aplicativo; o código-fonte permanece no [repositório privado do projeto](https://github.com/indyhttps/MixerDeAudio-macOS).

Baixe o **mixer-de-audio-macos.zip** na [release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest). O pacote contém aplicativo universal, driver, desinstalador e documentação. Requisitos: **macOS 15 ou mais novo**, Apple Silicon ou Intel.

| Preciso… | Abrir |
|---|---|
| Baixar o aplicativo | [ZIP da release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest/download/mixer-de-audio-macos.zip) |
| Conferir a assinatura do pacote | [Assinatura Ed25519](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest/download/mixer-de-audio-macos.zip.sig) |
| Consultar pacotes e notas anteriores | [Todas as releases](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases) |
| Encontrar manuais e informações do projeto | [Mapa do projeto](docs/INDEX.md) |

## Versão 5.12.3

A [5.12.3 está publicada](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/tag/v5.12.3), com a limpeza e a organização do projeto. Esta atualização de manutenção organiza os manuais no [mapa do projeto](docs/INDEX.md) e remove cinco arquivos históricos do projeto: os testes e o workflow de uma skill de revisão, além de dois scripts antigos de remoção. O código do aplicativo, a interface, o processamento de voz e o driver 1.5 conservam o estado da 5.12.2. A limpeza dos caches locais de desenvolvimento não representa redução do aplicativo distribuído. As [notas 5.12.3](docs/releases/5.12.3.md) registram o escopo e a validação desta entrega.

A [5.12.2 anterior](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/tag/v5.12.2) reduziu a espera nos buffers: captura e saída virtual solicitam ciclos menores, a fila acompanha as rajadas reais e mantém mais reserva para Bluetooth. A reserva aumenta se faltar áudio; falhas repetidas de prazo levam a ciclos maiores. As cópias do buffer circular também ficaram mais curtas.

O processamento de voz, o reamostrador, o gate e o preset calibrado continuam iguais. Testes comparam o PCM por bits em diferentes tamanhos de blocos, taxas e transições. A versão conserva o **driver 1.5**, com uma única entrada virtual: **Mixer de Áudio — Microfone**. O dispositivo **Mixer de Áudio** tem somente a saída que alimenta esse microfone.

Na validação da 5.12.2 com AirPods Pro 3, a estimativa caiu de 121,3 para 103–108 ms, conforme a reserva necessária. A medição de fala deu **90,0 ms**, confiança moderada e resolução de 5,0 ms, do microfone físico à entrada virtual; não inclui fones nem navegador/chamada. A usuária confirmou som preservado e sem estalos ou cortes ao ouvir a voz com o microfone do MacBook Pro. O ganho depende do hardware e da carga do Mac; as [notas 5.12.2](docs/releases/5.12.2.md) e a [matriz de compatibilidade](docs/COMPATIBILITY.md) registram os cenários e limites.

O painel conserva a composição compacta da Central de Controle, com Liquid Glass nativo, a fonte **Em uso**, cinco ações distribuídas uniformemente e uma cápsula de estado no rodapé. Clique nela para ler os detalhes do áudio e os avisos; **Todos os avisos…** abre a janela nativa com histórico, rolagem e redimensionamento.

O aplicativo mantém uma única instalação definitiva em **/Applications/Mixer de Áudio.app**. A instalação valida o novo aplicativo e preserva a versão anterior até conferir a troca. Depois de validar o destino, o programa remove o próprio instalador temporário. Uma atualização cancelada ou falha mantém o instalador disponível para nova tentativa. Os registros e atalhos duplicados próprios são corrigidos, preservando os demais aplicativos e a posição do primeiro atalho no Dock.

## Instalar ou atualizar

1. Extraia o ZIP e abra **Mixer de Áudio.app**. O instalador coloca o aplicativo em **Aplicativos** e abre a instalação definitiva.
2. Autorize o acesso ao microfone quando o macOS solicitar. Depois, abra o Mixer em **Aplicativos** ou pelo atalho no **Dock**.
3. Se estiver usando o driver 1.4 ou anterior, confirme a instalação do **driver 1.5** na janela de administrador. Essa troca recarrega o serviço de áudio; faça fora de uma chamada e reabra os aplicativos de áudio depois. Quem já tem o driver 1.5 não precisa trocá-lo para receber a atualização de manutenção 5.12.3.

Encerre uma chamada antes de reiniciar o Mixer. A cópia externa mais nova instala ou atualiza o aplicativo e abre a versão instalada, sem rebaixá-la ao abrir uma cópia antiga.

A distribuição usa assinatura de código **ad-hoc**, com autenticação **Ed25519 do ZIP** para o updater. Developer ID e notarização Apple continuam pendentes; este pacote não é anunciado como notarizado. O manual dentro do ZIP descreve a abertura de um download confiável quando o macOS solicitar aprovação.

## Configurar e usar

Escolha seu **microfone real** dentro do Mixer. Em **Meet/Safari, Discord, OBS, FaceTime e demais aplicativos**, selecione **Mixer de Áudio — Microfone** como entrada. Use seus fones ou alto-falantes físicos como saída; **Mixer de Áudio** é a saída interna de alimentação e não deve ser escolhida como saída da chamada.

No **FaceTime**, escolha o microfone dedicado no menu **Vídeo**. Para um app que usa a entrada padrão do Mac, selecione **Mixer de Áudio — Microfone** em **Ajustes do Sistema → Som → Entrada**. Nesse caso, mantenha um microfone físico fixado dentro do Mixer. Aplicativos com seleção própria podem exigir a escolha dentro deles.

Confira **Voz: Ligado**, **Microfone: Enviando**, a fonte **Em uso** e o medidor **Saída**. **Microfone: Mudo** interrompe o envio e **Voz: Desligado** desliga o processamento. **Voz Feminina** aplica a voz calibrada; **Neutro** volta aos valores originais. Os sliders permitem ajustar altura e timbre.

As opções do painel abrem Preferências, Presets de voz e Guia. Os botões circulares **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar** refaz o roteamento; **Diagnóstico** gera um relatório local para leitura.

Conecte AirPods antes de abrir o Safari. Se uma troca de fones durante a chamada interromper a voz, saia da chamada e reabra o Safari; a recuperação automática desse cenário ainda precisa de validação.

## Gate, canal e monitor

**Calibrar** prepara o microfone, mede 3 segundos de silêncio e 5 de fala, e ajusta o gate. A calibração fica associada ao microfone real; dispositivos ainda não calibrados usam o valor de fallback. O resultado pode ser desfeito nas opções do painel ou nas preferências. Ajustes mais baixos favorecem fala baixa; mais altos bloqueiam mais ruído.

Em **Preferências → Entrada e monitor**, uma interface com várias entradas pode usar um **canal específico**. “Misturar todos” conserva o comportamento de mistura original. Os canais são apresentados a partir de 1; um canal indisponível é indicado.

**Ouvir minha voz** toca o sinal processado na saída escolhida nas preferências, ou na saída padrão do Mac. Use fones. A guarda pausa o monitor no par microfone embutido + alto-falantes embutidos. Se usar caixas externas, marque **Esta saída usa alto-falantes externos** para proteger também esse cenário. A pausa do monitor não interrompe a transmissão aos aplicativos.

## Presets, backup e atraso

Em **Presets de voz**, salve a voz atual, renomeie, duplique ou atualize um preset. Substituição e exclusão pedem confirmação; **Desfazer última alteração** recupera a lista anterior na mesma sessão. O estado selecionado corresponde aos valores reais de altura e timbre.

**Exportar configuração** cria um JSON versionado com voz, presets, calibrações e preferências de dispositivos, atualização e telemetria. **Importar configuração** valida o arquivo e mostra um resumo antes de substituir as preferências. Não inclui gravações, credenciais, permissão de microfone ou autorização de início no login. Depois de reinstalar o macOS, essas autorizações precisam ser concedidas novamente.

**Preferências → Saúde e atraso** distingue estimativas de buffers de uma medição. **Medir atraso** pede fala por alguns segundos e compara captura e saída virtual usando áudio somente em memória. Silêncio ou sinal inadequado podem produzir um resultado inconclusivo. Atraso do monitor e atraso de transmissão são caminhos diferentes; Bluetooth pode acrescentar atraso fora do motor.

## Quando falta som

1. Confira se o aplicativo da chamada usa **Mixer de Áudio — Microfone**, principalmente após atualizar de uma versão com duas entradas.
2. Confira **Voz: Ligado**, **Microfone: Enviando**, o microfone **Em uso** e o medidor **Saída**.
3. Use **Reconectar** depois de uma transição de dispositivo.
4. Abra **Diagnóstico** para gerar e ler um relatório local. Driver e roteamento podem ser reparados durante a verificação.
5. Se precisar de suporte, confira a prévia e use **Enviar este relatório ao suporte**. O envio ao canal privado do Discord é uma ação separada; o relatório não inclui gravação de voz.

Atualizações e telemetria podem ser controladas nas preferências. Uma atualização que troca o aplicativo precisa reiniciá-lo; faça isso fora da chamada. O diagnóstico local pode ser usado sem enviar relatório.

## Validação da 5.12.3

A validação local corresponde ao código do commit [`96d0a4b53fe5beafd78dcb3537b04b3cd306d384` — repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/commit/96d0a4b53fe5beafd78dcb3537b04b3cd306d384).

| Verificação local | Resultado |
|---|---|
| Regressões Swift | 105 testes aprovados |
| Manifestos, instalação e publicação | 29 testes Python aprovados |
| Relay de suporte | 5 testes aprovados, SQLite em memória e transporte simulado |
| Driver | Harnesses ASan/UBSan/TSan aprovados |
| Instrumento de transporte | Self-test aprovado |
| App e driver universais | arm64/x86_64, mínimo macOS 15.0 e assinaturas estritas válidas |

Os quatro jobs do [CI do commit final — repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/37554012689) passaram. A tabela acima registra também as verificações locais do mesmo código.

Os dois pacotes da 5.12.3 foram conferidos contra seus manifestos e publicados, com versão, commit, fonte e hashes dos binários vinculados. O ZIP público reúne aplicativo, driver, desinstalador e manuais, incluindo o mapa do projeto, e sua assinatura Ed25519 foi verificada. O publicador conferiu os três downloads e `releases/latest`.

O ZIP público da 5.12.3 tem **1.851.494 bytes**. SHA-256:

```text
daaf23b50e3e87c0f010ec50d3f673d91416303109faae2be9252d93afff2199
```

Não houve nova instalação ou chamada real da 5.12.3 nesta entrega. As evidências anteriores e as pendências de campo permanecem nas [notas 5.12.2](docs/releases/5.12.2.md) e na [matriz de compatibilidade](docs/COMPATIBILITY.md).

## Validação da 5.12.2 (histórico)

Passaram **105 testes Swift**, **29 testes Python**, os harnesses do driver com **ASan/UBSan** e o concorrente com **TSan**. O [CI do commit final — repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/37546160133) concluiu com sucesso. A suíte Swift passou também com áudio ativo no aplicativo instalado.

Os dois ZIPs foram conferidos contra seus manifestos, vinculados ao commit `6a5a6b2d4766016dc6e38d1e30db7b1c310f0c00`. O conteúdo completo do app instalado coincide com o pacote de distribuição, incluindo permissões; app e driver passaram na verificação de assinatura. A topologia confirma uma única entrada virtual, com o dispositivo de escrita separado. O pacote público inclui os manuais e as notas das versões, sem código-fonte.

Na **5.12.0**, a usuária confirmou uma chamada real no **FaceTime** e uma **ligação do iPhone pelo Mac**. A 5.12.2 preserva o driver e o roteamento dessa versão; esses resultados não representam novas chamadas de teste da 5.12.2. A matriz de compatibilidade mantém as pendências de campo, incluindo Bluetooth sob interferência, hotplug prolongado, consumidores sem teste humano confirmado, macOS 15 e Intel físicos.

O ZIP público da 5.12.2 tem **1.843.641 bytes**. SHA-256:

```text
c33b424ae32c9de1ab5bf3373ec9306e4de1ef27dcec35dded232d39572217f6
```

## Atualizações e privacidade

As preferências controlam atualização e telemetria. A checagem ao abrir pode instalar uma versão nova verificada e reabrir o app; checagens periódicas avisam antes de reiniciar. O updater recusa ZIP sem assinatura válida e versões divergentes da tag.

O diagnóstico gera relatório e ZIP no Mac. Somente **Enviar este relatório ao suporte** compartilha o texto revisado com o canal privado de suporte; nenhuma gravação de voz é incluída. Nomes, caminhos pessoais, UIDs, endereços Bluetooth e credenciais são redigidos. O destino secreto fica no servidor. O serviço rejeita formatos inválidos antes de enviar conteúdo ao suporte.

## Desinstalar

Use **Desinstalar** no painel ou **Desinstalar o Mixer de Áudio…** no menu da barra para remover apenas o aplicativo ou também seu driver. O pacote inclui o desinstalador das versões anteriores. A identificação dos próprios bundles preserva BlackHole, Voicemod comercial e outros programas/plugins de terceiros. Leia as opções antes de confirmar a remoção.

## Documentação

| Quero consultar… | Abrir |
|---|---|
| Todas as partes do projeto | [Mapa do projeto](docs/INDEX.md) |
| A entrega atual | [Notas 5.12.3 — limpeza e organização](docs/releases/5.12.3.md) |
| Cenários conferidos e pendências | [Compatibilidade](docs/COMPATIBILITY.md) |
| Arquitetura, testes e distribuição | [Guia de desenvolvimento](docs/DEVELOPMENT.md) |
| Versões e decisões anteriores | [Histórico](docs/CHANGELOG.md) |
