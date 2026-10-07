# Melhorias da versão 5.11.0

**Navegação:** [Mapa do projeto](INDEX.md) · [Manual de uso](../README.md) · [Notas atuais](releases/5.12.3.md)

Este registro histórico acompanha os 40 itens aprovados para a 5.11.0. O item 16 foi excluído por pedido da usuária. Implementação, execução de testes e validação de campo são estados distintos; a matriz de compatibilidade registra os cenários que ainda precisam de hardware ou aplicativos externos. As correções posteriores de UI e robustez são descritas nas [notas da 5.11.1](releases/5.11.1.md).

| Nº | Melhoria e benefício | Implementação |
|---|---|---|
| 1 | Erros de captura/conversão com etapa e OSStatus; facilita localizar a falha. | CaptureUnit e AudioRenderMetrics |
| 2 | Progresso baseado em frames efetivamente entregues; detecta captura que deixou de alimentar o motor. | AudioProgressMonitor e watchdog do grafo |
| 3 | Contadores de falta, excesso, contenção e descarte; permite explicar cortes de áudio. | AudioRingBuffer e relatório de saúde |
| 4 | Escolha de saída do monitor; permite ouvir a voz em fones específicos. | Preferências e rota exclusiva do monitor |
| 5 | Seleção de canal de entrada; atende interfaces com vários microfones. | CaptureUnit e Preferências |
| 6 | Proteção configurável para caixas externas; reduz microfonia do monitor. | Guarda de monitor e preferência persistida |
| 7 | Calibração do gate por microfone; evita reaplicar um perfil inadequado após troca de dispositivo. | Settings e controller, usando UID real ativo |
| 8 | Estimativa e medição de latência; distingue geometria de buffers de atraso observado. | Duas capturas em RAM, timestamps e correlação; teste local retornou 95 ms, correlação 0,97 |
| 9 | Métricas de duração e prazo dos callbacks; identifica sobrecarga do caminho de áudio. | AudioRenderMetrics |
| 10 | Matriz de compatibilidade e recuperação; fornece passos reproduzíveis para falhas de dispositivos e navegadores. | COMPATIBILITY.md, com resultados anteriores e cenários pendentes separados |
| 11 | Testes do ciclo de vida; impede que eventos antigos revivam um grafo parado ou suspenso. | AudioLifecycle e fixtures Swift |
| 12 | Stress concorrente do driver; verifica leitores, blocos variáveis e abertura/fechamento de clientes. | Harness C com ASan/UBSan e TSan |
| 13 | Guia das duas entradas virtuais; reduz seleção errada no Meet, Discord e OBS. | Guia no app e manual |
| 14 | Preferências na interface; torna opções existentes e novas acessíveis sem comandos. | Janela de Preferências |
| 15 | Rótulos e valores acessíveis; melhora uso por VoiceOver. | Controles SwiftUI e componentes CC |
| 16 | Novos atalhos de teclado. | **Excluído; nenhum novo atalho adicionado** |
| 17 | Painel com rolagem; mantém controles legíveis em telas pequenas. | ControlWindow e ContentView |
| 18 | Mensagens completas e histórico da sessão; preserva explicações que antes desapareciam. | Painel Estado e avisos |
| 19 | Preset ativo reconhecido pelos valores exatos; evita indicar uma voz diferente da aplicada. | UserPreset e controller |
| 20 | Gerenciamento de presets; permite renomear, duplicar, atualizar e desfazer alterações. | PresetsView e UserPresetStore |
| 21 | Acesso aos presets pelo painel; facilita descobrir e reutilizar vozes salvas. | Menu de opções do painel |
| 22 | Preparação, resultado e desfazer da calibração; evita perda de um ajuste útil. | Fluxo de calibração do controller |
| 23 | Ícone reflete ligado, mudo e falha; fornece estado visível com a janela fechada. | AppDelegate com atualização por mudança de estado |
| 24 | Backup JSON versionado; facilita restaurar voz, presets e calibrações com validação antes de aplicar. | ConfigurationArchive e ações de importar/exportar |
| 25 | CI de PRs e commits; detecta regressões antes da distribuição. | Workflow testes.yml |
| 26 | Sanitizers do driver no CI; detecta erros de memória e concorrência. | Job de distribuição |
| 27 | Build universal, mínimo macOS e ZIP verificados; evita entregar pacote incompleto ou incompatível. | build.sh, release.sh e check-bundle.py |
| 28 | Migração do backend SwiftPM depreciado. | swiftbuild como padrão, validado na 5.11.0 com os 75 testes Swift no CLT Swift 6.4 e app/driver universais, mínimo macOS 15 e selos estritos; native permanece fallback explícito |
| 29 | Driver compilado obrigatoriamente do fonte; elimina dependência do bundle Vendor arquivado. | build-driver.sh; revisão de empacotamento 1.4 |
| 30 | Projeto XcodeGen com módulos e driver corretos; permite abrir e compilar a arquitetura no Xcode. | project.yml; geração local e build Release sem certificado confirmados pelo [CI da 5.11.0](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/37389124635) |
| 31 | Manifestos vinculam fonte e artefatos ao commit; impede publicar ZIP antigo com tag nova. | release_manifest.py, hashes de conteúdo/modo/symlinks |
| 32 | Publicação retomável em drafts; reduz releases incompletas e uploads duplicados. | publish_release.py, comparação dos assets baixados |
| 33 | Versão única; evita divergência entre código, bundle e pacote. | VERSION, version.py e Version.xcconfig |
| 34 | Testes do fluxo completo do updater; verifica ordem de autenticação, extração, instalação e limpeza. | UpdatePipeline, fixtures e Ed25519 real |
| 35 | Concorrência rigorosa; explicita a propriedade de estado entre UI e filas de áudio. | MixerCore em Swift 6, app com verificação completa |
| 36 | Developer ID e notarização; prepara distribuição reconhecida pela Apple. | Perfis e scripts prontos; **emissão do certificado e notarização pendentes de aprovação/ativação da conta Apple** |
| 37 | Diagnóstico local separado do envio; permite revisar o relatório antes de compartilhá-lo. | DiagnosticsView e botão explícito de envio |
| 38 | Política única de redação de dados; reduz exposição de nomes, caminhos, UIDs, MACs e credenciais. | PrivacyRedactor aplicado a relatórios, anexos e telemetria |
| 39 | Endpoint público com destino privado; remove o webhook do cliente e limita abuso. | SupportRelay publicado, segredo no servidor, quotas, desafio e nonce único |
| 40 | Manual, desenvolvimento e histórico separados; torna manutenção e uso mais claros. | README, DEVELOPMENT, COMPATIBILITY, CHANGELOG e notas de release |

A medição de latência não inclui fones, Bluetooth, navegador ou chamada. O DSP, a geometria do gate e o preset calibrado não foram alterados. A disponibilidade do endpoint não autoriza envio automático de relatórios; a ação continua explícita no aplicativo.

Na validação publicada da **5.11.0**, passaram **75 testes Swift**, **14 testes Python da distribuição/publicação** e **4 testes Node do relay**, além dos harnesses do driver com sanitizers. Os quatro jobs do [CI correspondente ao commit 1d99ecf](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/37389124635) concluíram com sucesso. Essas contagens são históricas; não representam as suítes ampliadas nem a validação nativa da 5.11.1.
