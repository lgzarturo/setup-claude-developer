# Skills de Desarrollo

> **Versión:** 1.0.0  
> **Última actualización:** 2026-04-19

Este documento lista todos los skills disponibles en el proyecto, organizados
por categoría y flujo de desarrollo. Sirve como checklist para el estado actual
y guía para futuras mejoras.

---

## 📋 Índice

1. [Skills Universales](#skills-universales) ✅
2. [Skills por Stack](#skills-por-stack) ✅
3. [Skills Oficiales Externos](#skills-oficiales-externos) ✅
4. [Skills Recomendados para Desarrollar](#skills-recomendados-para-desarrollar)
   📋
5. [Matriz de Flujo de Desarrollo](#matriz-de-flujo-de-desarrollo)

---

## Skills Universales

> **Estado:** Implementados ✅  
> **Disponibilidad:** Siempre instalados independientemente del stack
> seleccionado

### 1. `testing-tdd`

**Propósito:** Genera y ejecuta tests siguiendo TDD (Red-Green-Refactor)

**Cobertura:**

- Tests unitarios
- Tests de integración
- Tests E2E

**Reglas por stack:** | Stack | Herramientas | |-------|-------------| | Spring
Boot + Kotlin | JUnit 5 + Kotest + Testcontainers | | Python | pytest +
factories | | Next.js / Astro | Vitest + React Testing Library + Playwright |

**Frases de activación:**

- "Escribe los tests TDD para esta función"
- "Añade test de integración para el endpoint /orders"

---

### 2. `security`

**Propósito:** Implementa y revisa seguridad OWASP Top 10

**Reglas obligatorias:**

- Valida input
- Rate limiting
- CORS estricto
- Headers de seguridad
- OWASP Top 10 2025

**Reglas por stack:** | Stack | Herramientas | |-------|-------------| | Spring
Boot | Spring Security 6 + JWT | | Python | django-allauth / FastAPI Users | |
Next.js / Astro | NextAuth v5 / Auth.js |

**Frases de activación:**

- "Añade autenticación JWT segura"
- "Revisa este código por vulnerabilidades"

---

### 3. `code-review`

**Propósito:** Realiza code reviews completos (calidad, seguridad, performance)

**Estructura de review:**

- ✅ Lo bueno
- ⚠️ Problemas
- 🚀 Sugerencias

**Prioridad:** seguridad > tests > performance > clean code

**Características:**

- Sugiere diffs exactos
- Feedback constructivo

**Frases de activación:**

- "Haz code review de este archivo"
- "Revisa este PR"

---

### 4. `testing-coverage`

**Propósito:** Configura cobertura de tests y CI pipeline

**Reglas obligatorias:**

- Mínimo 80% coverage
- Configura GitHub Actions con threshold

**Frases de activación:**

- "Configura coverage + GitHub Actions"

---

## Skills por Stack

> **Estado:** Implementados ✅  
> **Disponibilidad:** Según selección del usuario (1-6)

### Backend

#### 5. `spring-boot-kotlin-rest`

**Stack:** Spring Boot 3.4+ + Kotlin

**Características:**

- Genera endpoints REST
- Records (Java 21+)
- Virtual Threads por defecto
- ProblemDetail para errores

**Arquitectura:** Controllers → Service → Repository

**Frases de activación:**

- "Crea un CRUD para Order"

---

#### 6. `python-django-uv`

**Stack:** Django + UV Package Manager

**Características:**

- UV para dependencias (reemplaza pip)
- pyproject.toml
- ruff para linting
- Apps con domain-driven design

**Testing:** pytest + pytest-django

**Frases de activación:**

- "Crea un modelo User con Django + UV"

---

#### 7. `python-fastapi`

**Stack:** FastAPI + UV + Pydantic v2 + SQLAlchemy 2.0

**Características:**

- Pydantic v2 models
- Dependency Injection con Depends
- Async/await nativo

**Testing:** TestClient + httpx

**Frases de activación:**

- "Crea un endpoint POST /items"

---

### Frontend

#### 8. `nextjs-typescript`

**Stack:** Next.js 15+ + TypeScript + App Router

**Características:**

- Server Components por defecto
- Server Actions para mutaciones
- App Router (no Pages Router)
- TanStack Query solo en client components

**Frases de activación:**

- "Crea una página con Server Action"

---

#### 9. `astro`

**Stack:** Astro 5+ + TypeScript + Islands Architecture

**Características:**

- Islands con `client:load` / `client:only`
- Content Collections para blog/CMS
- Zero JS by default
- View Transitions API

**Frases de activación:**

- "Crea un componente Island en Astro"

---

## Skills Oficiales Externos

> **Estado:** Integración opcional ✅  
> **Fuente:** [spring-boot-skills](https://github.com/rrezartprebreza/spring-boot-skills)

### 10-27. Skills Oficiales de Spring Boot

**Cantidad:** 18 skills adicionales

**Instalación:** Opcional vía `git clone` durante la configuración

**Cobertura típica:**

- Arquitectura limpia (Clean Architecture)
- Domain-Driven Design (DDD)
- Patrones de diseño
- Testing avanzado
- Documentación API
- Observabilidad
- Performance

---

## Skills Recomendados para Desarrollar

> **Prioridad:** Alta 🔴 | Media 🟡 | Baja 🟢  
> **Estado:** Pendiente ⏳

### Fase 1: Planeación y Diseño 🔴

#### `architecture-design` ⏳

**Prioridad:** Alta

**Propósito:** Diseño de arquitectura y toma de decisiones técnicas

**Funcionalidades:**

- Selección de patrones arquitectónicos (MVC, Clean Architecture, Hexagonal)
- Diseño de diagramas C4
- Decisiones de tecnología (pros/cons)
- Documentación ADR (Architecture Decision Records)

**Frases de activación:**

- "Diseña la arquitectura para un sistema de microservicios"
- "¿Qué patrón debería usar para este dominio?"
- "Crea un diagrama de componentes"

**Stacks objetivo:** Todos

---

#### `requirements-analysis` ⏳

**Prioridad:** Alta

**Propósito:** Análisis de requisitos y casos de uso

**Funcionalidades:**

- Generar user stories desde requerimientos
- Definir criterios de aceptación (Gherkin)
- Identificar actores y casos de uso
- Crear diagrams de flujo de negocio

**Frases de activación:**

- "Convierte estos requisitos en user stories"
- "Genera casos de uso para el módulo de pagos"
- "Define los criterios de aceptación"

---

#### `database-design` ⏳

**Prioridad:** Alta

**Propósito:** Diseño de esquemas de base de datos

**Funcionalidades:**

- Modelado ER/UML
- Normalización (3NF, BCNF)
- Índices y optimización
- Migraciones

**Frases de activación:**

- "Diseña el esquema para un sistema de e-commerce"
- "Optimiza esta consulta y sugiere índices"
- "Crea las migraciones para el modelo de usuarios"

**Stacks objetivo:** Todos los stacks con persistencia

---

### Fase 2: Desarrollo 🟡

#### `api-design` ⏳

**Prioridad:** Media

**Propósito:** Diseño de APIs RESTful/GraphQL

**Funcionalidades:**

- Convenciones de nomenclatura
- Versionado de APIs
- Documentación OpenAPI/Swagger
- HATEOAS
- Rate limiting design

**Frases de activación:**

- "Diseña los endpoints REST para este dominio"
- "Genera la especificación OpenAPI"
- "Revisa este diseño de API por consistencia"

---

#### `performance-optimization` ⏳

**Prioridad:** Media

**Propósito:** Optimización de performance

**Funcionalidades:**

- Profiling y benchmarking
- Caching strategies
- Lazy loading
- Query optimization
- Bundle optimization (frontend)

**Frases de activación:**

- "Optimiza este endpoint que tarda 2 segundos"
- "Implementa caché para esta consulta"
- "Reduce el bundle size de esta página"

**Reglas por stack:** | Stack | Herramientas | |-------|-------------| | Spring
Boot | JProfiler, Micrometer, Redis | | Python | py-spy, cProfile, Redis | |
Next.js | Lighthouse, Webpack Bundle Analyzer |

---

#### `refactoring` ⏳

**Prioridad:** Media

**Propósito:** Refactorización de código legacy

**Funcionalidades:**

- Identificar code smells
- Patrones de refactorización
- Preservar comportamiento (regression tests)
- Modernización de código

**Frases de activación:**

- "Refactoriza este código siguiendo Clean Code"
- "Reduce la complejidad ciclomática de esta función"
- "Moderniza este código legacy a la versión actual"

---

### Fase 3: Calidad y Documentación 🟡

#### `documentation` ⏳

**Prioridad:** Media

**Propósito:** Generación y mantenimiento de documentación

**Funcionalidades:**

- README.md estructurados
- Documentación de código (JavaDoc, JSDoc, docstrings)
- Diagramas (Mermaid)
- Guías de contribución
- Changelog

**Frases de activación:**

- "Genera documentación para esta clase"
- "Crea un diagrama de secuencia para este flujo"
- "Escribe una guía de uso para este módulo"

---

#### `accessibility` ⏳

**Prioridad:** Media

**Propósito:** Accesibilidad web (a11y)

**Funcionalidades:**

- WCAG 2.1 AA/AAA compliance
- ARIA labels
- Keyboard navigation
- Screen reader testing
- Color contrast

**Frases de activación:**

- "Revisa esta página por accesibilidad"
- "Añade ARIA labels a este componente"
- "Haz que este formulario sea accesible"

**Stacks objetivo:** Next.js, Astro

---

#### `internationalization` ⏳

**Prioridad:** Baja

**Propósito:** Internacionalización (i18n)

**Funcionalidades:**

- Extracción de strings
- Gestión de archivos de traducción
- RTL support
- Formatos de fecha/moneda/números

**Frases de activación:**

- "Añade soporte multiidioma a esta aplicación"
- "Extrae todos los textos a archivos de traducción"

**Stacks objetivo:** Next.js, Astro, Django

---

### Fase 4: DevOps y Operaciones 🟢

#### `docker-deployment` ⏳

**Prioridad:** Media

**Propósito:** Contenerización con Docker

**Funcionalidades:**

- Dockerfile multi-stage
- Docker Compose
- Optimización de imágenes
- Health checks

**Frases de activación:**

- "Crea un Dockerfile para esta aplicación"
- "Configura Docker Compose con DB y cache"
- "Optimiza el tamaño de esta imagen"

---

#### `ci-cd-pipelines` ⏳

**Prioridad:** Media

**Propósito:** Pipelines de CI/CD

**Funcionalidades:**

- GitHub Actions workflows
- GitLab CI
- Pipeline de build, test, deploy
- Semantic versioning
- Automated releases

**Frases de activación:**

- "Configura GitHub Actions para build y test"
- "Añade deploy automático a staging"
- "Implementa semantic release"

---

#### `monitoring-logging` ⏳

**Prioridad:** Baja

**Propósito:** Observabilidad

**Funcionalidades:**

- Logging estructurado
- Métricas (Prometheus, Grafana)
- Tracing distribuido
- Alerting

**Frases de activación:**

- "Configura logging estructurado con JSON"
- "Añade métricas de negocio"
- "Implementa distributed tracing"

---

## Matriz de Flujo de Desarrollo

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO DE DESARROLLO                          │
├──────────────┬──────────────────────────────────────────────────┤
│ FASE         │ SKILLS DISPONIBLES / RECOMENDADOS                │
├──────────────┼──────────────────────────────────────────────────┤
│ 1. PLANNING  │ ✅ architecture-design ⏳                         │
│              │ ✅ requirements-analysis ⏳                       │
│              │ ✅ database-design ⏳                             │
├──────────────┼──────────────────────────────────────────────────┤
│ 2. SETUP     │ ✅ setup-[stack]                                  │
│              │ ✅ docker-deployment ⏳                           │
├──────────────┼──────────────────────────────────────────────────┤
│ 3. CODING    │ ✅ [stack-specific]                               │
│              │ ✅ api-design ⏳                                  │
│              │ ✅ refactoring ⏳                                 │
│              │ ✅ security                                       │
├──────────────┼──────────────────────────────────────────────────┤
│ 4. TESTING   │ ✅ testing-tdd                                    │
│              │ ✅ testing-coverage                               │
├──────────────┼──────────────────────────────────────────────────┤
│ 5. REVIEW    │ ✅ code-review                                    │
│              │ ✅ performance-optimization ⏳                    │
│              │ ✅ accessibility ⏳                               │
├──────────────┼──────────────────────────────────────────────────┤
│ 6. DOCS      │ ✅ documentation ⏳                               │
│              │ ✅ internationalization ⏳                        │
├──────────────┼──────────────────────────────────────────────────┤
│ 7. DEPLOY    │ ✅ ci-cd-pipelines ⏳                             │
│              │ ✅ docker-deployment ⏳                           │
│              │ ✅ monitoring-logging ⏳                         │
└──────────────┴──────────────────────────────────────────────────┘
```

---

## Checklist de Implementación

### Skills Actuales (9 skills + 18 externos)

- [x] `testing-tdd`
- [x] `security`
- [x] `code-review`
- [x] `testing-coverage`
- [x] `spring-boot-kotlin-rest`
- [x] `python-django-uv`
- [x] `python-fastapi`
- [x] `nextjs-typescript`
- [x] `astro`
- [x] 18 skills oficiales de Spring Boot (integración externa)

### Skills Recomendados (15 skills)

**Fase 1: Planeación**

- [ ] `architecture-design` 🔴
- [ ] `requirements-analysis` 🔴
- [ ] `database-design` 🔴

**Fase 2: Desarrollo**

- [ ] `api-design` 🟡
- [ ] `performance-optimization` 🟡
- [ ] `refactoring` 🟡

**Fase 3: Calidad**

- [ ] `documentation` 🟡
- [ ] `accessibility` 🟡
- [ ] `internationalization` 🟢

**Fase 4: DevOps**

- [ ] `docker-deployment` 🟡
- [ ] `ci-cd-pipelines` 🟡
- [ ] `monitoring-logging` 🟢

---

## Notas de Implementación

### Prioridad Alta (🔴)

Estos skills son fundamentales para un flujo de desarrollo completo y deberían
implementarse primero.

### Prioridad Media (🟡)

Skills importantes que complementan el flujo existente. Añaden valor
significativo pero no son bloqueantes.

### Prioridad Baja (🟢)

Skills especializados para casos de uso específicos. Implementar cuando se
complete las prioridades altas y medias.

### Consideraciones Técnicas

1. **Consistencia:** Todos los skills deben seguir el mismo formato YAML
   frontmatter
2. **Stack-specific:** Los skills con variantes por stack deben mantener la
   tabla de equivalencias
3. **Frases de activación:** Cada skill debe tener al menos 2-3 frases de
   ejemplo
4. **Testing:** Los skills de testing deben cubrir unit, integration y e2e
