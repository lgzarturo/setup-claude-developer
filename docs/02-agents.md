# Agents de Desarrollo

> **Versión:** 1.0.0  
> **Última actualización:** 2026-04-19

Este documento lista todos los agents disponibles en el proyecto, su propósito y
recomendaciones para nuevos agents basados en el flujo de desarrollo y
planeación.

---

## 📋 Índice

1. [Agents Disponibles](#agents-disponibles) ✅
2. [Agents Recomendados para Desarrollar](#agents-recomendados-para-desarrollar)
   📋
3. [Matriz de Agentes por Fase](#matriz-de-agentes-por-fase)
4. [Especificación Técnica](#especificación-técnica)

---

## Agents Disponibles

> **Estado:** Implementados ✅  
> **Total:** 3 agentes

### 1. `code-reviewer`

**Descripción:** Revisa código por calidad y mejores prácticas

**Configuración:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
```

**Comportamiento:**

- Proporciona feedback constructivo
- **NO** hace cambios directos (solo lectura/análisis)
- Usa el skill `code-review` cuando sea necesario
- Prioriza: seguridad > tests > performance > clean code

**Casos de uso:**

- Revisión de Pull Requests
- Análisis pre-commit
- Validación de estándares de código
- Mentoría de desarrolladores junior

**Ventajas de ser subagente:**

- Aislamiento de cambios (read-only)
- Temperatura baja (0.1) = respuestas consistentes y deterministas
- Enfocado únicamente en revisión, no en implementación

---

### 2. `release-manager`

**Descripción:** Agente especializado en gestión de releases, changelog y versioning semántico

**Configuración:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: true
  edit: true
  bash:
    "git *": "ask"
    "gh *": "ask"
```

**Comportamiento:**

- Siempre usa Conventional Commits, Keep a Changelog y Semantic Versioning
- Coordina con `@testing-coverage`, `@code-review`, `/update-changelog` y `/bump-version`
- **Nunca** ejecuta git commands sin confirmación del usuario

**Casos de uso:**

- "Prepara el release v2.0.0"
- "Genera el changelog desde la última versión"
- "Actualiza las versiones de todas las dependencias"

---

### 3. `git-workflow`

**Descripción:** Agente experto en git, conventional commits, branching y PRs

**Configuración:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  bash:
    "git *": "allow"
    "gh pr *": "ask"
```

**Comportamiento:**

- Ejecuta `git *` directamente (sin confirmación)
- Requiere confirmación para operaciones de GitHub (`gh pr *`)
- Siempre sigue Conventional Commits

**Casos de uso:**

- "Crea una branch para este feature"
- "Genera el mensaje de commit para estos cambios"
- "Haz rebase de esta rama sobre main"
- "Crea el PR con descripción automática"

---

## Agents Recomendados para Desarrollar

> **Prioridad:** Alta 🔴 | Media 🟡 | Baja 🟢  
> **Estado:** Pendiente ⏳

### Fase 1: Planeación y Análisis 🔴

#### `architect` ⏳

**Prioridad:** Alta

**Descripción:** Arquitecto de software para toma de decisiones de alto nivel

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-opus-4-20250514
temperature: 0.3
tools:
  write: true
  edit: true
  bash: false
```

**Responsabilidades:**

- Diseñar arquitectura de sistemas
- Evaluar trade-offs tecnológicos
- Crear diagramas de arquitectura
- Documentar Decisiones de Arquitectura (ADRs)
- Recomendar patrones de diseño

**Diferencias con skill `architecture-design`:**

- El **skill** es para consultas rápidas y guías
- El **agent** toma decisiones estructurales y modifica documentación

**Casos de uso:**

- "Diseña la arquitectura para un sistema de microservicios"
- "Evalúa si deberíamos usar monolito o microservicios"
- "Crea los diagramas C4 para este sistema"

**Skills asociados:**

- `@architecture-design`

---

#### `business-analyst` ⏳

**Prioridad:** Alta

**Descripción:** Analista de negocio para traducir requerimientos

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: false
```

**Responsabilidades:**

- Transformar requerimientos en user stories
- Definir criterios de aceptación (Gherkin)
- Crear diagramas de flujo de negocio
- Identificar casos de uso y actores
- Escribir documentación funcional

**Casos de uso:**

- "Convierte estos requerimientos del cliente en user stories"
- "Define los criterios de aceptación para el módulo de pagos"
- "Identifica los actores y sus permisos"

**Skills asociados:**

- `@requirements-analysis`

---

### Fase 2: Desarrollo y Implementación 🟡

#### `implementer` ⏳

**Prioridad:** Media

**Descripción:** Desarrollador encargado de implementar features completas

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Implementar features end-to-end
- Seguir TDD (escribir tests primero)
- Respetar arquitectura definida
- Generar código de calidad con tests

**Casos de uso:**

- "Implementa el CRUD completo de usuarios con tests"
- "Crea el sistema de autenticación JWT"
- "Desarrolla la API REST para pedidos"

**Skills asociados:**

- `@testing-tdd`
- `@security`
- `@[stack-specific]`

**Diferencias con usar skills directamente:**

- El **agent** coordina múltiples skills
- Mantiene contexto durante toda la implementación
- Puede ejecutar comandos (bash) para verificar

---

#### `refactoring-specialist` ⏳

**Prioridad:** Media

**Descripción:** Especialista en refactorización de código legacy

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Identificar code smells
- Refactorizar preservando comportamiento
- Crear tests de caracterización
- Modernizar código legacy
- Documentar cambios realizados

**Casos de uso:**

- "Refactoriza este módulo de 2000 líneas"
- "Extrae esta lógica en un patrón Strategy"
- "Moderniza este código de Java 8 a Java 21"

**Skills asociados:**

- `@refactoring`
- `@testing-tdd`
- `@code-review`

---

#### `performance-engineer` ⏳

**Prioridad:** Media

**Descripción:** Especialista en optimización de performance

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Identificar cuellos de botella
- Implementar optimizaciones
- Configurar caching
- Analizar queries y sugerir índices
- Benchmarking

**Casos de uso:**

- "Optimiza este endpoint que tarda 3 segundos"
- "Implementa Redis para cachear estas consultas"
- "Reduce el bundle size de esta aplicación Next.js"

**Skills asociados:**

- `@performance-optimization`
- `@testing-coverage`

---

### Fase 3: Testing y QA 🟡

#### `qa-engineer` ⏳

**Prioridad:** Media

**Descripción:** Ingeniero de QA para testing exhaustivo

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Generar casos de prueba edge cases
- Testing exploratorio
- Validar cobertura de tests
- Reportar bugs con pasos de reproducción
- Verificar casos límite

**Casos de uso:**

- "Genera casos de prueba para este formulario"
- "Encuentra edge cases en esta función"
- "Verifica que todos los caminos están testeados"

**Skills asociados:**

- `@testing-tdd`
- `@testing-coverage`

---

#### `security-auditor` ⏳

**Prioridad:** Alta

**Descripción:** Auditor de seguridad para análisis profundo

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-opus-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
```

**Responsabilidades:**

- Análisis estático de seguridad
- Identificar vulnerabilidades OWASP
- Revisar configuraciones de seguridad
- Verificar manejo de secretos
- Auditar dependencias

**Casos de uso:**

- "Audita este proyecto por vulnerabilidades"
- "Revisa la configuración de CORS y headers de seguridad"
- "Verifica que no haya secretos hardcodeados"

**Diferencias con skill `security`:**

- El **skill** guía en la implementación
- El **agent** hace auditoría profunda sin modificar código

**Skills asociados:**

- `@security`

---

### Fase 4: DevOps y Operaciones 🟢

#### `devops-engineer` ⏳

**Prioridad:** Media

**Descripción:** Ingeniero DevOps para infraestructura y deployment

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Configurar Docker y Docker Compose
- Crear pipelines CI/CD
- Configurar monitoreo y logging
- Gestión de infraestructura como código
- Troubleshooting de deployments

**Casos de uso:**

- "Configura GitHub Actions para build, test y deploy"
- "Dockeriza esta aplicación con multi-stage build"
- "Configura Prometheus y Grafana para monitoreo"

**Skills asociados:**

- `@docker-deployment`
- `@ci-cd-pipelines`
- `@monitoring-logging`

---

#### `release-manager` ✅

**Prioridad:** Baja

**Descripción:** Gestor de releases y versionado

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  write: true
  edit: true
  bash: true
```

**Responsabilidades:**

- Semantic versioning
- Generación de changelogs
- Creación de releases en GitHub/GitLab
- Preparar notas de release
- Coordinar versiones de dependencias

**Casos de uso:**

- "Prepara el release v2.0.0"
- "Genera el changelog desde la última versión"
- "Actualiza las versiones de todas las dependencias"

---

### Fase 5: Documentación 🟢

#### `technical-writer` ⏳

**Prioridad:** Baja

**Descripción:** Documentador técnico para crear documentación completa

**Configuración propuesta:**

```yaml
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.3
tools:
  write: true
  edit: true
  bash: false
```

**Responsabilidades:**

- Documentación de API (OpenAPI/Swagger)
- READMEs estructurados
- Guías de usuario y desarrollador
- Documentación de arquitectura
- Diagramas (Mermaid)

**Casos de uso:**

- "Genera la documentación OpenAPI de esta API"
- "Crea una guía de contribución para el proyecto"
- "Documenta la arquitectura con diagramas"

**Skills asociados:**

- `@documentation`

---

## Matriz de Agentes por Fase

```
┌──────────────────────────────────────────────────────────────────────┐
│                        AGENTES POR FASE                              │
├──────────────┬───────────────────────────────────────────────────────┤
│ FASE         │ AGENTS DISPONIBLES / RECOMENDADOS                     │
├──────────────┼───────────────────────────────────────────────────────┤
│ 1. PLANNING  │ ✅ business-analyst ⏳                                │
│              │ ✅ architect ⏳                                        │
├──────────────┼───────────────────────────────────────────────────────┤
│ 2. CODING    │ ✅ implementer ⏳                                      │
│              │ ✅ refactoring-specialist ⏳                          │
│              │ ✅ performance-engineer ⏳                            │
├──────────────┼───────────────────────────────────────────────────────┤
│ 3. REVIEW    │ ✅ code-reviewer (ACTUAL)                             │
│              │ ✅ security-auditor ⏳                                │
├──────────────┼───────────────────────────────────────────────────────┤
│ 4. TESTING   │ ✅ qa-engineer ⏳                                     │
├──────────────┼───────────────────────────────────────────────────────┤
│ 5. DOCS      │ ✅ technical-writer ⏳                                │
├──────────────┼───────────────────────────────────────────────────────┤
│ 6. DEVOPS    │ ✅ devops-engineer ⏳                                 │
│              │ ✅ release-manager ⏳                                 │
└──────────────┴───────────────────────────────────────────────────────┘
```

---

## Especificación Técnica

### Formato de Agent

Los agents deben seguir este formato:

```markdown
---
description: [Descripción clara del propósito]
mode: subagent | ask | agent
temperature: [0.0 - 1.0]
tools:
  write: true | false
  edit: true | false
  bash: true | false
---

[Instrucciones detalladas del comportamiento]
```

### Modos Disponibles

| Modo       | Descripción                                     | Uso recomendado                       |
| ---------- | ----------------------------------------------- | ------------------------------------- |
| `subagent` | Agente especializado con herramientas limitadas | Tareas específicas (review, análisis) |
| `ask`      | Solo pregunta, no ejecuta                       | Consultas informativas                |
| `agent`    | Agente completo con todas las herramientas      | Tareas complejas end-to-end           |

### Configuración de Temperatura

| Valor     | Uso                                                              |
| --------- | ---------------------------------------------------------------- |
| 0.0 - 0.2 | Tareas técnicas, código, revisiones (determinista)               |
| 0.3 - 0.5 | Diseño, arquitectura, brainstorming                              |
| 0.6 - 1.0 | Creatividad, contenido, exploración (no recomendado para código) |

### Permisos de Herramientas

| Agente             | write | edit | bash | Razón                           |
| ------------------ | ----- | ---- | ---- | ------------------------------- |
| `code-reviewer`    | ❌    | ❌   | ❌   | Solo lectura/análisis           |
| `implementer`      | ✅    | ✅   | ✅   | Desarrollo completo             |
| `architect`        | ✅    | ✅   | ❌   | Diseño sin ejecución de scripts |
| `security-auditor` | ❌    | ❌   | ❌   | Auditoría read-only             |

---

## Checklist de Implementación

### Agents Actuales (3 agents)

- [x] `code-reviewer`
  - [x] Configuración como subagent
  - [x] Temperatura 0.1
  - [x] Read-only (write/edit/bash: false)
  - [x] Integración con skill `@code-review`
- [x] `release-manager`
  - [x] Conventional Commits + Keep a Changelog + SemVer
  - [x] Confirmación obligatoria para git/gh commands
  - [x] Coordina con `/update-changelog` y `/bump-version`
- [x] `git-workflow`
  - [x] `git *` permitido directamente
  - [x] `gh pr *` requiere confirmación
  - [x] Branch, commit, rebase, PR description

### Agents Recomendados (9 agents pendientes)

**Fase 1: Planeación**

- [ ] `architect` 🔴
- [ ] `business-analyst` 🔴

**Fase 2: Desarrollo**

- [ ] `implementer` 🟡
- [ ] `refactoring-specialist` 🟡
- [ ] `performance-engineer` 🟡

**Fase 3: Testing y QA**

- [ ] `qa-engineer` 🟡
- [ ] `security-auditor` 🔴

**Fase 4: DevOps**

- [ ] `devops-engineer` 🟡
- [ ] `release-manager` 🟢

**Fase 5: Documentación**

- [ ] `technical-writer` 🟢

---

## Flujo de Trabajo Recomendado con Agents

```
┌─────────────────────────────────────────────────────────────────┐
│              FLUJO DE TRABAJO CON MULTI-AGENTES                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. PLANNING                                                    │
│     └── /architect "Diseña arquitectura del sistema"           │
│     └── /business-analyst "Crea user stories"                   │
│                                                                 │
│  2. IMPLEMENTATION                                              │
│     └── /implementer "Implementa feature X con TDD"           │
│                                                                 │
│  3. REVIEW                                                      │
│     └── /code-reviewer "Revisa el PR"                           │
│     └── /security-auditor "Audita seguridad"                    │
│                                                                 │
│  4. TESTING                                                     │
│     └── /qa-engineer "Genera casos edge case"                   │
│                                                                 │
│  5. DOCUMENTATION                                               │
│     └── /technical-writer "Documenta la API"                    │
│                                                                 │
│  6. DEPLOYMENT                                                  │
│     └── /devops-engineer "Configura CI/CD"                      │
│     └── /release-manager "Prepara release v1.0"                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Notas de Implementación

### 1. Subagent vs Agent

- **Subagent**: Mejor para tareas específicas y aisladas. Limitaciones de
  herramientas proporcionan seguridad.
- **Agent**: Para tareas complejas que requieren coordinación. Más poder pero
  requiere supervisión.

### 2. Temperatura

Los agents de código y revisión deben usar temperaturas bajas (0.1-0.2) para
consistencia.

### 3. Read-only Agents

Los agents de auditoría (`code-reviewer`, `security-auditor`) deben ser
read-only para evitar modificaciones accidentales durante el análisis.

### 4. Coordinación

Los agents pueden llamarse entre sí. Por ejemplo, `implementer` puede invocar
`@code-review` después de escribir código.
