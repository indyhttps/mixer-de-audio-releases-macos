# Desenvolvimento do Mixer de Áudio

**Navegação:** [Mapa do projeto](INDEX.md) · [Manual de uso](../README.md) · [Notas atuais](releases/5.12.4.md)

Este guia descreve a arquitetura e o fluxo de trabalho do código 5.12.4. Os comandos abaixo são procedimentos; resultados de uma execução, aprovação auditiva e publicação devem ser registrados separadamente nas notas da release e em [REVISAO-CETICA.md](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md). As regras de [CLAUDE.md](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/CLAUDE.md) continuam obrigatórias. Esses dois registros pertencem ao repositório privado e exigem acesso; os manuais de uso e as notas atuais acompanham ambos os ZIPs.

A 5.12.4 corrige dois caminhos de cancelamento da desinstalação: a opção **Remover só o app** respeita o resultado da autorização e confere os bundles restantes; o desinstalador externo espera a autorização e revalida as identidades antes dos utilitários de login/agregado e da remoção, confirmando a ausência dos bundles antes da limpeza restante. O relay também revalida a expiração dos desafios depois das esperas no banco, antes de encaminhar relatórios. O DSP, os buffers, o visual aprovado e o driver 1.5 conservam o estado da 5.12.3. A organização dos manuais no [mapa do projeto](INDEX.md) permanece. Produtos de compilação, caches e dependências geradas do relay podem ser recompostos; sua limpeza não altera o tamanho do app distribuído. `.build/` também contém chaves, configuração de publicação, backups privados e artefatos de releases, que continuam necessários para manutenção e recuperação.

## Componentes e caminho do áudio

```text
Microfone físico
  → CaptureUnit (AUHAL de entrada)
  → conversão para mono / 48 kHz e seleção de canal
  → micRing
  → FormantPitchAU: wrapper Swift + WSOLA C++ e gate
  → saída de alimentação “Mixer de Áudio”
  → driver AudioServerPlugIn: ring de loopback compartilhado
  → única entrada “Mixer de Áudio — Microfone”
  → aplicativo consumidor

Sinal processado → monRing → saída física escolhida (monitor opcional)
```

- **Aplicativo:** Swift/AppKit/SwiftUI, agente na barra de menus, sem Dock. Captura, DSP, roteamento, UI e preferências ficam no app.
- **Motor:** `Vendor/MixerDsp/` contém WSOLA em C++. A ponte C evita reimplementar o algoritmo em Swift. Altura e timbre contribuem para uma transposição combinada; o timbre atual não é o controle independente de formantes do vocoder antigo.
- **Driver próprio:** `MixerDeAudioDriver.driver`, hospedado no `coreaudiod`, recebe a escrita do app na saída “Mixer de Áudio” e disponibiliza o áudio na única entrada “Mixer de Áudio — Microfone”. O escritor não tem canais, streams nem controles de entrada; o microfone não oferece uma saída associada. O driver é estéreo a 48 kHz; o processamento de voz do app trabalha em mono.
- **Monitor:** segue um caminho separado até fones/alto-falantes. Mudar sua saída ou pausá-lo não muda a entrada virtual transmitida.
- **Lógica testável:** `MixerCore` reúne gate, calibração, presets, buffers, guardas do updater e arquivo de configuração. O alvo de testes importa essa biblioteca, pois não importa o executável.

O BlackHole pertence às versões antigas. Não é dependência do pipeline atual. O `FormantPitchShifter` legado permanece desconectado para A/B e reversão. A preferência histórica `naturalVoice` continua preservada, sem reintroduzir o toggle removido do painel.

## Estrutura

| Caminho | Finalidade |
|---|---|
| `Sources/MixerDeAudio/` | Aplicativo, interface, captura, grafo, atualização e diagnóstico |
| `Sources/MixerCore/` | Regras puras, buffers, configuração e guardas |
| `Vendor/MixerDsp/` | Motor C++ compartilhado com Windows |
| `Vendor/MixerDeAudioDriver-src/` | Fonte C e metadados do driver |
| `Vendor/MixerDeAudioDriver.driver/` | Snapshot 1.5 para recuperação; builds novos compilam a fonte |
| `Services/SupportRelay/` | Serviço separado de encaminhamento do relatório de suporte |
| `Tests/` | Regressões Swift, driver com sanitizers e contratos da distribuição |
| `tools/` | Build do driver, versão, assinatura, manifestos e publicação |
| `Resources/` | PNG original e ICNS do aplicativo |
| `docs/` | Mapa, arquitetura, compatibilidade, histórico e notas de releases |
| `VERSION`, `Info.plist`, `Version.xcconfig` | Versão autoritativa e metadados sincronizados |
| `Package.swift`, `project.yml` | Build SwiftPM e projeto opcional XcodeGen |
| `.github/workflows/testes.yml` | CI de regressões e distribuição universal |
| `.build/` | Produtos locais, artefatos, ferramentas e dados privados de manutenção |

