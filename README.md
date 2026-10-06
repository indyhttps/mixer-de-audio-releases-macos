# Mixer de Áudio — downloads para macOS

O Mixer altera sua voz em tempo real e entrega o resultado a chamadas, gravações e jogos pelo seu próprio microfone virtual. Este repositório distribui o aplicativo; o código-fonte permanece no [repositório privado do projeto](https://github.com/indyhttps/MixerDeAudio-macOS).

Baixe o **mixer-de-audio-macos.zip** na [release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest). O pacote contém aplicativo universal, driver, desinstalador e documentação. Requisitos: **macOS 15 ou mais novo**, Apple Silicon ou Intel.

## Versão 5.11.2

Este manual descreve a versão 5.11.2. A [página de releases](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases) informa quais versões já foram publicadas e disponibiliza seus pacotes e notas.

A versão 5.11.2 mantém uma única instalação definitiva em **/Applications/Mixer de Áudio.app**. Ao abrir essa instalação, o Mixer corrige seus registros e atalhos duplicados, preserva a posição do primeiro atalho no Dock e mantém os demais aplicativos.

O aplicativo usa SwiftUI/AppKit, símbolos e materiais do sistema, tendo o [UI Kit oficial do macOS 27](https://developer.apple.com/design/resources/) como referência visual. O painel principal conserva a composição compacta e rolável da Central de Controle, com Liquid Glass nativo somente no fundo das superfícies; textos e controles são desenhados por cima. Preferências, Diagnóstico, Presets, Guia e Avisos usam formulários, listas e janelas nativas, com redimensionamento. A correção resolve cartões vazios, respeita Reduzir Transparência e Aumentar Contraste e usa materiais compatíveis nas versões anteriores do macOS.

Presets importados passam a manter nomes consistentes ao salvar novamente. A importação e as trocas de canal/fonte cancelam calibrações incompatíveis. A instalação valida o novo aplicativo e preserva uma cópia anterior até conferir a troca. A desinstalação identifica os próprios bundles e preserva BlackHole, Voicemod comercial e outros programas/plugins de terceiros.

O motor de voz, o preset calibrado, os ajustes de gate e o **driver 1.4** são preservados. As notas completas fazem parte do conteúdo dos dois pacotes de distribuição. O item 16, que adicionaria novos atalhos, permanece excluído.

## Instalar ou atualizar

1. Extraia o ZIP e abra **Mixer de Áudio.app**. O instalador coloca o aplicativo em **Aplicativos** e abre a instalação definitiva.
2. Autorize o acesso ao microfone quando o macOS solicitar. Depois, abra o Mixer em **Aplicativos** ou pelo atalho no **Dock**.
3. Se ainda estiver usando um driver anterior, confirme a instalação do **driver 1.4** na janela de administrador. Essa troca recarrega o serviço de áudio uma vez; faça fora de uma chamada e reabra o Safari depois. Quem já tem o driver 1.4 não precisa reinstalá-lo para esta correção.

Encerre uma chamada antes de reiniciar o Mixer. A cópia externa mais nova instala ou atualiza o aplicativo e abre a versão instalada, sem rebaixá-la ao abrir uma cópia antiga. Depois de validar o destino, o programa remove o próprio instalador temporário para evitar outro ícone. Uma atualização cancelada ou falha mantém o instalador disponível para nova tentativa.

A distribuição usa assinatura de código **ad-hoc**, com autenticação **Ed25519 do ZIP** para o updater. Developer ID e notarização Apple continuam pendentes; este pacote não é anunciado como notarizado. O manual dentro do ZIP descreve a abertura de um download confiável quando o macOS solicitar aprovação.

## Configurar e usar

Escolha seu microfone real no Mixer. No **Meet/Safari**, selecione **Mixer de Áudio — Microfone** como entrada da chamada; no **Discord/OBS**, selecione **Mixer de Áudio**. Use seus fones ou alto-falantes físicos como saída.

Confira **Voz: Ligado** e **Microfone: Enviando**. **Microfone: Mudo** interrompe o envio e **Voz: Desligado** desliga o processamento. **Voz Feminina** aplica a voz calibrada; **Neutro** volta aos valores originais. Os sliders permitem ajustar altura e timbre.

As opções do painel abrem Preferências, Presets de voz e Guia; o rodapé abre Estado e Avisos. Os botões circulares **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar** refaz o roteamento; **Diagnóstico** gera um relatório local para leitura.

Os dois dispositivos virtuais recebem o mesmo sinal. Conecte AirPods antes de abrir o Safari. Se uma troca de fones durante a chamada interromper a voz, saia da chamada e reabra o Safari; a recuperação automática desse cenário ainda precisa de validação.

## Atualizações e privacidade

As preferências controlam atualização e telemetria. A checagem ao abrir pode instalar uma versão nova verificada e reabrir o app; checagens periódicas avisam antes de reiniciar. O updater recusa ZIP sem assinatura válida e versões divergentes da tag.

O diagnóstico gera relatório e ZIP no Mac. Somente **Enviar este relatório ao suporte** compartilha o texto revisado com o canal privado de suporte; nenhuma gravação de voz é incluída. Nomes, caminhos pessoais, UIDs, endereços Bluetooth e credenciais são redigidos. O destino secreto fica no servidor. O serviço rejeita formatos inválidos antes de enviar conteúdo ao suporte.

## Desinstalar

Use **Desinstalar** no painel ou **Desinstalar o Mixer de Áudio…** no menu da barra para remover apenas o aplicativo ou também seu driver. O pacote inclui o desinstalador das versões anteriores. Leia as opções antes de confirmar a remoção; dispositivos e programas de terceiros são preservados.

