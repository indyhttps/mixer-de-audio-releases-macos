# Mixer de Áudio — manual 5.12.7

[![testes](https://github.com/indyhttps/MixerDeAudio-macOS/actions/workflows/testes.yml/badge.svg)](https://github.com/indyhttps/MixerDeAudio-macOS/actions/workflows/testes.yml)

**Acesso rápido:** [Instalar](#instalar) · [Configurar chamada](#configurar-a-chamada) · [Gate e monitor](#gate-canal-e-monitor) · [Presets e backup](#presets-backup-e-atraso) · [Diagnóstico](#quando-falta-som) · [Mapa do projeto](docs/INDEX.md)

O Mixer captura seu microfone real, altera a voz em tempo real e entrega o resultado para chamadas, gravações e jogos. O aplicativo fica na barra de menus do macOS e usa seu próprio driver virtual; não precisa de BlackHole.

Este é o manual da **5.12.7**, com VU mais responsivo, nome do preset atual e seletor de microfone em cartão próprio. O build universal, os pacotes publicados e a reinstalação limpa foram verificados. O ZIP público e sua assinatura foram baixados sem credenciais; Ed25519 e a igualdade com o app e o driver instalados passaram. Baixe a distribuição nas [releases públicas](https://github.com/indyhttps/mixer-de-audio-releases-macos/releases/latest) e consulte as [notas da versão](docs/releases/5.12.7.md) para conhecer os resultados e limites. O pacote com código-fonte fica somente no [repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS/releases). Os artefatos e resultados da [5.12.6](docs/releases/5.12.6.md) permanecem preservados.

A 5.12.7 conserva o **driver 1.6**, introduzido e publicado na 5.12.6, que impede a leitura de áudio antigo após uma volta do buffer ou uma sobrescrita concorrente. Ele conserva a única entrada virtual **Mixer de Áudio — Microfone**, a mesma seleção para chamadas, gravações e jogos. O dispositivo **Mixer de Áudio** continua oferecendo somente a saída que alimenta esse microfone. O motor WSOLA, o gate e os valores de voz permanecem iguais. Atualizar o driver 1.5 ou anterior exige autorização de administrador e uma recarga do serviço de áudio. Faça esse passo fora de uma chamada e reabra os aplicativos de áudio depois.

**A 5.12.7 atualiza a apresentação do painel.** O VU consulta a leitura real mais recente a 60 Hz quando visível; diagnóstico e calibração ocultos conservam 10 Hz. O controle superior mostra o preset correspondente ou **Personalizado**, com menu de vozes e acesso direto a **Neutro**. Voz e Microfone retomam o alinhamento à esquerda, e as ações do rodapé voltam a mostrar legendas. O cartão **Microfone** seleciona a fonte; **Níveis** reúne Entrada, gate e Saída. Entrada e gate continuam no mesmo slider nativo. Essas mudanças não alteram o processamento, os ajustes de voz ou a calibração. O painel instalado foi conferido, com microfone Enviando e níveis reais de Entrada e Saída variando. Isso não substitui aprovação auditiva ou teste de chamada.

**A 5.12.5 respeita sua escolha de usar o Dock.** Abrir, reabrir, instalar ou atualizar o Mixer não fixa o aplicativo automaticamente. Ele continua acessível pela barra de menus, inclusive quando você o deixa fora do Dock. Um atalho já fixado é conservado e aponta para o aplicativo em Aplicativos; duplicatas próprias são reunidas nesse atalho. Você pode adicioná-lo ou removê-lo quando quiser, seguindo [Usar o Dock](#usar-o-dock). O visual, os ajustes de voz, os buffers e o driver 1.5 são preservados.

**A 5.12.4 corrigiu a desinstalação e o envio de suporte.** Cancelar a autorização preserva os aplicativos e o estado de usuário. A opção **Remover só o app** confere a remoção antes de limpar os dados e anunciar sucesso; o desinstalador externo espera a autorização antes de alterar login ou agregado legado e confirma a remoção antes da limpeza restante. O serviço de suporte passa a recusar um desafio que expire durante suas verificações, evitando o reenvio de um relatório já aceito. O visual aprovado, o processamento de voz e o driver 1.5 continuam preservados. As [notas 5.12.4](docs/releases/5.12.4.md) registram o escopo e a validação desta entrega.

**A 5.12.2 reduz a espera nas filas de áudio.** O app solicita ciclos menores na taxa nativa do microfone e na saída virtual, dimensiona a reserva pelos ciclos concedidos e amplia essa reserva se faltar áudio. Se captura ou processamento perderem prazos repetidamente, os ciclos aumentam automaticamente. O motor WSOLA, o gate, o formato de áudio e os presets calibrados são preservados. O ganho depende do microfone e da carga do Mac; use **Preferências → Saúde e atraso → Medir atraso por 8 segundos** para comparar o caminho real até o microfone virtual. As [notas 5.12.2](docs/releases/5.12.2.md) registram a validação e seus limites.

A **5.12.1** simplifica a apresentação do microfone no painel: quando a fonte escolhida está em uso, seu nome aparece uma vez e a linha abaixo mostra **Em uso**. Ao seguir o padrão do sistema ou usar outra fonte temporariamente, a linha informa o nome realmente capturado. O rodapé usa uma cápsula de estado compacta; clique nela para ler os detalhes do áudio e os avisos. O painel conserva seu visual de vidro da Central de Controle, com as cinco ações distribuídas uniformemente. Essas alterações são de apresentação e conservam o driver 1.5 e o processamento de voz.

Desde a **5.11.1**, o aplicativo usa SwiftUI/AppKit, símbolos e materiais do sistema, tomando o [UI Kit oficial do macOS 27](https://developer.apple.com/design/resources/) e as diretrizes da Apple como referências visuais. O painel principal conserva a composição compacta da Central de Controle, com Liquid Glass nativo aplicado somente ao fundo das superfícies; textos e controles são desenhados por cima. Preferências, Diagnóstico, Presets, Guia e Avisos usam formulários, listas e janelas nativas. A correção evita os cartões vazios e respeita Reduzir Transparência e Aumentar Contraste. O app continua na barra de menus e mantém compatibilidade com macOS 15+.

## Instalar

Requisitos: macOS 15 ou mais novo. A distribuição é preparada para Apple Silicon e Intel.

1. Extraia o ZIP e arraste **Mixer de Áudio.app** para **Aplicativos**.
2. Abra o aplicativo. Se o macOS exigir aprovação de um pacote assinado ad-hoc, use botão direito → **Abrir**. Para um download confiável que seja bloqueado pela quarentena, o procedimento anterior de instalação é `xattr -dr com.apple.quarantine "/Applications/Mixer de Áudio.app"`, seguido de uma nova abertura.
3. Confirme a instalação do dispositivo virtual. O macOS pede sua senha de administrador.
4. Autorize o acesso ao microfone quando o macOS pedir.

Desde a 5.11.2, abrir um instalador extraído instala ou atualiza o aplicativo em **Aplicativos** e remove o instalador temporário após validar o destino. Use o aplicativo em Aplicativos, o item na barra de menus ou um atalho que você tenha escolhido fixar no Dock para abrir o Mixer. Uma atualização cancelada ou falha mantém o instalador para nova tentativa.

**Ao atualizar para a 5.12.0:** encerre os aplicativos que usam áudio, instale o novo driver e reabra-os. Se uma chamada ou gravação tinha **Mixer de Áudio** salvo como entrada, selecione **Mixer de Áudio — Microfone** nas configurações desse aplicativo. A antiga entrada deixa de existir e o Mixer não altera as preferências de outros programas. Quem já selecionava **Mixer de Áudio — Microfone** conserva a identidade desse dispositivo, embora um aplicativo possa exigir nova seleção após reiniciar o serviço de áudio.

Antes de uma instalação limpa com remoção de preferências, use **Exportar configuração** e guarde o JSON fora da pasta do aplicativo. Depois de reinstalar, importe-o e conceda novamente as permissões de microfone e início no login. A configuração do microfone nos aplicativos de chamada deve ser conferida separadamente.

A assinatura e a notarização de um pacote dependem do perfil usado na distribuição. A existência do perfil Developer ID no projeto não significa que um download já esteja assinado ou notarizado com ele.

## Usar o Dock

O Mixer funciona na barra de menus e pode ficar fora do Dock mesmo enquanto está aberto. Instalar, iniciar no login ou abrir o aplicativo novamente conserva essa escolha.

- Para fixá-lo, abra **Aplicativos** no Finder e arraste **Mixer de Áudio.app** para a área de aplicativos do Dock. O atalho deve apontar para `/Applications/Mixer de Áudio.app`.
- Para deixá-lo fora do Dock, clique com o botão direito no atalho e desmarque **Opções → Manter no Dock**, ou arraste o ícone para fora até aparecer **Remover**. O Mixer continua funcionando; use seu item na barra de menus para abrir o painel.
- Se já houver um atalho fixado, a atualização o conserva na mesma posição e reúne duplicatas próprias. Depois de removê-lo, o Mixer não o cria novamente.

## Configurar a chamada

No cartão **Microfone**, escolha seu **microfone real**. O seletor mostra a fonte efetivamente capturada, inclusive ao seguir o padrão do sistema ou usar outra fonte temporariamente. O menu preserva sua escolha; a ajuda e a descrição de acessibilidade informam a seleção e o uso atual. Sem captura, o seletor mostra a escolha ou **Microfone indisponível**.

| Aplicativo | Microfone a selecionar nele | Saída de som |
|---|---|---|
| Google Meet/Safari, Discord, OBS e demais aplicativos | **Mixer de Áudio — Microfone** | Seus fones ou alto-falantes físicos |
| FaceTime | **Mixer de Áudio — Microfone**, no menu **Vídeo** | Seus fones ou alto-falantes físicos |
| Apps que seguem a entrada padrão do macOS | **Mixer de Áudio — Microfone**, em **Ajustes do Sistema → Som → Entrada** | Seus fones ou alto-falantes físicos |

No FaceTime, abra o menu **Vídeo** na barra de menus e escolha o microfone dedicado. O seletor está descrito no [manual da Apple](https://support.apple.com/pt-br/guide/facetime/fctm26739220/mac). Para um app sem seletor que usa a entrada padrão, escolha o virtual nos [ajustes de entrada do macOS](https://support.apple.com/pt-br/guide/mac-help/mchlp2567/mac) e reabra o app se necessário. Aplicativos com seleção própria podem continuar exigindo a escolha dentro deles.

**Ao usar o virtual como entrada padrão do Mac, mantenha um microfone físico escolhido dentro do Mixer**, como o microfone do MacBook ou seu USB/AirPods. Assim o Mixer captura a fonte real e o outro app recebe a voz processada. O seletor do cartão **Microfone** confirma a fonte em uso. **Mixer de Áudio** é a saída de alimentação usada pelo motor e não deve ser escolhida como saída de som da chamada. A entrada única simplifica a seleção; os cenários de funcionamento já observados e os que ainda precisam de teste estão na [matriz de compatibilidade](docs/COMPATIBILITY.md).

**AirPods e Safari:** conecte os fones antes de abrir o navegador. Se trocar ou conectar fones durante o Meet e perder a voz, saia da chamada, encerre e reabra o Safari. A recuperação automática desse cenário ainda precisa ser validada; confira a [matriz de compatibilidade](docs/COMPATIBILITY.md).

## Usar o painel

- Clique no ícone da barra de menus para abrir o painel; o botão direito abre o menu completo.
- O controle superior mostra o **nome do preset atual**. Abra seu menu para escolher uma voz de fábrica ou salva, salvar a voz atual ou gerenciar presets. Sem correspondência com os valores de altura e timbre, ele mostra **Personalizado**. **Neutro** retorna os dois controles para zero em um clique. **Altura** e **Timbre** permitem ajustes finos; no WSOLA atual, ambos contribuem para a transposição combinada.
- **Microfone: Mudo** interrompe o envio; **Enviando** depende da captura e do roteamento saudáveis. O tile também informa **Desligado**, **Sem microfone**, **Conectando** ou **Interrompido**, e a barra de menus usa o mesmo estado. **Voz: Desligada** desliga o processamento; **Ligada** solicita sua ativação.
- **Entrada** mostra o sinal cru; **Saída** mostra o sinal entregue pelo Mixer aos aplicativos. A recepção na chamada também depende da entrada selecionada no aplicativo.
- Os botões circulares com legenda **Fechar** e **Sair** escondem o painel mantendo o áudio ou encerram o aplicativo, respectivamente. **Reconectar**, **Diagnóstico** e **Desinstalar** também ficam na linha de ações. A ajuda ao passar o ponteiro e os nomes de acessibilidade identificam cada ação. O painel principal é compacto e rolável, com cabeçalho próprio para arrastar; as janelas auxiliares permitem redimensionar.
- A cápsula no rodapé mostra estados curtos, como **Ativo**, **Microfone mudo** ou **Desligado**. Um aviso recente aparece como **Novo aviso**. Clique para abrir os detalhes do áudio e o aviso completo, apresentados com texto centralizado. **Todos os avisos…** abre **Estado e avisos**, uma janela compacta com estado atual e histórico centralizados; ela permite rolagem e redimensionamento. As mensagens usam inicial maiúscula, como **Ativo**, também nos detalhes. As opções do painel dão acesso a **Preferências**, **Presets de voz** e **Guia de uso**.

## Gate, canal e monitor

**Calibrar** prepara o microfone, mede 3 segundos de silêncio e 5 de fala, e ajusta o gate. A calibração fica associada ao microfone real; dispositivos ainda não calibrados usam o valor de fallback. O resultado pode ser desfeito nas opções do painel ou nas preferências. Ajustes mais baixos favorecem fala baixa; mais altos bloqueiam mais ruído.

O slider nativo de **Entrada** reúne o nível ao vivo e o ajuste do gate, sem marcas de escala. Arraste o puxador para definir o limiar indicado em dB: o sinal ultrapassa esse ponto na mesma escala da barra. A faixa, o passo de 1 dB e a calibração permanecem iguais. As instruções aparecem durante a calibração; a ajuda do controle conserva a explicação do gate.

Em **Preferências → Entrada e monitor**, uma interface com várias entradas pode usar um **canal específico**. “Misturar todos” conserva o comportamento de mistura original. Os canais são apresentados a partir de 1; um canal indisponível é indicado.

**Ouvir minha voz** toca o sinal processado na saída escolhida nas preferências, ou na saída padrão do Mac. Use fones. A guarda pausa o monitor no par microfone embutido + alto-falantes embutidos. Se usar caixas externas, marque **Esta saída usa alto-falantes externos** para proteger também esse cenário. O estado **Pausado · Use fones** identifica essa proteção. A pausa do monitor não interrompe a transmissão aos aplicativos.

## Presets, backup e atraso

Em **Presets de voz**, salve a voz atual, renomeie, duplique ou atualize um preset. Substituição e exclusão pedem confirmação; **Desfazer última alteração** recupera a lista anterior na mesma sessão. O nome no controle superior corresponde aos valores reais de altura e timbre, inclusive para presets salvos. O nome aplicado é lembrado quando há presets equivalentes; ajustar manualmente os valores pode mostrar outro preset correspondente ou **Personalizado**. Renomear, excluir e desfazer atualizam essa preferência junto da lista.

**Exportar configuração** cria um JSON versionado com voz, presets, calibrações e preferências de dispositivos, atualização e telemetria. **Importar configuração** valida o arquivo e mostra um resumo antes de substituir as preferências. Não inclui gravações, credenciais, permissão de microfone ou autorização de início no login. Depois de reinstalar o macOS, essas autorizações precisam ser concedidas novamente.

**Preferências → Saúde e atraso** distingue estimativas de buffers de uma medição. **Medir atraso** pede fala por alguns segundos e compara captura e saída virtual usando áudio somente em memória. Silêncio ou sinal inadequado podem produzir um resultado inconclusivo. Atraso do monitor e atraso de transmissão são caminhos diferentes; Bluetooth pode acrescentar atraso fora do motor.

## Quando falta som

1. Confira se o aplicativo da chamada usa **Mixer de Áudio — Microfone**, principalmente após atualizar de uma versão com duas entradas.
2. Confira **Voz: Ligada**, **Microfone: Enviando**, a fonte exibida no seletor do cartão **Microfone** e o medidor **Saída**.
3. Use **Reconectar** depois de uma transição de dispositivo.
4. Abra **Diagnóstico** para gerar e ler um relatório local. Driver e roteamento podem ser reparados durante a verificação.
5. Se precisar de suporte, confira a prévia e use **Enviar este relatório ao suporte**. O envio ao canal privado do Discord é uma ação separada; o relatório não inclui gravação de voz.

Atualizações e telemetria podem ser controladas nas preferências. Uma atualização que troca o aplicativo precisa reiniciá-lo; faça isso fora da chamada. O diagnóstico local pode ser usado sem enviar relatório.

## Desinstalar

No painel, escolha **Desinstalar**, ou use **Desinstalar o Mixer de Áudio…** no menu da barra. É possível remover apenas o aplicativo ou remover também o driver. A remoção completa do driver pede autorização de administrador.

Se cancelar a autorização, os aplicativos e o estado de usuário são preservados. Tanto **Remover só o app** quanto a remoção completa conferem os bundles e links restantes antes de limpar o estado ou anunciar sucesso. Uma falha parcial é informada e mantém o app aberto. O desinstalador externo executa a retirada do login e do agregado legado depois da autorização, antes de remover os arquivos; as demais limpezas dependem da remoção confirmada. Se essa remoção autorizada falhar, login e agregado podem já ter sido alterados, e o aviso informa esse limite. Uma falha não produz a mensagem de sucesso.

O pacote também inclui **Desinstalar Mixer de Áudio.command** para limpeza das versões anteriores e resíduos próprios. A identificação de aplicativos e do driver usa o bundle id exato; itens de login e atalhos são removidos pelos caminhos confirmados. BlackHole, Voicemod comercial e outros dispositivos/programas de terceiros são preservados.

## Documentação do projeto

| Preciso consultar… | Documento |
|---|---|
| O mapa de todas as partes do projeto | [Mapa do projeto](docs/INDEX.md) |
| A arquitetura, os testes e a distribuição | [Guia de desenvolvimento](docs/DEVELOPMENT.md) |
| Os cenários conferidos e as pendências de campo | [Compatibilidade](docs/COMPATIBILITY.md) |
| O histórico completo de versões | [Changelog](docs/CHANGELOG.md) |
| A entrega atual | [Notas 5.12.7 — VU responsivo e preset atual](docs/releases/5.12.7.md) |
| A entrega anterior | [Notas 5.12.6 — confiabilidade do áudio e da manutenção](docs/releases/5.12.6.md) |
| As melhorias da 5.11.0 | [Registro das melhorias](docs/IMPROVEMENTS-5.11.0.md) |
| As regras e os resultados de revisão | [AGENTS — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/AGENTS.md) · [REVISAO-CETICA — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md) |

### Releases anteriores

| Versão | Assunto |
|---|---|
| [5.12.6](docs/releases/5.12.6.md) | Confiabilidade do driver, interface e manutenção |
| [5.12.5](docs/releases/5.12.5.md) | Dock opcional |
| [5.12.4](docs/releases/5.12.4.md) | Desinstalação e envio de suporte |
| [5.12.3](docs/releases/5.12.3.md) | Limpeza e organização do projeto |
| [5.12.2](docs/releases/5.12.2.md) | Menor espera no áudio |
| [5.12.1](docs/releases/5.12.1.md) | Microfone sem repetição e rodapé compacto |
| [5.12.0](docs/releases/5.12.0.md) | Microfone único e driver 1.5 |
| [5.11.2](docs/releases/5.11.2.md) | Instalação única |
| [5.11.1](docs/releases/5.11.1.md) | Controles visíveis e janelas nativas |
| [5.11.0](docs/releases/5.11.0.md) | Melhorias de configuração e confiabilidade |
| [5.10.4](docs/releases/5.10.4.md) | Distribuição e verificações anteriores |
