# Commands de Desarrollo

> **Versión:** 1.0.0  
> **Última actualización:** 2026-04-19

Este documento lista todos los commands (comandos slash) disponibles en el
proyecto, su propósito y recomendaciones para nuevos commands basados en el
flujo de desarrollo y planeación.

---

## 📋 Índice

1. [Commands Disponibles](#commands-disponibles) ✅
2. [Commands Recomendados para Desarrollar](#commands-recomendados-para-desarrollar)
   📋
3. [Matriz de Commands por Fase](#matriz-de-commands-por-fase)
4. [Especificación Técnica](#especificación-técnica)

---

## Commands Disponibles

> **Estado:** Implementados ✅  
> **Total:** 14 commands

### 1. `run-all-tests`

**Descripción:** Ejecuta todos los tests del proyecto

**Contenido:**

```markdown
---
description: Ejecuta todos los tests del proyecto (usa skill testing-tdd)
---

# Detecta el stack y ejecuta tests completos con coverage
# Usa el skill @testing-tdd si es necesario
```

**Funcionalidad:**

- Detecta automáticamente el stack del proyecto
- Ejecuta tests unitarios, integración y E2E
- Genera reporte de cobertura
- Usa el skill `@testing-tdd` para determinar comandos específicos por stack

**Comandos por stack:**

| Stack                | Comando típico                                  |
| -------------------- | ----------------------------------------------- |
| Spring Boot + Kotlin | `./gradlew test` + `./gradlew jacocoTestReport` |
| Python + Django      | `pytest --cov=.`                                |
| Python + FastAPI     | `pytest --cov=app`                              |
| Next.js + TypeScript | `npm run test` + `npm run test:e2e`             |
| Astro                | `npm run test`                                  |

**Uso:**

```
/run-all-tests
```

**Salida esperada:**

- Resumen de tests ejecutados (pass/fail)
- Porcentaje de cobertura
- Reporte de tests fallidos (si aplica)
- Recomendaciones para mejorar cobertura

---

### 2. `conventional-commit`

**Descripción:** Analiza git staging y genera mensaje de commit siguiendo Conventional Commits

**Funcionalidad:**

- Analiza `git diff --staged` y `git status`
- Detecta tipo automáticamente: `feat`, `fix`, `chore`, `docs`, `refactor`
- Incluye `BREAKING CHANGE:` cuando aplica
- Muestra el mensaje y pide confirmación antes de ejecutar `git commit`

**Uso:** `/conventional-commit`

---

### 3. `update-changelog`

**Descripción:** Actualiza CHANGELOG.md desde commits recientes siguiendo Keep a Changelog

**Funcionalidad:**

- Lee commits desde el último tag
- Agrupa por tipo: Added, Changed, Fixed, Removed
- Mantiene sección "Unreleased" primero
- Sigue formato [keepachangelog.com](https://keepachangelog.com)

**Uso:** `/update-changelog`

---

### 4. `bump-version`

**Descripción:** Detecta bump semántico y actualiza versión en el archivo del stack

**Funcionalidad:**

- Detecta `package.json`, `pyproject.toml`, `build.gradle.kts` / `pom.xml`
- Infiere bump desde commits: `feat` = minor, `fix` = patch, `BREAKING CHANGE` = major
- Crea commit `chore: bump version to vX.Y.Z` y tag anotado
- Siempre pide confirmación antes de ejecutar git commands

**Uso:** `/bump-version`

---

### 5. `up-version-patch`

**Descripción:** Shortcut para bump patch (1.2.3 → 1.2.4)

**Uso:** `/up-version-patch`

---

### 6. `up-version-minor`

**Descripción:** Shortcut para bump minor (1.2.3 → 1.3.0)

**Uso:** `/up-version-minor`

---

### 7. `up-version-major`

**Descripción:** Shortcut para bump major con breaking changes (1.2.3 → 2.0.0)

**Uso:** `/up-version-major`

---

### 8. `create-pr`

**Descripción:** Crea Pull Request en GitHub con título, descripción y labels automáticos

**Funcionalidad:**

- Analiza `git diff main...HEAD`
- Genera título con Conventional Commits, descripción completa y labels
- Usa `gh pr create`; siempre pide confirmación

**Uso:** `/create-pr`

---

### 9. `lint-all`

**Descripción:** Linting completo según el stack detectado

| Stack | Herramienta |
|---|---|
| Spring Boot + Kotlin | `./gradlew ktlintCheck` o `detekt` |
| Python + UV | `uv run ruff check . --fix` |
| Next.js / TypeScript / Astro | `npm run lint` o `eslint .` |

**Uso:** `/lint-all`

---

### 10. `format-all`

**Descripción:** Formatea todo el código según el stack

| Stack | Herramienta |
|---|---|
| Kotlin | `./gradlew ktlintFormat` |
| Python | `uv run ruff format . && uv run ruff check --fix` |
| Next.js / TypeScript / Astro | `npm run format` |

**Uso:** `/format-all`

---

### 11. `deploy-preview`

**Descripción:** Crea deployment de preview (Vercel, Netlify, Railway, Fly.io)

**Funcionalidad:**

- Detecta plataforma según stack
- Ejecuta comando de preview y retorna el enlace
- Si no está configurado, da los pasos de setup

**Uso:** `/deploy-preview`

---

### 12. `release`

**Descripción:** Flujo completo de release en un solo comando

**Secuencia con confirmación en cada paso:**

1. `/conventional-commit`
2. `/update-changelog`
3. `/bump-version`
4. `git push && git push --tags`
5. `/create-pr` (opcional)

**Uso:** `/release`

---

### 13. `update-claude`

**Descripción:** Recrea CLAUDE.md con las reglas más optimizadas y token-eficientes

**Funcionalidad:**

- Sobrescribe CLAUDE.md con la versión actualizada
- Muestra diff si ya existía y pide confirmación
- Incluye regla adicional de precisión en uso de tools

**Uso:** `/update-claude`

---

## Commands Recomendados para Desarrollar

> **Prioridad:** Alta 🔴 | Media 🟡 | Baja 🟢  
> **Estado:** Pendiente ⏳

### Fase 1: Planeación y Setup 🔴

#### `/setup-project` ⏳

**Prioridad:** Alta

**Descripción:** Configura un proyecto nuevo desde cero

**Contenido propuesto:**

```markdown
---
description: Configura un proyecto nuevo con estructura base y herramientas
---

# Crea la estructura inicial del proyecto
# Inicializa repositorio git
# Configura pre-commit hooks
# Crea archivos base (README, LICENSE, .gitignore)
# Configura el stack seleccionado
```

**Funcionalidad:**

- Crea estructura de carpetas estándar
- Inicializa git
- Configura hooks de pre-commit
- Genera archivos base del proyecto
- Instala dependencias iniciales

**Interacción:**

1. "¿Qué stack vas a usar?"
2. "¿Nombre del proyecto?"
3. "¿Incluir configuración de Docker?"
4. "¿Incluir CI/CD básico?"

**Ejemplo de uso:**

```
/setup-project
```

---

#### `/generate-adr` ⏳

**Prioridad:** Media

**Descripción:** Genera un Architecture Decision Record

**Contenido propuesto:**

```markdown
---
description: Genera un Architecture Decision Record (ADR)
---

# Crea un ADR siguiendo el formato estándar
# Contexto, Decisión, Consecuencias
# Usa el skill @architecture-design
```

**Funcionalidad:**

- Crea archivo ADR en `docs/adr/`
- Numeración automática (e.g., `0001-use-postgresql.md`)
- Formato estándar: Título, Contexto, Decisión, Consecuencias
- Fecha automática

**Ejemplo de uso:**

```
/generate-adr "Usar PostgreSQL como base de datos principal"
```

**Salida:** Archivo `docs/adr/0001-use-postgresql.md`

---

### Fase 2: Desarrollo 🟡

#### `/conventional-commit` ✅

**Prioridad:** Alta

**Descripción:** Genera un mensaje de commit convencional

**Contenido propuesto:**

```markdown
---
description: Genera un mensaje de commit siguiendo Conventional Commits
---

# Analiza los cambios en staging
# Sugiere tipo de commit (feat, fix, docs, etc.)
# Genera mensaje descriptivo
# Opcionalmente incluye breaking changes
```

**Funcionalidad:**

- Analiza `git diff --staged`
- Detecta tipo de cambio automáticamente
- Genera mensaje siguiendo Conventional Commits
- Sugiere scope si es detectable

**Ejemplo de uso:**

```
/commit
```

**Salida sugerida:**

```
feat(auth): implement JWT authentication

- Add JWT token generation
- Add middleware for token validation
- Update User model with token field
```

---

#### `/create-pr` ✅

**Prioridad:** Alta

**Descripción:** Crea un Pull Request con descripción automática

**Contenido propuesto:**

```markdown
---
description: Crea un Pull Request con descripción generada automáticamente
---

# Genera título del PR basado en commits
# Crea descripción con checklist
# Incluye cambios principales
# Menciona issues relacionados
```

**Funcionalidad:**

- Genera título desde commits
- Describe cambios principales
- Lista archivos modificados
- Checklist de verificación
- Template de PR

**Ejemplo de uso:**

```
/create-pr
```

---

#### `/lint-all` ✅ · `/format-all` ✅

**Prioridad:** Media

**Descripción:** Corrige automáticamente errores de linting

**Contenido propuesto:**

```markdown
---
description: Ejecuta linter y corrige errores automáticamente
---

# Detecta el stack
# Ejecuta linter con --fix
# Reporta errores que no se pudieron corregir automáticamente
```

**Comandos por stack:** | Stack | Comando | |-------|---------| | Spring Boot |
`./gradlew spotlessApply` | | Python | `ruff check --fix .` + `black .` | |
Next.js | `eslint --fix .` + `prettier --write .` |

---

#### `/update-deps` ⏳

**Prioridad:** Media

**Descripción:** Actualiza dependencias y verifica compatibilidad

**Contenido propuesto:**

```markdown
---
description: Actualiza dependencias del proyecto
---

# Verifica dependencias desactualizadas
# Actualiza a versiones compatibles
# Ejecuta tests para verificar breaking changes
# Genera reporte de actualizaciones
```

---

### Fase 3: Testing y Calidad 🟡

#### `/test-coverage` ⏳

**Prioridad:** Media

**Descripción:** Genera y muestra reporte de cobertura detallado

**Contenido propuesto:**

```markdown
---
description: Genera reporte detallado de cobertura de tests
---

# Ejecuta tests con cobertura
# Genera reporte HTML
# Identifica archivos sin cobertura
# Sugiere tests faltantes
# Usa el skill @testing-coverage
```

**Diferencias con `/run-all-tests`:**

- `/run-all-tests`: Ejecuta tests y muestra resultado básico
- `/test-coverage`: Enfocado en análisis de cobertura y sugerencias

---

#### `/security-scan` ⏳

**Prioridad:** Alta

**Descripción:** Escanea el proyecto por vulnerabilidades

**Contenido propuesto:**

```markdown
---
description: Escanea el proyecto por vulnerabilidades de seguridad
---

# Ejecuta scanner de dependencias (npm audit, pip-audit, etc.)
# Revisa código por patrones inseguros
# Verifica configuraciones de seguridad
# Reporta vulnerabilidades encontradas
# Usa el skill @security
```

**Comandos por stack:** | Stack | Herramienta | |-------|-------------| |
Node.js | `npm audit` | | Python | `pip-audit`, `bandit` | | Java |
`OWASP Dependency Check` |

---

#### `/generate-tests` ⏳

**Prioridad:** Media

**Descripción:** Genera tests para código existente

**Contenido propuesto:**

```markdown
---
description: Genera tests automáticamente para código existente
---

# Analiza el código fuente
# Genera tests unitarios
# Identifica casos edge
# Usa el skill @testing-tdd
```

**Ejemplo de uso:**

```
/generate-tests src/services/userService.ts
```

---

### Fase 4: DevOps y Deploy 🟢

#### `/build-docker` ⏳

**Prioridad:** Media

**Descripción:** Construye imagen Docker del proyecto

**Contenido propuesto:**

```markdown
---
description: Construye imagen Docker optimizada
---

# Verifica Dockerfile existe
# Ejecuta build multi-stage
# Reporta tamaño de imagen
# Sugiere optimizaciones
```

---

#### `/deploy-preview` ✅

**Prioridad:** Baja

**Descripción:** Despliega a ambiente de preview/staging

**Contenido propuesto:**

```markdown
---
description: Despliega la aplicación a staging
---

# Verifica tests pasan
# Construye imagen
# Despliega a staging
# Verifica health checks
```

---

#### `/logs` ⏳

**Prioridad:** Baja

**Descripción:** Muestra logs de la aplicación

**Contenido propuesto:**

```markdown
---
description: Muestra logs de la aplicación
---

# Detecta si es local o contenedor
# Muestra logs con formato
# Permite filtrar por nivel (ERROR, WARN, INFO)
```

---

### Fase 5: Documentación 🟢

#### `/docs-serve` ⏳

**Prioridad:** Baja

**Descripción:** Inicia servidor de documentación local

**Contenido propuesto:**

```markdown
---
description: Inicia servidor local para documentación
---

# Detecta herramienta de docs (MkDocs, VitePress, etc.)
# Inicia servidor de desarrollo
# Abre navegador
```

---

#### `/update-changelog` ✅ · `/release` ✅ · `/bump-version` ✅ · `/up-version-patch` ✅ · `/up-version-minor` ✅ · `/up-version-major` ✅ · `/update-claude` ✅

**Prioridad:** Media

**Descripción:** Genera o actualiza el CHANGELOG · flujo completo de release · bump de versión semántica

**Contenido propuesto:**

```markdown
---
description: Genera CHANGELOG desde commits
---

# Analiza commits desde último tag
# Genera entrada para CHANGELOG
# Formato Keep a Changelog
# Clasifica: Added, Changed, Fixed, Removed
```

**Ejemplo de uso:**

```
/changelog
```

---

## Matriz de Commands por Fase

```
┌──────────────────────────────────────────────────────────────────────┐
│                      COMMANDS POR FASE                               │
├──────────────┬───────────────────────────────────────────────────────┤
│ FASE         │ COMMANDS DISPONIBLES / RECOMENDADOS                   │
├──────────────┼───────────────────────────────────────────────────────┤
│ 1. SETUP     │ ✅ /setup-project ⏳                                   │
│              │ ✅ /generate-adr ⏳                                    │
├──────────────┼───────────────────────────────────────────────────────┤
│ 2. CODING    │ ✅ /commit ⏳                                          │
│              │ ✅ /create-pr ⏳                                       │
│              │ ✅ /fix-linting ⏳                                     │
│              │ ✅ /update-deps ⏳                                     │
├──────────────┼───────────────────────────────────────────────────────┤
│ 3. TESTING   │ ✅ /run-all-tests (ACTUAL)                            │
│              │ ✅ /test-coverage ⏳                                   │
│              │ ✅ /security-scan ⏳                                   │
│              │ ✅ /generate-tests ⏳                                  │
├──────────────┼───────────────────────────────────────────────────────┤
│ 4. DEVOPS    │ ✅ /build-docker ⏳                                    │
│              │ ✅ /deploy-staging ⏳                                  │
│              │ ✅ /logs ⏳                                            │
├──────────────┼───────────────────────────────────────────────────────┤
│ 5. DOCS      │ ✅ /docs-serve ⏳                                      │
│              │ ✅ /changelog ⏳                                       │
└──────────────┴───────────────────────────────────────────────────────┘
```

---

## Especificación Técnica

### Formato de Command

Los commands deben seguir este formato:

```markdown
---
description: [Descripción breve del propósito]
---

# Comentarios descriptivos (no se ejecutan)
# Instrucciones para Claude/OpenCode
# Pueden incluir referencias a skills con @skill-name
```

### Convenciones de Nomenclatura

- Usar **kebab-case**: `/command-name`
- Verbos de acción: `/run`, `/generate`, `/create`, `/fix`
- Nombres descriptivos pero concisos
- Evitar abreviaturas ambiguas

### Categorías de Commands

| Prefijo       | Uso                      | Ejemplos                            |
| ------------- | ------------------------ | ----------------------------------- |
| `/run-*`      | Ejecutar procesos        | `/run-all-tests`, `/run-migrations` |
| `/generate-*` | Crear contenido          | `/generate-tests`, `/generate-adr`  |
| `/create-*`   | Crear recursos           | `/create-pr`, `/create-branch`      |
| `/fix-*`      | Correcciones automáticas | `/fix-linting`, `/fix-security`     |
| `/update-*`   | Actualizaciones          | `/update-deps`, `/update-docs`      |
| `/build-*`    | Construcción             | `/build-docker`, `/build-docs`      |
| `/deploy-*`   | Despliegue               | `/deploy-staging`, `/deploy-prod`   |
| `/*`          | Acciones generales       | `/commit`, `/changelog`, `/logs`    |

### Interactividad

Los commands pueden ser:

1. **Directos**: Ejecutan inmediatamente

   ```
   /run-all-tests
   ```

2. **Interactivos**: Hacen preguntas antes de ejecutar

   ```
   /setup-project
   > ¿Qué stack vas a usar?
   > ¿Nombre del proyecto?
   ```

3. **Con argumentos**: Aceptan parámetros
   ```
   /generate-tests src/services/userService.ts
   ```

---

## Checklist de Implementación

### Commands Actuales (14 commands)

- [x] `/run-all-tests` — tests completos con cobertura, auto-detecta stack
- [x] `/conventional-commit` — Conventional Commits desde git staging con confirmación
- [x] `/update-changelog` — Keep a Changelog desde commits del último tag
- [x] `/bump-version` — SemVer automático o manual, crea commit + tag
- [x] `/up-version-patch` — shortcut bump patch
- [x] `/up-version-minor` — shortcut bump minor
- [x] `/up-version-major` — shortcut bump major
- [x] `/create-pr` — PR en GitHub con título, descripción y labels automáticos
- [x] `/lint-all` — linting completo auto-detecta stack
- [x] `/format-all` — formato completo auto-detecta stack
- [x] `/deploy-preview` — preview en Vercel / Netlify / Railway / Fly.io
- [x] `/release` — flujo completo: commit → changelog → bump → push → PR
- [x] `/update-claude` — recrea CLAUDE.md con versión más optimizada

### Commands Recomendados (pendientes)

**Fase 1: Setup**

- [ ] `/setup-project` 🔴
- [ ] `/generate-adr` 🟡

**Fase 2: Desarrollo**

- [ ] `/update-deps` 🟡

**Fase 3: Testing**

- [ ] `/test-coverage` 🟡
- [ ] `/security-scan` 🔴
- [ ] `/generate-tests` 🟡

**Fase 4: DevOps**

- [ ] `/build-docker` 🟡
- [ ] `/logs` 🟢

**Fase 5: Documentación**

- [ ] `/docs-serve` 🟢

---

## Flujo de Trabajo Recomendado con Commands

```
┌─────────────────────────────────────────────────────────────────┐
│              FLUJO DE TRABAJO CON COMMANDS                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INICIO DE PROYECTO                                             │
│  └── /setup-project                                             │
│      └── Crea estructura base + README + .gitignore            │
│                                                                 │
│  DESARROLLO DE FEATURE                                          │
│  ├── /generate-tests src/feature.ts                             │
│  │   └── Genera tests unitarios                                │
│  ├── [Implementas la feature]                                   │
│  ├── /run-all-tests                                             │
│  │   └── Verifica que todo pasa                                │
│  ├── /test-coverage                                             │
│  │   └── Revisa cobertura                                      │
│  ├── /fix-linting                                               │
│  │   └── Corrige estilos                                       │
│  ├── /security-scan                                             │
│  │   └── Verifica vulnerabilidades                             │
│  └── /commit                                                    │
│      └── Genera mensaje convencional                           │
│                                                                 │
│  PULL REQUEST                                                   │
│  └── /create-pr                                                 │
│      └── Crea PR con descripción automática                    │
│                                                                 │
│  PRE-DEPLOY                                                     │
│  ├── /update-deps                                               │
│  │   └── Actualiza dependencias                                │
│  ├── /build-docker                                              │
│  │   └── Construye imagen                                      │
│  └── /deploy-staging                                            │
│      └── Despliega a staging                                   │
│                                                                 │
│  RELEASE                                                        │
│  └── /changelog                                                 │
│      └── Actualiza CHANGELOG.md                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Notas de Implementación

### 1. Commands vs Skills

- **Commands (`/`)**: Acciones que ejecutan procesos o scripts
- **Skills (`@`)**: Contexto y conocimiento para tareas específicas
- **Agents (`/agent-name`)**: Subagentes especializados

### 2. Commands vs Agents

| Aspecto     | Commands           | Agents                        |
| ----------- | ------------------ | ----------------------------- |
| Duración    | Acción única       | Sesión extendida              |
| Interacción | Limitada           | Conversacional                |
| Uso típico  | Tareas repetitivas | Tareas complejas              |
| Ejemplo     | `/run-all-tests`   | `/implementer "crea feature"` |

### 3. Stack Detection

Los commands deben detectar automáticamente el stack cuando sea posible:

- Buscar archivos característicos (`pom.xml`, `package.json`, `pyproject.toml`)
- Leer configuraciones existentes
- No asumir stack si no se puede detectar

### 4. Idempotencia

Los commands deben ser idempotentes cuando sea posible:

- `/fix-linting` puede ejecutarse múltiples veces sin problemas
- `/run-all-tests` siempre ejecuta tests limpios
