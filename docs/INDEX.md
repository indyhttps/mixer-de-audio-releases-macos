# Mapa do projeto

**Versão de manutenção:** 5.12.4 · **Driver:** 1.5 · **Mínimo:** macOS 15

Este mapa reúne os caminhos para usar, desenvolver, verificar e distribuir o Mixer de Áudio. A 5.12.4 corrige o cancelamento da desinstalação e a expiração de desafios no envio de suporte, preservando o visual aprovado pela usuária, os controles e o processamento de voz.

## Por onde começar

| Quero… | Abrir |
|---|---|
| Instalar ou usar o aplicativo | [Manual de uso](../README.md) |
| Configurar microfone e chamada | [Configurar a chamada](../README.md#configurar-a-chamada) |
| Ajustar gate, canal e monitor | [Gate, canal e monitor](../README.md#gate-canal-e-monitor) |
| Guardar presets e configuração | [Presets, backup e atraso](../README.md#presets-backup-e-atraso) |
| Resolver falta de som | [Roteiro de diagnóstico](../README.md#quando-falta-som) |
| Entender o código e compilar | [Guia de desenvolvimento](DEVELOPMENT.md) |
| Conferir cenários testados e pendentes | [Compatibilidade](COMPATIBILITY.md) |
| Ver o escopo da entrega atual | [Notas 5.12.4](releases/5.12.4.md) |
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
| `CLAUDE.md` e `REVISAO-CETICA.md` | Regras operacionais e registros de revisão no repositório privado |
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
| Conferir o plano de publicação | `./publicar.sh docs/releases/5.12.4.md --dry-run` |
| Publicar o mesmo fonte e os pacotes já validados | `./publicar.sh docs/releases/5.12.4.md` |
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
| [GitHub privado](https://github.com/indyhttps/MixerDeAudio-macOS) | Fonte, documentação técnica, testes, commit/tag e ZIP completo `Mixer-de-Audio-v5.12.4.zip` |
| [GitHub público](https://github.com/indyhttps/mixer-de-audio-releases-macos) | README de downloads, manuais e releases de `mixer-de-audio-macos.zip` com assinatura `.sig` |
| Sites | Hospedagem separada do relay de suporte, suas migrações e variáveis privadas |
| Sentry | Metadados das versões e eventos técnicos do app, conforme a preferência de telemetria |

A mesma tag, versão e commit devem corresponder aos manifestos e pacotes. O README e as notas públicas usam somente resultados já conferidos. Credenciais dos conectores ficam na configuração privada; não pertencem ao fonte distribuído.

## Documentação e histórico

| Documento | Para que consultar |
|---|---|
| [README](../README.md) | Instalação, uso, calibração, presets, diagnóstico e desinstalação |
| [DEVELOPMENT](DEVELOPMENT.md) | Arquitetura, build, testes, publicação, instalação e regras de mudança |
| [COMPATIBILITY](COMPATIBILITY.md) | Evidências de campo, cenários pendentes e roteiro de verificação |
| [CHANGELOG](CHANGELOG.md) | Histórico completo do projeto |
| [IMPROVEMENTS-5.11.0](IMPROVEMENTS-5.11.0.md) | Registro das melhorias daquela versão |
| [CLAUDE — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/CLAUDE.md) | Regras do projeto e cuidados operacionais |
| [REVISAO-CETICA — privado](https://github.com/indyhttps/MixerDeAudio-macOS/blob/main/REVISAO-CETICA.md) | Resultados, decisões e limites das revisões |

| Release | Assunto |
|---|---|
| [5.12.4](releases/5.12.4.md) | Desinstalação e expiração de desafios no suporte |
| [5.12.3](releases/5.12.3.md) | Limpeza e organização do projeto |
| [5.12.2](releases/5.12.2.md) | Menor espera nos buffers e verificações de áudio |
| [5.12.1](releases/5.12.1.md) | Apresentação do microfone e rodapé |
| [5.12.0](releases/5.12.0.md) | Microfone virtual único e driver 1.5 |
| [5.11.2](releases/5.11.2.md) | Instalação definitiva única |
| [5.11.1](releases/5.11.1.md) | Controles visíveis e janelas nativas |
| [5.11.0](releases/5.11.0.md) | Melhorias de configuração, diagnóstico e confiabilidade |
| [5.10.4](releases/5.10.4.md) | Distribuição e verificações da versão anterior |

Notas antigas preservam o contexto da versão em que foram escritas. As verificações da entrega atual ficam nas notas 5.12.4; confirmações humanas anteriores não são apresentadas como novos testes desta versão.
