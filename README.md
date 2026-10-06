# Mixer de Áudio — downloads para macOS

O Mixer altera sua voz em tempo real e entrega o resultado a chamadas, gravações e jogos pelo seu próprio microfone virtual. Este repositório distribui o aplicativo; o código-fonte permanece no [repositório privado do projeto](https://github.com/indyhttps/MixerDeAudio-macOS).

Baixe o **mixer-de-audio-macos.zip** na [release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest). O pacote contém aplicativo universal, driver, desinstalador e documentação. Requisitos: **macOS 15 ou mais novo**, Apple Silicon ou Intel.

## Versão 5.12.1

A [5.12.1 está publicada](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/tag/v5.12.1). Quando o microfone escolhido está ativo, seu nome aparece uma vez e a linha abaixo mostra **Em uso**. Ao seguir o padrão do sistema ou durante uma troca de fonte, a linha informa o microfone realmente capturado; sem captura, mostra **Em uso: nenhum**.

O painel conserva a composição compacta da Central de Controle, com Liquid Glass nativo, cinco ações distribuídas uniformemente e uma cápsula de estado no rodapé. Clique na cápsula para ler os detalhes do áudio e o aviso completo no popover centralizado. **Todos os avisos…** abre a janela **Estado e avisos**, com títulos, mensagens e horários centralizados, rolagem e redimensionamento. As mensagens usam inicial maiúscula na apresentação. Os [UI Kits oficiais do macOS 27 e iOS 27](https://developer.apple.com/design/resources/) orientaram os refinamentos; os arquivos dos kits ficam fora da distribuição.

A versão conserva o **driver 1.5**, com uma única entrada virtual: **Mixer de Áudio — Microfone**. O dispositivo **Mixer de Áudio** tem somente a saída que alimenta esse microfone. O motor WSOLA, o preset calibrado, o gate e os ajustes de voz permanecem iguais; a 5.12.1 muda a apresentação da interface.

O aplicativo mantém uma única instalação definitiva em **/Applications/Mixer de Áudio.app**. A instalação valida o novo aplicativo e preserva a versão anterior até conferir a troca. Depois de validar o destino, o programa remove o próprio instalador temporário. Uma atualização cancelada ou falha mantém o instalador disponível para nova tentativa. Os registros e atalhos duplicados próprios são corrigidos, preservando os demais aplicativos e a posição do primeiro atalho no Dock.

## Instalar ou atualizar

1. Extraia o ZIP e abra **Mixer de Áudio.app**. O instalador coloca o aplicativo em **Aplicativos** e abre a instalação definitiva.
2. Autorize o acesso ao microfone quando o macOS solicitar. Depois, abra o Mixer em **Aplicativos** ou pelo atalho no **Dock**.
3. Se estiver usando o driver 1.4 ou anterior, confirme a instalação do **driver 1.5** na janela de administrador. Essa troca recarrega o serviço de áudio; faça fora de uma chamada e reabra os aplicativos de áudio depois. Quem já tem o driver 1.5 não precisa trocá-lo para receber a apresentação da 5.12.1.

Encerre uma chamada antes de reiniciar o Mixer. A cópia externa mais nova instala ou atualiza o aplicativo e abre a versão instalada, sem rebaixá-la ao abrir uma cópia antiga.

A distribuição usa assinatura de código **ad-hoc**, com autenticação **Ed25519 do ZIP** para o updater. Developer ID e notarização Apple continuam pendentes; este pacote não é anunciado como notarizado. O manual dentro do ZIP descreve a abertura de um download confiável quando o macOS solicitar aprovação.

## Configurar e usar

Escolha seu **microfone real** dentro do Mixer. Em **Meet/Safari, Discord, OBS, FaceTime e demais aplicativos**, selecione **Mixer de Áudio — Microfone** como entrada. Use seus fones ou alto-falantes físicos como saída; **Mixer de Áudio** é a saída interna de alimentação e não deve ser escolhida como saída da chamada.

No **FaceTime**, escolha o microfone dedicado no menu **Vídeo**. Para um app que usa a entrada padrão do Mac, selecione **Mixer de Áudio — Microfone** em **Ajustes do Sistema → Som → Entrada**. Nesse caso, mantenha um microfone físico fixado dentro do Mixer. Aplicativos com seleção própria podem exigir a escolha dentro deles.

Confira **Voz: Ligado**, **Microfone: Enviando**, a fonte **Em uso** e o medidor **Saída**. **Microfone: Mudo** interrompe o envio e **Voz: Desligado** desliga o processamento. **Voz Feminina** aplica a voz calibrada; **Neutro** volta aos valores originais. Os sliders permitem ajustar altura e timbre.

As opções do painel abrem Preferências, Presets de voz e Guia. Os botões circulares **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar** refaz o roteamento; **Diagnóstico** gera um relatório local para leitura.

Conecte AirPods antes de abrir o Safari. Se uma troca de fones durante a chamada interromper a voz, saia da chamada e reabra o Safari; a recuperação automática desse cenário ainda precisa de validação.

## Validação da 5.12.1

Passaram **89 testes Swift**, **29 testes Python**, os harnesses funcionais do driver com **ASan/UBSan** e o concorrente com **TSan**. Os quatro jobs do [CI do commit final — repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/37534380626) concluíram com sucesso: Swift, driver sanitizers e distribuição universal; compatibilidade native; projeto XcodeGen e vínculos dos módulos; relay de suporte.

Os dois ZIPs foram conferidos contra seus manifestos, vinculados ao commit `27eefe73941e57c3d1f5edca89971fb56556e152`. O app e o driver instalados coincidem com o conteúdo completo dos pacotes, incluindo permissões de execução; as assinaturas de código passaram na verificação. O roteamento confirmou uma única entrada virtual do Mixer, com o dispositivo de escrita separado. A instalação final tem um registro do aplicativo e um atalho no Dock apontando para o caminho canônico.

Na **5.12.0**, a usuária confirmou uma chamada real no **FaceTime** e uma **ligação do iPhone pelo Mac**. A 5.12.1 preserva o driver e o roteamento dessa versão; esses resultados não representam novas chamadas de teste da 5.12.1. A matriz de compatibilidade dentro do ZIP mantém as pendências de campo, incluindo hotplug de AirPods, consumidores sem teste humano confirmado, macOS 15 e Intel físicos.

O ZIP público da 5.12.1 tem **1.807.788 bytes**. SHA-256:

```text
062d29f3834ad4bc28da4d8afbb8c609be9563c4b6d4192e706dabca912681cb
```

## Atualizações e privacidade

As preferências controlam atualização e telemetria. A checagem ao abrir pode instalar uma versão nova verificada e reabrir o app; checagens periódicas avisam antes de reiniciar. O updater recusa ZIP sem assinatura válida e versões divergentes da tag.

O diagnóstico gera relatório e ZIP no Mac. Somente **Enviar este relatório ao suporte** compartilha o texto revisado com o canal privado de suporte; nenhuma gravação de voz é incluída. Nomes, caminhos pessoais, UIDs, endereços Bluetooth e credenciais são redigidos. O destino secreto fica no servidor. O serviço rejeita formatos inválidos antes de enviar conteúdo ao suporte.

## Desinstalar

Use **Desinstalar** no painel ou **Desinstalar o Mixer de Áudio…** no menu da barra para remover apenas o aplicativo ou também seu driver. O pacote inclui o desinstalador das versões anteriores. A identificação dos próprios bundles preserva BlackHole, Voicemod comercial e outros programas/plugins de terceiros. Leia as opções antes de confirmar a remoção.
