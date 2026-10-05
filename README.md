# Mixer de Áudio — downloads para macOS

O Mixer altera sua voz em tempo real e entrega o resultado a chamadas, gravações e jogos pelo seu próprio microfone virtual. Este repositório distribui o aplicativo; o código-fonte permanece privado.

Baixe o **mixer-de-audio-macos.zip** na [release mais recente](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest). O pacote contém aplicativo universal, driver, desinstalador e documentação. Requisitos: **macOS 15 ou mais novo**, Apple Silicon ou Intel.

## Versão 5.11.0

A versão inclui preferências de entrada/canal/monitor, calibração por microfone, gerenciamento de presets com desfazer, backup JSON, medição de latência em memória, painel rolável e mensagens completas. Diagnóstico local e envio ao suporte são ações separadas; a prévia permite revisar o relatório antes de compartilhar. Nenhuma gravação de voz é enviada pelo diagnóstico.

## Instalar

1. Extraia o ZIP e arraste **Mixer de Áudio.app** para **Aplicativos**.
2. Abra o app e autorize o acesso ao microfone quando o macOS solicitar.
3. Confirme a instalação/atualização do **driver 1.4** na janela de administrador do macOS. A troca recarrega o serviço de áudio uma vez; faça isso fora de uma chamada e reabra o Safari depois.

A distribuição usa assinatura de código **ad-hoc**, com autenticação **Ed25519 do ZIP** para o updater. Developer ID e notarização Apple continuam pendentes; este pacote não é anunciado como notarizado. O manual dentro do ZIP descreve a abertura de um download confiável quando o macOS solicitar aprovação.

## Configurar a chamada

Escolha seu microfone real no Mixer. No **Meet/Safari**, selecione **Mixer de Áudio — Microfone** como entrada da chamada; no **Discord/OBS**, selecione **Mixer de Áudio**. Use seus fones ou alto-falantes físicos como saída.

Os dois dispositivos virtuais recebem o mesmo sinal. Conecte AirPods antes de abrir o Safari. Se uma troca de fones durante a chamada interromper a voz, saia da chamada e reabra o Safari; a recuperação automática desse cenário ainda precisa de validação.

## Atualizações e privacidade

As preferências controlam atualização e telemetria. A checagem ao abrir pode instalar uma versão nova verificada e reabrir o app; checagens periódicas avisam antes de reiniciar. O updater recusa ZIP sem assinatura válida e versões divergentes da tag.

O diagnóstico gera relatório e ZIP no Mac. Somente **Enviar este relatório ao suporte** compartilha o texto revisado com o canal privado de suporte. Nomes, caminhos pessoais, UIDs, endereços Bluetooth e credenciais são redigidos. O destino secreto fica no servidor.

## Desinstalar

Use **Desinstalar o Mixer de Áudio…** no menu para remover apenas o aplicativo ou também o driver. O pacote inclui o desinstalador completo das versões anteriores. Leia as opções antes de confirmar a remoção.
