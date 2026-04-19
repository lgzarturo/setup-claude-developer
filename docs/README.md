# Documentación del Proyecto

> **Setup Claude + OpenCode Developer Environment**  
> **Versión:** 1.0.0

Esta carpeta contiene la documentación técnica detallada del proyecto,
organizada por componentes principales.

---

## 📚 Índice de Documentos

### 1. [01-skills.md](01-skills.md) - Skills de Desarrollo

Documentación completa de todos los skills disponibles:

- **Skills Universales** (4 skills): `testing-tdd`, `security`, `code-review`,
  `testing-coverage`
- **Skills por Stack** (5 skills): Spring Boot, Django, FastAPI, Next.js, Astro
- **Skills Oficiales Externos** (18 skills): Integración opcional con Spring
  Boot Skills
- **Skills Recomendados** (15 skills): Roadmap de desarrollo futuro

**Casos de uso:**

- Consultar qué skills están disponibles
- Planificar nuevos skills basados en el flujo de desarrollo
- Checklist de implementación

---

### 2. [02-agents.md](02-agents.md) - Agents de Desarrollo

Documentación de agents (subagentes especializados):

- **Agents Actuales** (1 agent): `code-reviewer`
- **Agents Recomendados** (11 agents): Arquitecto, Business Analyst,
  Implementer, QA Engineer, etc.

**Casos de uso:**

- Entender cómo funcionan los agents
- Diseñar nuevos agents para tareas específicas
- Configurar parámetros (temperatura, permisos)

---

### 3. [03-commands.md](03-commands.md) - Commands de Desarrollo

Documentación de comandos slash (`/`):

- **Commands Actuales** (1 command): `/run-all-tests`
- **Commands Recomendados** (16 commands): `/commit`, `/create-pr`,
  `/security-scan`, etc.

**Casos de uso:**

- Conocer comandos disponibles
- Diseñar nuevos comandos para automatización
- Integrar con CI/CD

---

## 🔄 Flujo de Desarrollo Completo

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FLUJO DE DESARROLLO COMPLETO                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. PLANNING                                                        │
│     ├── @architecture-design                                        │
│     ├── @requirements-analysis                                      │
│     ├── @database-design                                            │
│     ├── /architect                                                  │
│     ├── /business-analyst                                           │
│     └── /generate-adr                                               │
│                                                                     │
│  2. SETUP                                                           │
│     ├── @spring-boot-kotlin-rest | @python-django-uv | etc.        │
│     └── /setup-project                                              │
│                                                                     │
│  3. DEVELOPMENT                                                     │
│     ├── @security                                                   │
│     ├── @api-design (recomendado)                                   │
│     ├── /implementer                                                │
│     ├── /refactoring-specialist                                     │
│     ├── /performance-engineer                                       │
│     ├── /fix-linting                                                │
│     └── /update-deps                                                │
│                                                                     │
│  4. TESTING                                                         │
│     ├── @testing-tdd                                                │
│     ├── @testing-coverage                                           │
│     ├── /run-all-tests                                              │
│     ├── /test-coverage                                              │
│     ├── /security-scan                                              │
│     ├── /generate-tests                                             │
│     └── /qa-engineer                                                │
│                                                                     │
│  5. REVIEW                                                          │
│     ├── @code-review                                                │
│     ├── /code-reviewer                                              │
│     └── /security-auditor                                           │
│                                                                     │
│  6. DOCUMENTATION                                                   │
│     ├── @documentation (recomendado)                                │
│     ├── /technical-writer                                           │
│     └── /changelog                                                  │
│                                                                     │
│  7. DEVOPS & DEPLOY                                                 │
│     ├── @docker-deployment (recomendado)                            │
│     ├── @ci-cd-pipelines (recomendado)                              │
│     ├── @monitoring-logging (recomendado)                           │
│     ├── /devops-engineer                                            │
│     ├── /release-manager                                            │
│     ├── /build-docker                                               │
│     ├── /deploy-staging                                             │
│     └── /logs                                                       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Resumen de Componentes

| Componente   | Implementados    | Recomendados | Total |
| ------------ | ---------------- | ------------ | ----- |
| **Skills**   | 9 (+18 externos) | 15           | 42    |
| **Agents**   | 1                | 11           | 12    |
| **Commands** | 1                | 16           | 17    |

---

## 🎯 Prioridades de Implementación

### Alta Prioridad 🔴

Skills/Agents/Commands que deberían implementarse primero:

- `architecture-design` (skill)
- `requirements-analysis` (skill)
- `database-design` (skill)
- `security-auditor` (agent)
- `/commit` (command)
- `/create-pr` (command)
- `/setup-project` (command)

### Media Prioridad 🟡

Componentes importantes pero no bloqueantes:

- `api-design`, `refactoring`, `performance-optimization` (skills)
- `implementer`, `qa-engineer`, `devops-engineer` (agents)
- `/test-coverage`, `/security-scan`, `/fix-linting` (commands)

### Baja Prioridad 🟢

Componentes especializados:

- `internationalization`, `monitoring-logging` (skills)
- `release-manager`, `technical-writer` (agents)
- `/deploy-staging`, `/logs`, `/docs-serve` (commands)

---

## 📝 Convenciones

### Skills (`@`)

```yaml
---
name: skill-name
description: Descripción clara y concisa
license: MIT
---

## Reglas obligatorias
- Regla 1
- Regla 2

## Cuándo usarme
- "Frase de activación 1"
- "Frase de activación 2"
```

### Agents (`/`)

```yaml
---
description: Descripción del agente
mode: subagent
temperature: 0.1-0.3
tools:
  write: true/false
  edit: true/false
  bash: true/false
---

Instrucciones de comportamiento...
```

### Commands (`/`)

```yaml
---
description: Descripción del comando
---

# Comentarios descriptivos
# Instrucciones para ejecución
# Referencias a skills: @skill-name
```

---

## 🤝 Contribuir

Si deseas agregar nuevos skills, agents o commands:

1. Revisa los documentos correspondientes para ver si ya existe algo similar
2. Consulta la lista de recomendaciones para prioridad
3. Sigue las convenciones de formato establecidas
4. Actualiza el documento correspondiente con la información del nuevo
   componente
5. Actualiza este README con los conteos actualizados

---

## 📞 Soporte

- **GitHub Issues**: Para reportar bugs o solicitar features
- **GitHub Discussions**: Para preguntas y discusiones
- **Email**: [lgzarturo@gmail.com](mailto:lgzarturo@gmail.com)

---

<div align="center">
  <strong>Documentación v1.0.0</strong> | 
  <a href="../README.md">Volver al README principal</a>
</div>
