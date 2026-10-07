# Mixer de Áudio — manual 5.12.4

[![testes](https://github.com/indyhttps/MixerDeAudio-macOS/actions/workflows/testes.yml/badge.svg)](https://github.com/indyhttps/MixerDeAudio-macOS/actions/workflows/testes.yml)

**Acesso rápido:** [Instalar](#instalar) · [Configurar chamada](#configurar-a-chamada) · [Gate e monitor](#gate-canal-e-monitor) · [Presets e backup](#presets-backup-e-atraso) · [Diagnóstico](#quando-falta-som) · [Mapa do projeto](docs/INDEX.md)

O Mixer captura seu microfone real, altera a voz em tempo real e entrega o resultado para chamadas, gravações e jogos. O aplicativo fica na barra de menus do macOS e usa seu próprio driver virtual; não precisa de BlackHole.

Baixe a versão publicada nas [releases públicas para macOS](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases). O driver já vem dentro do aplicativo. O [repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/releases) também guarda os pacotes completos com código-fonte. Este manual acompanha o código 5.12.4; a página de downloads informa quais versões já foram publicadas.

A distribuição usa o **driver 1.5**, recompilado do fonte. Ele oferece uma única entrada virtual: **Mixer de Áudio — Microfone**, a mesma seleção para chamadas, gravações e jogos. O dispositivo **Mixer de Áudio** passa a ter apenas a saída que alimenta esse microfone; deixa de aparecer como uma segunda entrada. O motor WSOLA, o gate e os valores de voz permanecem iguais. Atualizar o driver 1.4 ou anterior exige autorização de administrador e uma recarga do serviço de áudio. Faça esse passo fora de uma chamada e reabra os aplicativos de áudio depois.

**A 5.12.4 corrige a desinstalação e o envio de suporte.** Cancelar a autorização preserva os aplicativos e o estado de usuário. A opção **Remover só o app** confere a remoção antes de limpar os dados e anunciar sucesso; o desinstalador externo espera a autorização antes de alterar login ou agregado legado e confirma a remoção antes da limpeza restante. O serviço de suporte passa a recusar um desafio que expire durante suas verificações, evitando o reenvio de um relatório já aceito. O visual aprovado, o processamento de voz e o driver 1.5 continuam preservados. As [notas 5.12.4](docs/releases/5.12.4.md) registram o escopo e a validação desta entrega.

**A 5.12.2 reduz a espera nas filas de áudio.** O app solicita ciclos menores na taxa nativa do microfone e na saída virtual, dimensiona a reserva pelos ciclos concedidos e amplia essa reserva se faltar áudio. Se captura ou processamento perderem prazos repetidamente, os ciclos aumentam automaticamente. O motor WSOLA, o gate, o formato de áudio e os presets calibrados são preservados. O ganho depende do microfone e da carga do Mac; use **Preferências → Saúde e atraso → Medir atraso por 8 segundos** para comparar o caminho real até o microfone virtual. As [notas 5.12.2](docs/releases/5.12.2.md) registram a validação e seus limites.

A **5.12.1** simplifica a apresentação do microfone no painel: quando a fonte escolhida está em uso, seu nome aparece uma vez e a linha abaixo mostra **Em uso**. Ao seguir o padrão do sistema ou usar outra fonte temporariamente, a linha informa o nome realmente capturado. O rodapé usa uma cápsula de estado compacta; clique nela para ler os detalhes do áudio e os avisos. O painel conserva seu visual de vidro da Central de Controle, com as cinco ações distribuídas uniformemente. Essas alterações são de apresentação e conservam o driver 1.5 e o processamento de voz.

Desde a **5.11.1**, o aplicativo usa SwiftUI/AppKit, símbolos e materiais do sistema, tomando o [UI Kit oficial do macOS 27](https://developer.apple.com/design/resources/) e as diretrizes da Apple como referências visuais. O painel principal conserva a composição compacta da Central de Controle, com Liquid Glass nativo aplicado somente ao fundo das superfícies; textos e controles são desenhados por cima. Preferências, Diagnóstico, Presets, Guia e Avisos usam formulários, listas e janelas nativas. A correção evita os cartões vazios e respeita Reduzir Transparência e Aumentar Contraste. O app continua na barra de menus e mantém compatibilidade com macOS 15+.

## Instalar

Requisitos: macOS 15 ou mais novo. A distribuição é preparada para Apple Silicon e Intel.

1. Extraia o ZIP e arraste **Mixer de Áudio.app** para **Aplicativos**.
2. Abra o aplicativo. Se o macOS exigir aprovação de um pacote assinado ad-hoc, use botão direito → **Abrir**. Para um download confiável que seja bloqueado pela quarentena, o procedimento anterior de instalação é `xattr -dr com.apple.quarantine "/Applications/Mixer de Áudio.app"`, seguido de uma nova abertura.
3. Confirme a instalação do dispositivo virtual. O macOS pede sua senha de administrador.
4. Autorize o acesso ao microfone quando o macOS pedir.

Desde a 5.11.2, abrir um instalador extraído instala ou atualiza o aplicativo em **Aplicativos** e remove o instalador temporário após validar o destino. Use o aplicativo em Aplicativos ou seu atalho no Dock para abrir o Mixer. Uma atualização cancelada ou falha mantém o instalador para nova tentativa.

**Ao atualizar para a 5.12.0:** encerre os aplicativos que usam áudio, instale o novo driver e reabra-os. Se uma chamada ou gravação tinha **Mixer de Áudio** salvo como entrada, selecione **Mixer de Áudio — Microfone** nas configurações desse aplicativo. A antiga entrada deixa de existir e o Mixer não altera as preferências de outros programas. Quem já selecionava **Mixer de Áudio — Microfone** conserva a identidade desse dispositivo, embora um aplicativo possa exigir nova seleção após reiniciar o serviço de áudio.

Antes de uma instalação limpa com remoção de preferências, use **Exportar configuração** e guarde o JSON fora da pasta do aplicativo. Depois de reinstalar, importe-o e conceda novamente as permissões de microfone e início no login. A configuração do microfone nos aplicativos de chamada deve ser conferida separadamente.

A assinatura e a notarização de um pacote dependem do perfil usado na distribuição. A existência do perfil Developer ID no projeto não significa que um download já esteja assinado ou notarizado com ele.

## Configurar a chamada

No painel, escolha seu **microfone real**. Quando ele está ativo, seu nome aparece uma vez, com **Em uso** abaixo. “Seguir padrão do sistema” acompanha a seleção do macOS e mostra **Em uso: nome do microfone**. Se a fonte escolhida ficar indisponível ou estiver sendo trocada, essa linha informa a fonte realmente capturada; sem captura, mostra **Em uso: nenhum**.

| Aplicativo | Microfone a selecionar nele | Saída de som |
|---|---|---|
| Google Meet/Safari, Discord, OBS e demais aplicativos | **Mixer de Áudio — Microfone** | Seus fones ou alto-falantes físicos |
| FaceTime | **Mixer de Áudio — Microfone**, no menu **Vídeo** | Seus fones ou alto-falantes físicos |
| Apps que seguem a entrada padrão do macOS | **Mixer de Áudio — Microfone**, em **Ajustes do Sistema → Som → Entrada** | Seus fones ou alto-falantes físicos |

No FaceTime, abra o menu **Vídeo** na barra de menus e escolha o microfone dedicado. O seletor está descrito no [manual da Apple](https://support.apple.com/pt-br/guide/facetime/fctm26739220/mac). Para um app sem seletor que usa a entrada padrão, escolha o virtual nos [ajustes de entrada do macOS](https://support.apple.com/pt-br/guide/mac-help/mchlp2567/mac) e reabra o app se necessário. Aplicativos com seleção própria podem continuar exigindo a escolha dentro deles.

**Ao usar o virtual como entrada padrão do Mac, mantenha um microfone físico escolhido dentro do Mixer**, como o microfone do MacBook ou seu USB/AirPods. Assim o Mixer captura a fonte real e o outro app recebe a voz processada. A linha **Em uso** confirma essa fonte. **Mixer de Áudio** é a saída de alimentação usada pelo motor e não deve ser escolhida como saída de som da chamada. A entrada única simplifica a seleção; os cenários de funcionamento já observados e os que ainda precisam de teste estão na [matriz de compatibilidade](docs/COMPATIBILITY.md).

**AirPods e Safari:** conecte os fones antes de abrir o navegador. Se trocar ou conectar fones durante o Meet e perder a voz, saia da chamada, encerre e reabra o Safari. A recuperação automática desse cenário ainda precisa ser validada; confira a [matriz de compatibilidade](docs/COMPATIBILITY.md).

## Usar o painel

- Clique no ícone da barra de menus para abrir o painel; o botão direito abre o menu completo.
- **Voz Feminina / Neutro** aplicam a voz calibrada ou retornam os controles para zero. **Altura (tom)** e **Timbre (formantes)** permitem ajustes finos. No motor WSOLA atual, os dois ajustes contribuem para a transposição combinada.
- **Microfone: Mudo** interrompe o envio; **Enviando** indica a transmissão ativa. **Voz: Desligado** desliga o processamento; **Ligado** indica o motor ativo. O ícone da barra e o rodapé mostram o estado.
- **Entrada** mostra o sinal cru; **Saída** mostra o sinal entregue pelo Mixer aos aplicativos. A recepção na chamada também depende da entrada selecionada no aplicativo.
- Os botões circulares **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar**, **Diagnóstico** e **Desinstalar** também ficam na linha de ações. O painel principal é compacto e rolável, com cabeçalho próprio para arrastar; as janelas auxiliares permitem redimensionar.
- A cápsula no rodapé mostra estados curtos, como **Ativo**, **Microfone mudo** ou **Desligado**. Um aviso recente aparece como **Novo aviso**. Clique para abrir os detalhes do áudio e o aviso completo, apresentados com texto centralizado. **Todos os avisos…** abre **Estado e avisos**, uma janela compacta com estado atual e histórico centralizados; ela permite rolagem e redimensionamento. As mensagens usam inicial maiúscula, como **Ativo**, também nos detalhes. As opções do painel dão acesso a **Preferências**, **Presets de voz** e **Guia de uso**.

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

## Desinstalar

No painel, escolha **Desinstalar**, ou use **Desinstalar o Mixer de Áudio…** no menu da barra. É possível remover apenas o aplicativo ou remover também o driver. A remoção completa do driver pede autorização de administrador.

Se cancelar a autorização, os aplicativos e o estado de usuário são preservados. Em **Remover só o app**, a limpeza de estado depende da remoção confirmada dos bundles. O desinstalador externo executa a retirada do login e do agregado legado depois da autorização, antes de remover os arquivos; as demais limpezas dependem da remoção confirmada. Se a remoção autorizada falhar, login e agregado podem já ter sido alterados, e o aviso informa esse limite. Uma falha não produz a mensagem de sucesso.

O pacote também inclui **Desinstalar Mixer de Áudio.command** para limpeza das versões anteriores e resíduos próprios. A identificação de aplicativos e do driver usa o bundle id exato; itens de login e atalhos são removidos pelos caminhos confirmados. BlackHole, Voicemod comercial e outros dispositivos/programas de terceiros são preservados.

## Documentação do projeto

| Preciso consultar… | Documento |
|---|---|
| O mapa de todas as partes do projeto | [Mapa do projeto](docs/INDEX.md) |
| A arquitetura, os testes e a distribuição | [Guia de desenvolvimento](docs/DEVELOPMENT.md) |
| Os cenários conferidos e as pendências de campo | [Compatibilidade](docs/COMPATIBILITY.md) |
| O histórico completo de versões | [Changelog](docs/CHANGELOG.md) |
| A entrega atual | [Notas 5.12.4 — desinstalação e envio de suporte](docs/releases/5.12.4.md) |
| As melhorias da 5.11.0 | [Registro das melhorias](docs/IMPROVEMENTS-5.11.0.md) |
| As regras e os resultados de revisão | [CLAUDE — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/CLAUDE.md) · [REVISAO-CETICA — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md) |

### Releases anteriores

| Versão | Assunto |
|---|---|
| [5.12.3](docs/releases/5.12.3.md) | Limpeza e organização do projeto |
| [5.12.2](docs/releases/5.12.2.md) | Menor espera no áudio |
| [5.12.1](docs/releases/5.12.1.md) | Microfone sem repetição e rodapé compacto |
| [5.12.0](docs/releases/5.12.0.md) | Microfone único e driver 1.5 |
| [5.11.2](docs/releases/5.11.2.md) | Instalação única |
| [5.11.1](docs/releases/5.11.1.md) | Controles visíveis e janelas nativas |
| [5.11.0](docs/releases/5.11.0.md) | Melhorias de configuração e confiabilidade |
| [5.10.4](docs/releases/5.10.4.md) | Distribuição e verificações anteriores |