O [mapa detalhado](INDEX.md#pastas-e-arquivos-principais) identifica os arquivos de cada componente e os comandos correspondentes. As pastas de fonte e os recursos visuais mantêm seus caminhos. Em `.build/`, preserve as chaves e os helpers usados na publicação, os backups privados e as releases anteriores; apenas caches e produtos reconstruíveis pertencem à limpeza de temporários.

`Config.swift` é a fonte do preset macOS. A referência visual é o [UI Kit oficial do macOS 27](https://developer.apple.com/design/resources/) e as [diretrizes de interface do macOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-macos). O app usa SwiftUI/AppKit, símbolos e materiais da plataforma. O painel principal conserva a composição compacta de 320 pt da Central de Controle, com círculos de ação e fundo translúcido. As cinco janelas auxiliares usam formulários, listas e controles padrão, cores semânticas, tipografia e métricas do sistema. O programa permanece na barra de menus e tem mínimo macOS 15.

Na correção 5.11.1, `glassEffect` do painel principal é aplicado somente à camada decorativa de fundo; ela não intercepta cliques e fica oculta da acessibilidade. Textos e controles são desenhados normalmente por cima. Aplicar o material ao próprio conteúdo podia produzir cartões vazios, embora a árvore AX ainda expusesse os elementos. As [orientações da Apple para adotar Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass) são referência para o uso de componentes e materiais do SDK. Liquid Glass nativo é usado quando disponível; macOS anteriores usam materiais compatíveis. Reduzir Transparência e Aumentar Contraste acionam fundos opacos e cores semânticas. QA exige **captura nativa e acessibilidade**, interação e rolagem no painel, além de redimensionamento das janelas auxiliares. Uma árvore AX completa não prova que o conteúdo foi desenhado; referência ao kit não é uma declaração de reprodução pixel a pixel de um frame.

## Compilar e testar

Requer Command Line Tools. Os scripts selecionam o CLT quando instalado, evitando usar um Xcode cuja licença não tenha sido aceita.

```sh
./test.sh
bash Tests/Driver/test.sh
python3 -m unittest discover -s Tests/Release -p 'test_*.py'
./build.sh
```

`build.sh` prepara um bundle universal em `.build/distribution/Mixer de Áudio.app` e recompila o driver do fonte antes de embuti-lo. A versão vem de `VERSION`; execute `python3 tools/version.py sync` após alterá-la e `python3 tools/version.py check` para conferir `Info.plist` e `Version.xcconfig`. `MIXER_APP_OUTPUT_DIR` indica outro destino completo, terminado em `Mixer de Áudio.app`. `MIXER_SCRATCH_PATH` separa produtos SwiftPM de um experimento. Um `DEVELOPER_DIR` explícito prevalece sobre a escolha automática do CLT.

O `MixerCore` compila em modo Swift 6. O executável mantém Swift 5 com `strict-concurrency=complete` durante a migração; os contratos do caminho de tempo real precisam ser preservados. Para gerar o projeto opcional de assinatura no Xcode, rode `python3 tools/version.py sync` e depois `xcodegen generate`; a configuração contém os módulos DSP/Core e a etapa do driver.

O CI mantém um job separado que instala XcodeGen, confere os metadados, gera o projeto e executa `xcodebuild -project MixerDeAudio.xcodeproj -scheme MixerDeAudio -configuration Release -derivedDataPath .build/xcode-validation CODE_SIGNING_ALLOWED=NO build`. Ele verifica os vínculos dos módulos em um Xcode licenciado; o fluxo SwiftPM continua sendo a distribuição canônica. A geração com XcodeGen 2.46.0 foi conferida localmente, enquanto esse build depende da execução do job. Com um Xcode cuja licença ainda não foi aceita, use o CLT para o fluxo canônico.

A suíte Swift usa **Swift Testing**, não XCTest. `test.sh` configura os caminhos do framework Testing do CLT. A contagem varia com os testes adicionados; o requisito é a suíte completa passar. Os testes do motor cobrem neutro bit-exato, razão de transposição, determinismo, reset, latência algorítmica e entradas não finitas. MixerCore cobre regras de gate/calibração, presets, buffers e validações de configuração/atualização.

Os harnesses C exercitam topologia, proprietários/UIDs, tamanhos de propriedades, controles, clock/start/stop, leitores simultâneos, lacunas e wrap. ASan/UBSan e TSan detectam classes distintas de falha; nenhum deles comprova por si só o funcionamento em uma chamada de navegador.

O backend SwiftPM e os caches devem seguir os scripts da árvore atual. Para um comando manual, selecione explicitamente o CLT:

```sh
DEVELOPER_DIR=/Library/Developer/CommandLineTools swift build --build-system swiftbuild
```

O backend **swiftbuild** é o padrão dos scripts e do job obrigatório de distribuição no CI. Na validação da 5.11.0 em 2026-10-05, o CLT Swift 6.4 executou os 75 testes e produziu app/driver universais com mínimo macOS 15 e selos `codesign --deep --strict` válidos. As macros Testing funcionaram com os caminhos/plugin configurados pelo script. Esse resultado é histórico; mudanças posteriores exigem nova execução da suíte.

O script compila com `--arch`, confere cada arquitetura por `lipo`, resolve a saída com `--show-bin-path` e copia cada slice para um staging próprio antes do próximo build. O swiftbuild usa o mesmo caminho de produto para as duas arquiteturas e a segunda compilação substituiria o primeiro slice; o backend Swift 6.3 no CI também ignorava `--triple`. `MIXER_BUILD_SYSTEM=native ./test.sh` e `MIXER_BUILD_SYSTEM=native ./build.sh` mantêm o backend depreciado como fallback explícito; o CI o exercita em um job diagnóstico com falha permitida.

O swiftbuild do CLT 6.4 injeta caminhos inexistentes de frameworks/bibliotecas do ambiente Xcode, gerando avisos de linker sobre esses diretórios. Essa limitação do toolchain foi observada na validação; não houve avisos do código-fonte. Os resultados no runner Xcode são conferidos separadamente pelo CI.

## Reconstruir o driver

Execute `bash tools/build-driver.sh` para reconstruir somente o driver em `.build/driver/MixerDeAudioDriver.driver`. `MIXER_DRIVER_OUTPUT_DIR` pode indicar outro destino terminado nesse nome. O script conserva o mínimo **`-mmacosx-version-min=15.0`** nas duas arquiteturas, monta e assina o bundle, e verifica arquitetura, deployment target e selo. A receita C original permanece no cabeçalho do fonte.

Ao mudar o C, aumente `CFBundleVersion` em `Vendor/MixerDeAudioDriver-src/Info.plist`, ou uma máquina com o driver instalado não reconhecerá a atualização. A instalação na HAL exige proprietário `root:wheel` e recarga do `coreaudiod`. Não reinicie esse serviço em sequência rápida.

O build do app e da release chama essa etapa automaticamente. O binário histórico em `Vendor/` não é reutilizado em uma nova distribuição.

O driver do fonte tem versão **1.5** na distribuição 5.12.3, preservada desde a 5.12.0. O dispositivo escritor preserva nome e UID `MixerDeAudio_UID`, com somente saída, e o microfone dedicado preserva nome e UID `MixerDeAudio_Microphone_UID`, com somente entrada. A topologia retira a entrada duplex antiga; o ring e o clock continuam compartilhados entre escritor e consumidores. O app deve resolver o escritor ao enviar áudio e o microfone dedicado ao medir ou ler a transmissão. Nenhum deles pode ser escolhido como fonte física do próprio Mixer. O escritor continua inelegível como saída padrão do sistema.

Seleções salvas por consumidores no UID legado não migram automaticamente: o usuário precisa escolher “Mixer de Áudio — Microfone” no aplicativo consumidor. A preservação do UID dedicado mantém a identidade das seleções que já o utilizavam. A enumeração de um único dispositivo com canais de entrada e uma leitura HAL com sinal são verificações locais; não substituem chamadas reais no Safari, Discord ou OBS.

Para FaceTime, a seleção dedicada fica no [menu Vídeo](https://support.apple.com/pt-br/guide/facetime/fctm26739220/mac). Apps que usam a entrada padrão do macOS podem recebê-la por **Ajustes do Sistema → Som → Entrada**; os que mantêm seleção própria precisam da escolha dentro do app. Ao configurar o virtual como padrão, fixar um microfone físico dentro do Mixer e confirmar a fonte ativa. O filtro de ambos os UIDs impede recapturar o sinal processado. QA deve distinguir enumeração no app nativo, captura local e recepção em uma chamada real.

A 1.4 da 5.11.0 era uma revisão de empacotamento, com C e DSP inalterados. O bundle versionado em `Vendor/MixerDeAudioDriver.driver` acompanha agora a **1.5 recompilada**, para consistência do código entregue e recuperação manual; build e release continuam recompilando a fonte e não usam esse snapshot como entrada. A instalação do próprio driver pelo app usa autorização de administrador em janela do macOS e uma única recarga do CoreAudio; não repita recargas para testar a atualização.

O instalador independente `bash Vendor/instalar-driver.command` também compila a fonte atual como usuário. Um argumento explícito permite usar um bundle preparado, por exemplo `bash Vendor/instalar-driver.command ".build/driver/MixerDeAudioDriver.driver"`. Ele prepara a cópia em `/private/tmp`, valida assinatura/identidade/versão e só então solicita administrador para a transação. A troca usa staging e backup próprios na HAL; recusa links simbólicos, outro identificador no destino e downgrade. Falha de validação final ou recarga restaura o estado anterior; se a restauração falhar, o erro informa o backup preservado. As fixtures Python usam bundles temporários e simulam assinatura, propriedade e recarga, sem sudo ou reinício de serviço reais.

## Conferir o driver instalado

Após instalar e aguardar o CoreAudio publicar os dispositivos, a ferramenta abaixo lista a topologia real em JSON e exige somente um microfone do Mixer. Ela apenas lê propriedades da HAL:

```sh
DEVELOPER_DIR=/Library/Developer/CommandLineTools xcrun swift tools/check-installed-routing.swift --check
```

Para conferir o áudio do driver instalado, **encerre o Mixer antes** e compile o teste nativo:

```sh
mkdir -p .build/tools
DEVELOPER_DIR=/Library/Developer/CommandLineTools xcrun clang -std=c11 -O2 -mmacosx-version-min=15.0 \
    -framework CoreAudio -framework CoreFoundation -framework AudioToolbox -framework AudioUnit \
    tools/test-installed-loopback.c -o .build/tools/test-installed-loopback
.build/tools/test-installed-loopback
.build/tools/test-installed-loopback --voice-processing
```

O teste escreve tons sintéticos diretamente na saída do driver e lê o microfone dedicado por dois clientes HAL. Mede continuidade e sinal, incluindo abrir e fechar um leitor enquanto o outro permanece ativo. Ele não captura o microfone real, salva PCM, altera entrada/saída padrão, modifica ganhos ou reproduz som físico. Aborta se detectar o Mixer aberto, para que o escritor sintético não dispute o áudio com o app.

O modo opcional `--voice-processing` acrescenta uma leitura pelo componente **VoiceProcessingIO da Apple**, mantendo sua saída física desabilitada e conferindo o vínculo com a entrada virtual. Esse cenário sem saída física não substitui uma chamada no FaceTime/Safari, nem testa toda a referência de eco ou a conexão Bluetooth usada pela chamada. Falhar nessa configuração pode indicar que esse modo sem saída não é suportado; não prova incompatibilidade do FaceTime. Registre teste HAL, teste VPIO, enumeração nos seletores e chamada real como evidências distintas. Ao terminar, reabra o Mixer e confira sua fonte física e a entrada dedicada no consumidor.

## Preferências e configuração portátil

`Settings` persiste preferências em UserDefaults; o controller coordena UI e grafo. A seleção de origem usa UID, conservando a preferência quando o dispositivo some temporariamente.

O painel mostra **Em uso** quando `activeMicUID` corresponde ao `selectedSourceTag` de uma fonte fixada, deixando o nome apenas na linha de seleção. A comparação usa a identidade do dispositivo, não o nome. O modo de seguir o padrão, o fallback e as transições continuam mostrando **Em uso: nome** da fonte capturada; ausência de captura mostra **Em uso: nenhum**. Esse rótulo não muda a seleção, o grafo nem as preferências.

`CCStatusCapsule` apresenta o estado curto no rodapé com símbolo SF e material de vidro. O clique abre um popover SwiftUI nativo com o estado completo, o aviso transitório atual e acesso à janela de histórico por **Todos os avisos…**. Título, texto do estado, aviso e botão ficam centralizados, incluindo as linhas quebradas. Avisos têm prioridade no rótulo **Novo aviso**; a acessibilidade conserva o texto completo do estado ou aviso apresentado. A inspiração visual em Dynamic Island é aplicada ao painel do app, sem integração com uma superfície do sistema nem animação contínua.

`CCText.sentence` coloca somente o primeiro caractere em maiúscula na apresentação de estado, calibração, legenda de nível e avisos. `statusText`, o grafo e `noticeHistory` conservam seus dados originais. O popover e seu valor de acessibilidade usam a mesma apresentação, incluindo **Ativo**.

`NoticesView` conserva `Form` com estilo agrupado nativo. Cabeçalhos, mensagens completas, horários e estado vazio ficam centralizados; os textos podem ser selecionados. A janela **Estado e avisos** usa altura inicial de 360 pt, mantendo rolagem e redimensionamento. As demais janelas auxiliares conservam a altura inicial de 620 pt.

O painel conserva os controles e tokens visuais anteriores da Central de Controle: seletor de voz, botões de ajuste e ações circulares com superfícies de vidro decorativas. O conteúdo interativo permanece fora da captura de `glassEffect`, e as camadas de fundo não interceptam cliques. O popover de estado usa a apresentação nativa do SwiftUI. Os [UI Kits oficiais do macOS 27 e iOS 27](https://developer.apple.com/design/resources/) são referências visuais. A composição da Central de Controle do iOS informa a linguagem modular, sem substituir as métricas do Mac por alvos de toque do telefone. Somente uma conferência renderizada e a avaliação da usuária podem validar a aparência no app instalado; a consulta dos kits não comprova identidade de pixels. Os arquivos e assets licenciados permanecem fora do Git e dos pacotes.

As cinco ações do rodapé ocupam células de largura igual, conservando a distância entre seus centros e os comandos Reconectar, Fechar, Sair, Diagnóstico e Desinstalar. Essa distribuição evita que o comprimento das legendas desloque os círculos.

A janela do painel tem cabeçalho próprio e `fullSizeContentView`. O conteúdo ignora somente a safe area superior do container, evitando um inset adicional da barra de título; as demais bordas mantêm seus limites. A altura deve continuar sendo medida pela sonda e conferida em captura nativa com o rodapé visível.

Calibrações do gate ficam em um mapa por **UID do microfone real ativo**. A fonte escolhida e o fallback efetivamente capturado podem ser diferentes; a calibração precisa seguir a fonte efetiva. O valor global permanece como fallback para microfones sem perfil.

A seleção de canal usa índice zero-based na implementação e número a partir de 1 na UI. `nil` preserva o downmix original. A saída de monitor usa UID; `nil` acompanha a saída padrão. A declaração explícita de caixas externas aciona proteção de monitor, sem classificar todo dispositivo USB como caixa.

`ConfigurationArchive` contém um JSON versionado. A importação valida versão, tamanho, limites numéricos, nomes, duplicatas e quantidade de presets antes de aplicar. Não importar permissões TCC, itens de login, logs ou credenciais junto com preferências. A UI mostra um resumo antes de substituir a configuração.

Nomes importados de presets são normalizados por trim antes de persistir, com a mesma comparação sem distinguir maiúsculas/minúsculas usada ao salvar, renomear e excluir. A importação cancela a calibração em andamento e descarta seu estado de desfazer, impedindo que uma tarefa iniciada com a configuração anterior sobrescreva o backup recém-importado. Mudança de canal, fonte ou desligamento da voz também cancela medições incompatíveis. Eventos de dispositivo atualizam a lista de saídas e a contagem de canais, além da lista de microfones.

## Diagnóstico e latência

O diagnóstico gera uma prévia local e pode reparar instalação/roteamento. Enviar ao suporte é uma operação separada, sobre o relatório mostrado. O relatório contém estado técnico anonimizado; não inclui uma gravação de voz. Testes e QA não devem postar relatórios reais como efeito colateral.

O envio usa o serviço em `Services/SupportRelay`, hospedado em `https://mixer-de-audio-suporte.ingryd.chatgpt.site`. `GET /v1/challenge` emite o desafio temporário; `POST /v1/report` aceita o relatório após verificar validade, prova SHA-256, uso único, formato, tamanho e limites de envio. `SUPPORT_WEBHOOK` e `RELAY_SECRET` são variáveis secretas da hospedagem, sem cópia no app, no Git ou nos pacotes. O serviço armazena contadores/nonces e hashes de origem, sem persistir o relatório; falha preserva o relatório local.

Corpos JSON nulos, arrays e valores primitivos são rejeitados com HTTP 400 antes de acessar seus campos ou alterar metadados de abuso. Esse caminho não consulta o banco nem encaminha conteúdo ao suporte. As fixtures usam transporte simulado para conferir esse comportamento.

Os testes do relay (`pnpm test` dentro de `Services/SupportRelay`) usam SQLite em memória e transporte simulado. `pnpm build` prepara a distribuição do serviço. Publicar o app não publica automaticamente o relay; a hospedagem Sites e suas migrações/variáveis precisam ser mantidas separadamente. A proteção de desafios reduz abuso e não autentica a identidade de quem envia.

O CI executa `node --test tests/*.test.mjs` nessa pasta em Ubuntu com Node 24, sem instalar dependências de build nem acessar credenciais de suporte. Esse job só verifica as fixtures locais; não publica o serviço e não envia relatórios reais.

Contadores de callbacks, conversão, buffers e progresso ajudam a diferenciar silêncio legítimo de captura interrompida. Estimativas de atraso somam geometria de buffers/processamento. A medição ponta a ponta compara áudio de entrada e saída virtual, somente em memória; deve retornar **inconclusivo** quando não houver correlação suficiente. Não rotular uma estimativa como medição.

O atraso algorítmico do WSOLA não representa sozinho o atraso de transmissão, monitor, Bluetooth ou navegador. Mudar geometria do DSP para reduzi-lo exige a aprovação auditiva descrita nas regras do projeto.

## Preparar distribuição

```sh
./release.sh
./publicar.sh notas.md --dry-run
./publicar.sh notas.md
```

`release.sh` prepara os dois pacotes em `.build/releases`: privado completo e público sem fonte. `MIXER_RELEASE_OUTPUT_DIR` altera o destino. Os dois incluem README, changelog, manual de desenvolvimento, matriz de compatibilidade e as notas em `docs/releases/`, incluindo `<VERSION>.md`. A validação rejeita a ausência das notas atuais. O manifesto embutido associa commit, fingerprint do fonte e hashes dos binários; `release-artifacts.json` associa os ZIPs aos mesmos dados. A validação também compara o fonte dentro do ZIP privado, incluindo permissões e symlinks.

A release exige árvore limpa. `MIXER_ALLOW_DIRTY_RELEASE=1` permite preparar um candidato local, que o publicador recusa. `MIXER_RELEASE_SKIP_TESTS=1` serve somente para reempacotar um fonte já validado; a execução normal roda as suítes Swift, driver e publicação. Antes da publicação, a árvore, commit, fonte e ZIPs precisam continuar idênticos ao manifesto.

`publicar.sh --dry-run` confere os artefatos e mostra o plano sem autenticação ou escrita remota. A execução real valida a `main` remota e a tag, prepara as duas releases como rascunhos e confere uploads byte a byte. Uma interrupção pode ser retomada com o mesmo comando; assets divergentes não são sobrescritos. As releases só ficam visíveis após ambas conterem os assets completos. O publicador confere downloads públicos e `releases/latest`, que o updater consulta.

Uma mudança no aplicativo ou nos pacotes de uma release publicada exige aumentar `VERSION`, sincronizar os metadados e criar notas próprias. A entrega 5.12.4 usa a tag `v5.12.4` no repositório privado, vinculada ao commit `f011bf8186f3a3cf748ea0a488e723b26df0b6c0`; seus ZIPs, assinaturas, manifestos e tag permanecem imutáveis. O comando da entrega atual foi `./publicar.sh docs/releases/5.12.4.md`. Para uma próxima versão, faça commit e push da mesma fonte validada, prepare os artefatos e publique com as novas notas correspondentes. Preserve as releases anteriores.

Após publicar e conferir os downloads, a documentação em `main` e os manuais públicos podem receber os resultados finais sem refazer os ZIPs ou mover a tag publicada. Esse commit de documentação é distinto do commit registrado nos manifestos e não representa uma nova compilação, instalação ou validação humana. Atualize o README público somente com dados conferidos; uma mudança no conteúdo dos pacotes exige uma nova versão. No repositório público, a tag `v5.12.4` conserva a documentação publicada originalmente; os manuais finais ficam em `main`.

A assinatura Ed25519 do ZIP público é independente de assinatura de código/notarização Apple. A chave privada de atualização fica fora do Git, dos pacotes e de backups públicos. Não substituir ou divulgar essa chave. Um novo par exige a transição da chave pública embutida antes de passar a assinar somente com a nova privada.

`MIXER_SIGNING_KEY` aponta para a chave Ed25519; o padrão é `~/.config/mixerdeaudio/release-signing.key`. A release gera o `.sig` quando a chave está disponível; publicar exige a chave e verifica que sua pública corresponde à embutida no app. Para autenticar publicação, configure `MIXER_GH_BIN` com um `gh` autenticado e preserve seu `GH_CONFIG_DIR`, ou use `MIXER_GITHUB_TOKEN_FILE`; o helper Git existente é o fallback. Tokens não são escritos nos manifestos nem passados em argumentos. `MIXER_GIT` permite indicar o executável/helper Git usado para ler o snapshot.

Perfis de assinatura de código e notarização devem ser configurados no ambiente de distribuição. Credenciais e identidades disponíveis precisam ser verificadas antes da execução. A existência dos scripts não confirma uma assinatura Developer ID, aprovação da Apple ou release publicada. Confira o pacote extraído, arquiteturas, mínimo do sistema, driver embutido e assinatura correspondente ao perfil antes de entrega.

- `MIXER_SIGNING_MODE=adhoc`: padrão para a distribuição atual.
- `MIXER_SIGNING_MODE=developer-id`: exige `MIXER_DEVELOPER_ID` de um certificado real no Keychain; assina com hardened runtime e registra o Team ID efetivo no bundle para o updater.
- `MIXER_SIGNING_MODE=notarized`: exige também `MIXER_NOTARY_PROFILE`, perfil já armazenado no `notarytool`; só termina após status `Accepted`, staple, validação do ticket e avaliação do Gatekeeper.

`bash tools/notarize.sh "/caminho/Mixer de Áudio.app"` aplica a etapa de notarização a um bundle já assinado com Developer ID. Escolher um perfil obrigatório sem certificado/credencial aborta; não há conversão silenciosa para ad-hoc. A distribuição atual só pode ser anunciada como notarizada depois de concluir essas verificações reais.

## Instalação e desinstalação próprias

O instalador prepara e valida um bundle completo antes da troca. A publicação usa staging no volume de destino, validação de assinatura e backup retido até conferir o aplicativo instalado. Falha de validação final restaura o bundle anterior; se a própria restauração falhar, o backup completo permanece disponível e o erro informa seu caminho. A instalação elevada usa a mesma rotina de troca, com uma cópia preparada pelo usuário em `/private/tmp`, porque o processo elevado pode não ler Downloads sob TCC.

Os dois desinstaladores reconhecem aplicativos pelos ids do projeto e revalidam a identidade antes de uma remoção elevada. O driver só é removido quando seu `CFBundleIdentifier` é `com.local.mixerdeaudio.driver`; somente essa remoção provoca a recarga do CoreAudio. Encerramento de processos usa a identidade registrada no AppKit, não o nome `VoiceMod`. Itens de login e atalhos seguem os caminhos de bundles confirmados. BlackHole e seu recibo, Voicemod comercial e outros plugins/programas de terceiros são preservados.

As fixtures de desinstalação exercitam o shell gerado somente contra bundles falsos em uma pasta temporária, substituindo a operação de CoreAudio por um marcador. Elas não executam o desinstalador real, não solicitam senha e não alteram aplicativos, permissões, preferências ou serviços do Mac.

## Validação de campo

Use [COMPATIBILITY.md](COMPATIBILITY.md) para distinguir observações anteriores de testes pendentes da versão atual. Valide instalação, reabertura, suspensão/retomada, troca de fonte/saída, mute, gate, monitor e consumidores simultâneos. Confirme a presença de uma única entrada do Mixer, a seleção dedicada em cada consumidor e a migração de seleções antigas. Inclua FaceTime e consumidores nativos que seguem a entrada padrão, sempre com fonte física fixada dentro do Mixer. No Safari/Meet, inclua hotplug de AirPods; não prometer recuperação automática apenas porque a leitura nativa do driver funciona.

Materiais de vidro não renderizam plenamente fora da tela. QA do painel precisa verificar legibilidade, geometria de acessibilidade, primeira resposta ao clique e a renderização nativa em uma tela real. Uma captura headless não substitui essa etapa.

## Desinstalação e cancelamento

A identificação de bundles usa `com.local.mixerdeaudio` e os identificadores legados documentados, com revalidação antes da remoção. A identificação por nome ou glob não autoriza remover programas de terceiros. O driver continua em 1.5; a correção da 5.12.4 não altera sua topologia ou processamento.

Nos dois fluxos corrigidos, a autorização antecede as alterações destrutivas. O cancelamento conserva os bundles e o estado de usuário. Em **Remover só o app**, toda a limpeza de estado depende da remoção confirmada. No desinstalador externo, o passo autorizado revalida os IDs, libera um worker do usuário para executar os binários originais com `--unregister-login --destroy-legacy-aggregate` e aguarda sua conclusão antes de remover os arquivos como administrador. O worker publica o marcador de conclusão por `mv` atômico, depois de escrever seu resultado completo em um arquivo temporário. LaunchServices, preferências, TCC, atalhos e encerramento só seguem após confirmar a ausência dos bundles. Uma falha posterior à autorização pode deixar login/agregado alterados; o aviso informa esse limite e a limpeza restante é interrompida. Autorização concedida não comprova que o comando removeu todos os destinos.

As regressões devem usar bundles falsos e ferramentas simuladas para cancelar a autorização, provocar falha de remoção e concluir com sucesso. Inclua um conjunto com cópia gravável e outra que precisa de autorização, conferindo que o cancelamento preserva ambas. Não execute a desinstalação real como etapa dos testes automatizados.

## Expiração dos desafios de suporte

O relay confere novamente `Date.now()` depois do consumo do identificador do desafio e depois da checagem de quotas, antes de encaminhar o relatório. A validação inicial não basta: a espera pelo banco pode atravessar a expiração enquanto outra requisição limpa o identificador usado. As duas regressões novas simulam essa concorrência e a expiração durante as quotas com banco em memória e transporte falso. Publicar o app não atualiza o serviço; o endpoint hospedado precisa de uma implantação separada e conferida.

## Regras de mudança

- O ouvido da usuária valida mudanças de som; medição equivalente não substitui A/B auditivo.
- `Vendor/MixerDsp/` mantém paridade byte a byte com o Windows, com a exceção de includes documentada em CLAUDE. Mudanças de geometria do gate também exigem espelho.
- Não “corrigir” constantes dormentes de preset Windows no header para igualar o preset ativo do macOS.
- Não remover o motor legado nem alterar a linguagem visual.
- Instalação, desinstalação e limpeza identificam o bundle id próprio; software de terceiros permanece fora do escopo.
- Não entregar mudança relevante sem a suíte apropriada e registrar limites honestos de validação.

As falhas conhecidas e falsos positivos refutados ficam em [CLAUDE.md](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/CLAUDE.md) e [REVISAO-CETICA.md](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md), no repositório privado.


## Buffers e prazos na 5.12.2

`AudioIOBufferPolicy` pede ciclos de 64 frames no relógio de 48 kHz e os converte para tamanhos nativos de potência de dois. Pedidos recusados usam 128/256 frames equivalentes e o fallback legado quando ele amplia a margem. O ciclo concedido pelo AU, os tamanhos efetivamente escritos/lidos e o relógio do hardware são conceitos distintos: o tamanho do dispositivo HAL não deve ser somado como uma fila adicional nem usado para inferir a rajada do produtor quando o AU entrega callbacks menores.

A reserva de transmissão cobre produtor, consumidor e folga; Bluetooth conserva pelo menos 20 ms e duas rajadas do produtor. `AudioRingBuffer` só reduz a reserva no setup. Depois, sob falta ou crescimento de rajada, a reserva cresce monotonicamente, preservando o PCM já enfileirado. Medição offline conserva `drainsBacklog: false` e não habilita recuperação.

`AudioRenderBufferRecovery` observa deltas de callbacks e de prazos excedidos fora da thread de áudio. A primeira observação aquece o monitor; três falhas em uma janela com pelo menos 100 callbacks ampliam o ciclo até 256 frames. Preferências e presets não são regravados. `FormantPitchAU.renderMetrics` inclui pull, WSOLA, gate e telemetria; a cópia da ponte continua sendo relatada separadamente.

Antes de alterar ciclos, valide o PCM por bits em diferentes partições, taxas, presets e transições. Use `./test.sh`, build universal e harnesses ASan/UBSan/TSan. `tools/benchmark-installed-loopback.c` é um instrumento sintético de agendamento do transporte virtual: exige Mixer encerrado, não usa microfone físico nem saída física e não comprova a latência da voz ou de chamadas. A medição de fala na interface é separada. O driver continua com a margem de segurança de 256 frames.

A negociação `fsiz` via AUHAL em Global/0 encaminha a propriedade ao AudioDevice. Leia o valor concedido e confirme a execução por `Δframes/Δcallbacks` e pelas rajadas do ring: o setter pode aceitar um pedido limitado pelo sistema. O HAL admite buffers distintos por cliente, portanto um inspector independente com 512 frames não refuta callbacks de 64 frames do Mixer. Referências primárias: [AUHAL na Apple](https://developer.apple.com/library/archive/documentation/MusicAudio/Conceptual/CoreAudioOverview/ARoadmaptoCommonTasks/ARoadmaptoCommonTasks.html) e [implementação do Chromium](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/media/audio/mac/audio_manager_mac.cc).

Compile o benchmark com `clang -std=c11 -Wall -Wextra -Werror tools/benchmark-installed-loopback.c -framework CoreAudio -framework CoreFoundation -lm -o /tmp/mixer-loopback-benchmark`. `--inspect` apenas consulta os dois UIDs e seus clientes, sem iniciar IO ou alterar buffers, e funciona com o app aberto. O modo de áudio `--seconds 5` avalia um leitor, dois leitores e reinício; espera um segundo contínuo de PCM exato antes de cada janela e relata zeros/falhas de aquecimento separadamente. `--buffer-frames 64` faz um experimento explícito: exige dispositivos ociosos em todos os processos, salva os valores, confere a concessão e restaura depois de parar os clientes. Atividade ou estado desconhecido bloqueiam a escrita. Um pedido de 64 nesse cliente não configura o quantum de outros aplicativos.
