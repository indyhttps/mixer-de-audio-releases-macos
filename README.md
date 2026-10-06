# Mixer de Áudio — downloads para macOS

O Mixer altera sua voz em tempo real e entrega o resultado a chamadas, gravações e jogos pelo seu próprio microfone virtual. Este repositório distribui o aplicativo; o código-fonte permanece no [repositório privado do projeto](https://github.com/indyhttps/MixerDeAudio-macOS).

Baixe o **mixer-de-audio-macos.zip** na [release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest). O pacote contém aplicativo universal, driver, desinstalador e documentação. Requisitos: **macOS 15 ou mais novo**, Apple Silicon ou Intel.

## Versão 5.12.2

A [5.12.2 está publicada](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/tag/v5.12.2). Ela reduz a espera nos buffers: captura e saída virtual solicitam ciclos menores, a fila acompanha as rajadas reais e mantém mais reserva para Bluetooth. A reserva aumenta se faltar áudio; falhas repetidas de prazo levam a ciclos maiores. As cópias do buffer circular também ficaram mais curtas.

O processamento de voz, o reamostrador, o gate e o preset calibrado continuam iguais. Testes comparam o PCM por bits em diferentes tamanhos de blocos, taxas e transições. A versão conserva o **driver 1.5**, com uma única entrada virtual: **Mixer de Áudio — Microfone**. O dispositivo **Mixer de Áudio** tem somente a saída que alimenta esse microfone.

Na validação local com AirPods Pro 3, a estimativa caiu de 121,3 para 103–108 ms, conforme a reserva necessária. A medição de fala deu **90,0 ms**, confiança moderada e resolução de 5,0 ms, do microfone físico à entrada virtual; não inclui fones nem navegador/chamada. A usuária confirmou som preservado e sem estalos ou cortes ao ouvir a voz com o microfone do MacBook Pro. O ganho depende do hardware e da carga do Mac; as [notas 5.12.2](docs/releases/5.12.2.md) e a [matriz de compatibilidade](docs/COMPATIBILITY.md) registram os cenários e limites.

O painel conserva a composição compacta da Central de Controle, com Liquid Glass nativo, a fonte **Em uso**, cinco ações distribuídas uniformemente e uma cápsula de estado no rodapé. Clique nela para ler os detalhes do áudio e os avisos; **Todos os avisos…** abre a janela nativa com histórico, rolagem e redimensionamento.

O aplicativo mantém uma única instalação definitiva em **/Applications/Mixer de Áudio.app**. A instalação valida o novo aplicativo e preserva a versão anterior até conferir a troca. Depois de validar o destino, o programa remove o próprio instalador temporário. Uma atualização cancelada ou falha mantém o instalador disponível para nova tentativa. Os registros e atalhos duplicados próprios são corrigidos, preservando os demais aplicativos e a posição do primeiro atalho no Dock.

## Instalar ou atualizar

1. Extraia o ZIP e abra **Mixer de Áudio.app**. O instalador coloca o aplicativo em **Aplicativos** e abre a instalação definitiva.
2. Autorize o acesso ao microfone quando o macOS solicitar. Depois, abra o Mixer em **Aplicativos** ou pelo atalho no **Dock**.
3. Se estiver usando o driver 1.4 ou anterior, confirme a instalação do **driver 1.5** na janela de administrador. Essa troca recarrega o serviço de áudio; faça fora de uma chamada e reabra os aplicativos de áudio depois. Quem já tem o driver 1.5 não precisa trocá-lo para receber as otimizações de buffers da 5.12.2.

Encerre uma chamada antes de reiniciar o Mixer. A cópia externa mais nova instala ou atualiza o aplicativo e abre a versão instalada, sem rebaixá-la ao abrir uma cópia antiga.

A distribuição usa assinatura de código **ad-hoc**, com autenticação **Ed25519 do ZIP** para o updater. Developer ID e notarização Apple continuam pendentes; este pacote não é anunciado como notarizado. O manual dentro do ZIP descreve a abertura de um download confiável quando o macOS solicitar aprovação.

## Configurar e usar

Escolha seu **microfone real** dentro do Mixer. Em **Meet/Safari, Discord, OBS, FaceTime e demais aplicativos**, selecione **Mixer de Áudio — Microfone** como entrada. Use seus fones ou alto-falantes físicos como saída; **Mixer de Áudio** é a saída interna de alimentação e não deve ser escolhida como saída da chamada.

No **FaceTime**, escolha o microfone dedicado no menu **Vídeo**. Para um app que usa a entrada padrão do Mac, selecione **Mixer de Áudio — Microfone** em **Ajustes do Sistema → Som → Entrada**. Nesse caso, mantenha um microfone físico fixado dentro do Mixer. Aplicativos com seleção própria podem exigir a escolha dentro deles.

Confira **Voz: Ligado**, **Microfone: Enviando**, a fonte **Em uso** e o medidor **Saída**. **Microfone: Mudo** interrompe o envio e **Voz: Desligado** desliga o processamento. **Voz Feminina** aplica a voz calibrada; **Neutro** volta aos valores originais. Os sliders permitem ajustar altura e timbre.

As opções do painel abrem Preferências, Presets de voz e Guia. Os botões circulares **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar** refaz o roteamento; **Diagnóstico** gera um relatório local para leitura.

Conecte AirPods antes de abrir o Safari. Se uma troca de fones durante a chamada interromper a voz, saia da chamada e reabra o Safari; a recuperação automática desse cenário ainda precisa de validação.

## Validação da 5.12.2

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
