# Mapa do projeto

**Versão atual:** 5.12.6 · **Driver:** 1.6 · **Mínimo:** macOS 15

Este mapa reúne os caminhos para usar, desenvolver, verificar e distribuir o Mixer de Áudio. A 5.12.6 corrige a validade temporal do áudio no driver, o estado do microfone, o diagnóstico e os fluxos de manutenção. Conserva o Dock opcional, a Central de Controle/Liquid Glass e os ajustes de voz. As [notas atuais](releases/5.12.6.md) registram testes, build universal e instalação da revisão visual final. O painel de 795 pt, com gate e Entrada no mesmo slider, foi conferido inteiro e sem cortes; os pacotes foram publicados e a CI passou, com downloads e assinatura Ed25519 conferidos.

## Por onde começar

| Quero… | Abrir |
|---|---|
| Instalar ou usar o aplicativo | [Manual de uso](../README.md) |
| Configurar microfone e chamada | [Configurar a chamada](../README.md#configurar-a-chamada) |
| Fixar ou retirar o aplicativo do Dock | [Usar o Dock](../README.md#usar-o-dock) |
| Ajustar gate, canal e monitor | [Gate, canal e monitor](../README.md#gate-canal-e-monitor) |
| Guardar presets e configuração | [Presets, backup e atraso](../README.md#presets-backup-e-atraso) |
| Resolver falta de som | [Roteiro de diagnóstico](../README.md#quando-falta-som) |
| Entender o código e compilar | [Guia de desenvolvimento](DEVELOPMENT.md) |
| Conferir cenários testados e pendentes | [Compatibilidade](COMPATIBILITY.md) |
| Ver o escopo da entrega atual | [Notas 5.12.6](releases/5.12.6.md) |
| Consultar decisões e versões anteriores | [Histórico](CHANGELOG.md) |

## Pastas e arquivos principais

Os caminhos de fonte e ferramentas abaixo pertencem ao [repositório privado](https://github.com/indyhttps/MixerDeAudio-macOS). O pacote público contém o aplicativo, o driver, o desinstalador e os manuais; não inclui código-fonte ou configuração privada de publicação.

| Caminho | Conteúdo e finalidade |
|---|---|
| `Sources/MixerDeAudio/` | Aplicativo, interface, captura, roteamento, instalação, atualização e diagnóstico |
| `Sources/MixerCore/` | Regras reutilizáveis e testáveis, buffers, configuração e verificações de atualização |
| `Vendor/MixerDsp/` | Motor WSOLA em C++, compartilhado com o projeto Windows |
| `Vendor/MixerDeAudioDriver-src/` | Fonte C e metadados do driver virtual |
| `Vendor/MixerDeAudioDriver.driver/` | Snapshot assinado do driver 1.5 para recuperação; builds novos compilam a fonte |
| `Vendor/instalar-driver.command` | Instalação independente do driver com validação e rollback |
| `Services/SupportRelay/` | Serviço separado que encaminha o relatório de suporte revisado |
| `Tests/` | Regressões Swift, harnesses do driver e testes da distribuição |
| `tools/` | Versão, compilação, assinatura, manifestos e instrumentos de diagnóstico |
| `Resources/` | Ícone original PNG e ícone ICNS usado no aplicativo |
| `docs/` | Este mapa, desenvolvimento, compatibilidade, histórico e notas de cada release |
| `.github/workflows/testes.yml` | CI de regressões, projeto Xcode, distribuição universal e fallback de toolchain |
| `Package.swift` | Alvos SwiftPM do app, MixerCore, DSP e testes |
| `project.yml` | Configuração do projeto opcional gerado pelo XcodeGen |
| `VERSION` | Versão autoritativa; `Info.plist` e `Version.xcconfig` recebem os valores por sincronização |
| `Info.plist` | Identidade, versão, mínimo macOS e metadados do aplicativo |
| `.gitignore` | Exclusões de caches, produtos gerados e projeto Xcode gerado |
| `AGENTS.md` e `REVISAO-CETICA.md` | Regras operacionais e registros de revisão no repositório privado |
| `.build/` | Produtos locais, ferramentas, artefatos de release e dados privados de manutenção; ver a distinção abaixo |

### Código do aplicativo

| Responsabilidade | Arquivos em `Sources/MixerDeAudio/` |
|---|---|
| Início e coordenação | `main.swift`, `AppDelegate.swift`, `MixerDeAudioController.swift`, `ControlWindow.swift` |
| Instalação e registro no macOS | `Bootstrap.swift`, `InstalledApplicationRegistration.swift` |
| Painel e componentes visuais | `ContentView.swift`, `CCComponents.swift`, `DesignTokens.swift` |
| Janelas auxiliares | `PreferencesView.swift`, `PresetsView.swift`, `GuideView.swift`, `DiagnosticsView.swift` |
| Captura e caminho de áudio | `CaptureUnit.swift`, `AudioGraph.swift`, `AudioDeviceMonitor.swift`, `FormantPitchAU.swift` |
| Preferências, preset e ações de configuração | `Settings.swift`, `Config.swift`, `ConfigurationUIActions.swift` |
| Diagnóstico, atualização e telemetria | `DiagnosticsService.swift`, `AutoUpdater.swift`, `Telemetria.swift` |

`FormantPitchAU.swift` conserva também o motor legado desconectado para A/B e reversão. O preset macOS vem de `Config.swift`; valores históricos de outro produto não devem substituir esse preset durante uma limpeza.

### Regras do MixerCore

| Responsabilidade | Arquivos em `Sources/MixerCore/` |
|---|---|
| Buffers, saúde e atraso | `AudioRingBuffer.swift`, `AudioReliability.swift`, `AudioLatencyMeasurement.swift` |
| Gate e proteção de monitor | `NoiseGate.swift`, `MonitorGuard.swift` |
| Estado de transmissão e demanda dos medidores | `MixerPresentationState.swift` |
| Presets e configuração portátil | `UserPreset.swift`, `ConfigurationArchive.swift` |
| Identidade e troca de bundles | `ApplicationIdentity.swift`, `VerifiedBundleReplacement.swift` |
| Atualização verificada | `UpdateGuards.swift`, `UpdatePipeline.swift`, `ReleaseSignatureVerifier.swift` |
| Privacidade e desafio de suporte | `PrivacyRedactor.swift`, `SupportChallenge.swift` |

### Serviço de suporte

| Caminho em `Services/SupportRelay/` | Finalidade |
|---|---|
| `worker/index.js` | Rotas de desafio e envio, validações e limites |
| `db/schema.ts`, `drizzle.config.ts`, `drizzle/` | Schema e migrações SQLite; migrações aplicadas são preservadas |
| `tests/relay.test.mjs` | Regressões com SQLite em memória e transporte simulado |
| `scripts/build.sh`, `scripts/validate-artifact.mjs` | Preparo e conferência do artefato ESM |
| `package.json`, `pnpm-lock.yaml`, `pnpm-workspace.yaml` | Comandos, dependências fixadas e configuração do pnpm |
| `.openai/hosting.json` | Identidade da hospedagem e vínculo do banco |
| `.gitignore` | Exclusão de dependências, produtos e configuração local privada |

O [manual do relay — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/Services/SupportRelay/README.md) está disponível no fonte privado. Publicar o aplicativo não republica automaticamente o serviço. Os segredos são configurados na hospedagem e não acompanham os pacotes.

## Comandos e ferramentas

Execute os comandos a partir da raiz do código-fonte. O [guia de desenvolvimento](DEVELOPMENT.md#compilar-e-testar) registra o ambiente, as opções e os limites de cada verificação.

| Quero… | Comando ou arquivo |
|---|---|
| Conferir metadados | `python3 tools/version.py check` |
| Atualizar os metadados após editar VERSION | `python3 tools/version.py sync` |
| Rodar regressões Swift | `./test.sh` |
| Rodar harnesses do driver e sanitizers | `bash Tests/Driver/test.sh` |
| Rodar testes de manifesto, instalação e publicação | `python3 -m unittest discover -s Tests/Release -p 'test_*.py'` |
| Compilar app e driver universais | `./build.sh` |
| Preparar e validar os dois ZIPs | `./release.sh` |
| Conferir o plano de publicação | `./publicar.sh docs/releases/5.12.6.md --dry-run` |
| Publicar o mesmo fonte e os pacotes já validados | `./publicar.sh docs/releases/5.12.6.md` |
| Remover a própria instalação | `Desinstalar Mixer de Áudio.command` ou a opção Desinstalar no app |

| Ferramentas em `tools/` | Responsabilidade |
|---|---|
| `toolchain.sh` | Seleção do compilador, backend SwiftPM e caminhos de caches |
| `build-driver.sh` | Build universal do driver a partir do C |
| `check-bundle.py` | Estrutura, identidade, arquitetura, mínimo macOS e selos do bundle |
| `release_manifest.py`, `publish_release.py` | Vínculo de fonte/commit/binários/ZIPs e publicação retomável |
| `sign-release.swift` | Assinatura Ed25519 do ZIP público |
| `notarize.sh`, `MixerDeAudio.entitlements` | Fluxo de assinatura Apple/notarização quando as credenciais reais estiverem disponíveis |
| `MixerDsp.modulemap` | Integração do módulo DSP no projeto Xcode |
| `check-installed-routing.swift` | Leitura da topologia real do driver instalado |
| `test-installed-loopback.c`, `benchmark-installed-loopback.c` | Testes sintéticos do transporte; requisitos e modos estão no guia de desenvolvimento |

Os testes sintéticos de áudio exigem as condições documentadas e não substituem uma chamada real nem a aprovação auditiva da usuária.

## Produtos locais e dados privados

`.build/` é ignorado pelo Git, mas reúne categorias diferentes. Uma limpeza deve distinguir produtos que podem ser recompostos dos dados necessários para publicação e recuperação.

| Categoria | Tratamento |
|---|---|
| Produtos SwiftPM, intermediários, caches e logs temporários | Podem ser recompostos pelos scripts a partir da mesma fonte |
| `.build/distribution/` | Saída local do build do aplicativo; o app em uso tem o caminho canônico `/Applications/Mixer de Áudio.app` |
| `.build/releases/` | ZIPs, assinaturas e manifestos validados; preservar as releases anteriores |
| `.build/tooling/` | Ferramentas locais e helpers; preservar executáveis ainda usados pela autenticação/publicação |
| `.build/private/` | Credenciais, configuração privada e registros de manutenção; preservar acesso restrito e manter fora dos pacotes |
| `.build/private/install-backup/` | Backups de instalação e preferências para recuperação; preservar durante atualização e limpeza |
| `Services/SupportRelay/node_modules/`, `dist/` | Dependências e produtos gerados do relay; reconstruíveis sem alterar fonte ou migrações |

Nenhum segredo, chave privada, relatório pessoal ou backup privado deve ser copiado para os repositórios públicos ou ZIPs de distribuição.

## Distribuição e conectores

| Destino | O que fica nele |
|---|---|
| [GitHub privado](https://github.com/indyhttps/MixerDeAudio-macOS) | Fonte, documentação técnica, testes, commit/tag e ZIP completo `Mixer-de-Audio-v5.12.6.zip` |
| [GitHub público](https://github.com/indyhttps/mixer-de-audio-releases-macos) | README de downloads, manuais e releases de `mixer-de-audio-macos.zip` com assinatura `.sig` |
| Sites | Relay versão 4 publicado separadamente; `/health` e `/ready` conferidos com HTTP 200, `ready: true`, sem envio de relatório |
| [Notion](https://app.notion.com/p/39fb69db4e188113a17ce909f6718720) | Acompanhamento do estado do projeto, evidências da entrega e pendências |
| Sentry | Release `mixer-de-audio-macos@5.12.6` sincronizada e relida, vinculada ao fonte da entrega e a um commit; leitura de issues indisponível com a credencial restrita |

A entrega 5.12.6 tem 113 testes Swift, 60 testes Python e 10 testes do relay aprovados, além dos harnesses do driver e benchmark arm64. O build universal e a instalação via SelfInstaller do desenho final foram confirmados. O painel de 795 pt apareceu inteiro, com Entrada e gate no mesmo slider, seletor integrado, tiles centralizados e rodapé de ícones com ajuda/AX. O teste do gate 6 → 7 refletiu −36 → −35 dB e terminou restaurado em +6; os nove ajustes e o Dock foram preservados. A entrada estava em silêncio (−90 dB), sem comprovar movimento do medidor com voz ou uso real do VoiceOver. O diagnóstico anterior registrou zero falhas e zero reparos. Os dois pacotes foram publicados, com downloads e `releases/latest` conferidos. O ZIP público e sua assinatura foram baixados sem credenciais; hashes, bytes e Ed25519 passaram. O app e o driver instalados coincidem com o ZIP público baixado e com o ZIP privado validado. Os quatro jobs da [CI 38599070069](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/38599070069) passaram no fonte `9fa15f75e2ca3d293d2e8edfdddcb835256dbfc1`. ZIPs, manifestos e tag do fonte conservam esse commit; a tag pública conserva `d904eba6a386f5347cb159d61f52609ac6edefc9`, e o registro editorial final fica em `main`. O relay Sites v4 foi publicado de forma independente.

A tag, a versão e o commit da entrega devem corresponder aos manifestos e pacotes. A 5.12.5 usa notas e artefatos próprios. Os testes, o build universal, a instalação limpa e quatro aberturas reais estão registrados. Os dois pacotes foram publicados e seus downloads e `releases/latest` conferidos; a assinatura Ed25519 passou. A CI aprovou os quatro jobs ([run 38570203789](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/38570203789)). Os manifestos, os ZIPs e a tag `v5.12.5` do fonte permanecem no commit `36c4988f221877e0cc2c52fa8decb51ebcbfbb22`; os manuais atuais e a manutenção posterior da CI registram o acompanhamento em commits separados, sem alterar esses artefatos. O seletor manual de runner do commit `f1382c8427cd7546c5108ec4d8cf283d76bd4589` permite `macos-26-intel` diante da indisponibilidade de ARM, mantendo `macos-latest` para pushes e pull requests; a execução manual Intel [38578342396](https://github.com/indyhttps/MixerDeAudio-macOS/actions/runs/38578342396) concluiu com quatro jobs aprovados, incluindo testes Swift, sanitizers e build universal da distribuição. Na 5.12.4, os ZIPs e a tag de fonte conservam o snapshot do commit `f011bf8186f3a3cf748ea0a488e723b26df0b6c0`. A documentação em `main` e os manuais públicos foram atualizados após publicar para registrar os resultados finais daquela versão; esse registro não refaz os pacotes. Uma mudança do aplicativo ou dos pacotes publicados exige uma nova versão. O README e as notas públicas usam somente resultados já conferidos. Credenciais dos conectores ficam na configuração privada; não pertencem ao fonte distribuído.

## Documentação e histórico

| Documento | Para que consultar |
|---|---|
| [README](../README.md) | Instalação, uso, calibração, presets, diagnóstico e desinstalação |
| [DEVELOPMENT](DEVELOPMENT.md) | Arquitetura, build, testes, publicação, instalação e regras de mudança |
| [COMPATIBILITY](COMPATIBILITY.md) | Evidências de campo, cenários pendentes e roteiro de verificação |
| [CHANGELOG](CHANGELOG.md) | Histórico completo do projeto |
| [IMPROVEMENTS-5.11.0](IMPROVEMENTS-5.11.0.md) | Registro das melhorias daquela versão |
| [AGENTS — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/AGENTS.md) | Regras do projeto e cuidados operacionais |
| [REVISAO-CETICA — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md) | Resultados, decisões e limites das revisões |

| Release | Assunto |
|---|---|
| [5.12.6](releases/5.12.6.md) | Confiabilidade do driver, interface e manutenção; entrega publicada |
| [5.12.5](releases/5.12.5.md) | Dock opcional e instalação sem fixação automática |
| [5.12.4](releases/5.12.4.md) | Desinstalação e expiração de desafios no suporte |
| [5.12.3](releases/5.12.3.md) | Limpeza e organização do projeto |
| [5.12.2](releases/5.12.2.md) | Menor espera nos buffers e verificações de áudio |
| [5.12.1](releases/5.12.1.md) | Apresentação do microfone e rodapé |
| [5.12.0](releases/5.12.0.md) | Microfone virtual único e driver 1.5 |
| [5.11.2](releases/5.11.2.md) | Instalação definitiva única |
| [5.11.1](releases/5.11.1.md) | Controles visíveis e janelas nativas |
| [5.11.0](releases/5.11.0.md) | Melhorias de configuração, diagnóstico e confiabilidade |
| [5.10.4](releases/5.10.4.md) | Distribuição e verificações da versão anterior |

Notas antigas preservam o contexto da versão em que foram escritas. As verificações da entrega atual ficam nas notas 5.12.6; confirmações humanas anteriores não são apresentadas como novos testes desta versão.
