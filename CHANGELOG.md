# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Nuevos stacks tecnológicos en desarrollo.
- Mejoras en la documentación.

## [1.0.2] - 2026-04-19

### Changed

- Versión actualizada de 1.0.1 a 1.0.2.
- Mejor soporte con los agentes de OpenCode.
- Ya no se remplaza el contenido de CLAUDE.md

## [1.0.1] - 2026-04-19

### Added

- **Documentación de skills** (`docs/01-skills.md`) con checklist de 42 skills:
  - 9 skills implementados (4 universales + 5 por stack)
  - 18 skills oficiales de Spring Boot (integración externa)
  - 15 skills recomendados para desarrollo futuro
- **Documentación de agents** (`docs/02-agents.md`) con 12 agents:
  - 1 agent implementado (`code-reviewer`)
  - 11 agents recomendados por fase de desarrollo
- **Documentación de commands** (`docs/03-commands.md`) con 17 commands:
  - 1 command implementado (`/run-all-tests`)
  - 16 commands recomendados por fase de desarrollo
- **Documentación de recomendaciones** (`docs/04-recomendaciones.md`) con 5
  herramientas para optimizar tokens y performance:
  - RTK: compresión de bash (60-90% ahorro)
  - code-review-graph: grafo de conocimiento (6.8x-49x menos tokens)
  - token-savior: navegación + memoria (97% menos tokens)
  - caveman: respuestas concisas (~75% menos tokens)
  - CLAUDE.md optimizado: reglas anti-verbosidad (~63% menos tokens)
- **Índice de documentación** (`docs/README.md`) con flujo completo de
  desarrollo.

### Documentation

- README.md actualizado con sección "Recomendaciones para Desarrolladores".
- CODE_OF_CONDUCT.md actualizado con referencias correctas a MIT License.

### Changed

- `.editorconfig`: línea máxima de 80 caracteres para archivos Markdown.
- `.prettierrc`: `proseWrap: "always"` para formateo automático de Markdown.
- `.vscode/settings.json`: rulers en [80, 100] y markdownlint con 80 caracteres.

## [1.0.0] - 2026-04-19

### Added

- **Script interactivo bash** (`setup-claude-project.sh`) para Linux/macOS.
- **Script interactivo PowerShell** (`setup-claude-project.ps1`) para
  Windows 11.
- **Makefile** con comandos para instalar, ejecutar, actualizar y gestionar el
  script.
- **Skills universales**: `testing-tdd`, `security`, `code-review`,
  `testing-coverage`.
- **Skills por stack**:
  - `spring-boot-kotlin-rest` - Spring Boot 3.4+ con Kotlin
  - `python-django-uv` - Django con UV package manager
  - `python-fastapi` - FastAPI con Pydantic v2
  - `nextjs-typescript` - Next.js 15+ con App Router
  - `astro` - Astro 5+ con Islands Architecture
- **Integración con 18 skills oficiales de Spring Boot** vía git clone opcional.
- **Agente code-reviewer** para revisiones de código.
- **Comando run-all-tests** para ejecución de tests.
- **Archivo CLAUDE.md** con reglas base para Claude Code.
- **Instalación global** vía Makefile en `~/.local/bin`.

### Documentation

- README.md completo con inicio rápido y ejemplos de uso.
- CONTRIBUTING.md con guía de contribución y convenciones de código.
- CODE_OF_CONDUCT.md con normas de comunidad.
- SECURITY.md con política de seguridad.
- AUTHORS con información del autor y contribuyentes.
- LICENSE bajo MIT.
- Templates de GitHub: bug report, feature request, pull request.

### Tooling

- `.editorconfig` configuración universal de editor.
- `.prettierrc` configuración de Prettier.
- `.vscode/settings.json` y `.vscode/extensions.json` para VS Code.

[Unreleased]:
  https://github.com/lgzarturo/setup-claude-developer/compare/v1.0.2...HEAD
[1.0.2]:
  https://github.com/lgzarturo/setup-claude-developer/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/lgzarturo/setup-claude-developer/releases/tag/v1.0.1
[1.0.0]: https://github.com/lgzarturo/setup-claude-developer/releases/tag/v1.0.0
