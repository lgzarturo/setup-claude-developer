# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Nuevos stacks tecnológicos en desarrollo.
- Mejoras en la documentación.

## [1.0.0] - 2026-04-19

### Added

- **Script interactivo bash** (`setup-claude-project.sh`) para Linux/macOS.
- **Script interactivo PowerShell** (`setup-claude-project.ps1`) para Windows 11.
- **Makefile** con comandos para instalar, ejecutar, actualizar y gestionar el script.
- **Skills universales**: `testing-tdd`, `security`, `code-review`, `testing-coverage`.
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

[Unreleased]: https://github.com/lgzarturo/setup-claude-developer/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/lgzarturo/setup-claude-developer/releases/tag/v1.0.0
