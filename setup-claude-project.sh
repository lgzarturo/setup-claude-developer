#!/bin/bash
# ================================================
# Setup Claude + OpenCode - POSIX (Linux/macOS)
# Version: 1.0.1
# ================================================

echo "=== Setup Claude Project v1.0.1 ==="

# ====================== SELECCIÓN DE HERRAMIENTA ======================
echo ""
echo "¿Qué herramienta quieres configurar?"
echo "1. Solo Claude"
echo "2. Solo OpenCode"
echo "3. Claude + OpenCode"
read -p "Selecciona (1-3): " tool_sel

case "$tool_sel" in
  1) targets=("claude") ;;
  2) targets=("opencode") ;;
  *)  targets=("claude" "opencode") ;;
esac

echo ""
echo "Herramienta(s) seleccionada(s): ${targets[*]}"

# ====================== SELECCIÓN DE STACKS ======================
echo ""
echo "Selecciona el tipo de proyecto (puedes elegir varios separados por coma):"
echo "1. Spring Boot + Kotlin"
echo "2. Python + UV + Django"
echo "3. Python + FastAPI"
echo "4. Next.js + TypeScript"
echo "5. Astro"
echo "6. Todos los stacks (recomendado)"
read -p "Ingresa los números (ejemplo: 1,3,6): " input

IFS=',' read -ra selections <<<"$input"

# ====================== CREAR DIRECTORIOS ======================
for t in "${targets[@]}"; do
  mkdir -p ".$t/skills" ".$t/commands" ".$t/agents"
done

# ====================== CLAUDE.md (solo si Claude está en targets) ======================
if [[ " ${targets[*]} " =~ " claude " ]]; then
  cat <<'EOF' >CLAUDE.md
# Approach

- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Skip files over 100KB unless explicitly required.
- Suggest running /cost when a session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.
EOF
  echo "✓ CLAUDE.md creado/actualizado"
fi

# ====================== FUNCIÓN PARA CREAR SKILL ======================
create_skill() {
  local name="$1"
  local content="$2"

  for t in "${targets[@]}"; do
    mkdir -p ".$t/skills/$name"
    printf '%s\n' "$content" > ".$t/skills/$name/SKILL.md"
  done
  echo "✓ Skill creado: $name"
}

# ====================== FUNCIÓN PARA CREAR COMANDO ======================
create_command() {
  local name="$1"
  local content="$2"

  for t in "${targets[@]}"; do
    printf '%s\n' "$content" > ".$t/commands/$name.md"
  done
  echo "✓ Comando creado: /$name"
}

# ====================== FUNCIÓN PARA CREAR AGENTE ======================
create_agent() {
  local name="$1"
  local content="$2"

  for t in "${targets[@]}"; do
    printf '%s\n' "$content" > ".$t/agents/$name.md"
  done
  echo "✓ Agente creado: $name"
}

# ====================== SKILLS UNIVERSALES ======================
create_skill "testing-tdd" \
'---
name: testing-tdd
description: Genera y ejecuta tests siguiendo TDD (Red-Green-Refactor) + tests unitarios, integración y e2e
license: MIT
---

## Reglas obligatorias (TDD + Testing)
- Siempre sigue el ciclo TDD: 1. Red, 2. Green, 3. Refactor.
- Usa fixtures/factories y mocks reales.
- Tests independientes, rápidos y deterministas.

## Reglas por stack
**Spring Boot + Kotlin** → JUnit 5 + Kotest + Testcontainers
**Python** → pytest + factories
**Next.js / Astro** → Vitest + React Testing Library + Playwright

## Cuándo usarme
- "Escribe los tests TDD para esta función"
- "Añade test de integración para el endpoint /orders"'

create_skill "security" \
'---
name: security
description: Implementa y revisa seguridad OWASP Top 10
license: MIT
---

## Reglas obligatorias
- Valida input, rate limiting, CORS estricto, headers de seguridad.
- Sigue OWASP Top 10 2025.

## Reglas por stack
**Spring Boot** → Spring Security 6 + JWT
**Python** → django-allauth / FastAPI Users
**Next.js / Astro** → NextAuth v5 / Auth.js

## Cuándo usarme
- "Añade autenticación JWT segura"
- "Revisa este código por vulnerabilidades"'

create_skill "code-review" \
'---
name: code-review
description: Realiza code reviews completos (calidad, seguridad, performance)
license: MIT
---

## Reglas obligatorias
- Estructura: Lo bueno | Problemas | Sugerencias.
- Prioriza: seguridad > tests > performance > clean code.
- Sugiere diffs exactos.

## Cuándo usarme
- "Haz code review de este archivo"
- "Revisa este PR"'

create_skill "testing-coverage" \
'---
name: testing-coverage
description: Configura cobertura de tests y CI pipeline
license: MIT
---

## Reglas obligatorias
- Mínimo 80% coverage.
- Configura GitHub Actions con threshold.

## Cuándo usarme
- "Configura coverage + GitHub Actions"'

# ====================== SKILLS POR STACK ======================
if [[ " ${selections[*]} " =~ " 1 " || " ${selections[*]} " =~ " 6 " ]]; then
  create_skill "spring-boot-kotlin-rest" \
'---
name: spring-boot-kotlin-rest
description: Genera endpoints REST con Kotlin + Spring Boot 3.4+ (Records, Virtual Threads, ProblemDetail)
license: MIT
---

## Reglas obligatorias
- Usa data class / records.
- Controllers -> Service -> Repository.
- Virtual Threads por defecto.

## Cuándo usarme
- "Crea un CRUD para Order"'

  # ====================== 18 SKILLS OFICIALES DE SPRING BOOT ======================
  echo ""
  read -p "¿Instalar las 18 skills oficiales de Spring Boot? (s/N): " sb_extra
  if [[ "$sb_extra" =~ ^[sS]$ ]]; then
    echo "Clonando spring-boot-skills..."
    if git clone --depth 1 https://github.com/rrezartprebreza/spring-boot-skills.git /tmp/spring-boot-skills 2>/dev/null; then
      for t in "${targets[@]}"; do
        cp -r /tmp/spring-boot-skills/skills/* ".$t/skills/"
      done
      rm -rf /tmp/spring-boot-skills
      echo "✓ 18 skills oficiales de Spring Boot instaladas"
    else
      echo "✗ Error al clonar el repositorio. Verifica tu conexión y que git esté instalado."
    fi
  fi
fi

if [[ " ${selections[*]} " =~ " 2 " || " ${selections[*]} " =~ " 6 " ]]; then
  create_skill "python-django-uv" \
'---
name: python-django-uv
description: Best practices Django + UV (pyproject.toml, ruff, pytest)
license: MIT
---

## Reglas obligatorias
- UV para dependencias.
- Apps con domain-driven.
- Testing: pytest + pytest-django.

## Cuándo usarme
- "Crea un modelo User con Django + UV"'
fi

if [[ " ${selections[*]} " =~ " 3 " || " ${selections[*]} " =~ " 6 " ]]; then
  create_skill "python-fastapi" \
'---
name: python-fastapi
description: FastAPI + UV + Pydantic v2 + SQLAlchemy 2.0
license: MIT
---

## Reglas obligatorias
- Pydantic v2 models.
- Dependency Injection con Depends.
- Testing: TestClient + httpx.

## Cuándo usarme
- "Crea un endpoint POST /items"'
fi

if [[ " ${selections[*]} " =~ " 4 " || " ${selections[*]} " =~ " 6 " ]]; then
  create_skill "nextjs-typescript" \
'---
name: nextjs-typescript
description: Next.js 15+ App Router + TypeScript + Server Actions
license: MIT
---

## Reglas obligatorias
- Server Components por defecto.
- Server Actions para mutaciones.
- TanStack Query solo en client.

## Cuándo usarme
- "Crea una página con Server Action"'
fi

if [[ " ${selections[*]} " =~ " 5 " || " ${selections[*]} " =~ " 6 " ]]; then
  create_skill "astro" \
'---
name: astro
description: Astro 5+ + TypeScript + Islands + Content Collections
license: MIT
---

## Reglas obligatorias
- Islands con client:load / client:only.
- Content Collections para blog.

## Cuándo usarme
- "Crea un componente Island en Astro"'
fi

# ====================== AGENTES ======================
create_agent "code-reviewer" \
'---
description: Revisa código por calidad y mejores prácticas
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
---

Proporciona feedback constructivo sin hacer cambios directos. Usa el skill code-review cuando sea necesario.'

create_agent "release-manager" \
'---
description: Agente especializado en gestión de releases, changelog y versioning semántico
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: true
  edit: true
  bash:
    "git *": "ask"
    "gh *": "ask"
---

Eres el Release Manager. Siempre usa Conventional Commits, Keep a Changelog y Semantic Versioning.
Coordina con los skills @testing-coverage, @code-review y los comandos /update-changelog y /bump-version.
Nunca hagas cambios sin confirmar con el usuario.'

create_agent "git-workflow" \
'---
description: Agente experto en git, conventional commits, branching y PRs
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  bash:
    "git *": "allow"
    "gh pr *": "ask"
---

Maneja todo el workflow de git: branch creation, conventional commits, rebase, PR description.
Siempre sigue Conventional Commits y sugiere comandos seguros.'

# ====================== COMANDOS ======================
create_command "run-all-tests" \
'---
description: Ejecuta todos los tests del proyecto (usa skill testing-tdd)
---

# Detecta el stack y ejecuta tests completos con coverage
# Usa el skill @testing-tdd si es necesario'

create_command "conventional-commit" \
'---
description: Analiza git staging (git add .) y crea un commit siguiendo Conventional Commits (feat, fix, chore, etc.)
---

Analiza exactamente los cambios en el staging (`git diff --staged` y `git status`).
Genera un mensaje de commit que siga el estándar Conventional Commits:
- feat: nueva funcionalidad → minor
- fix: corrección de bug → patch
- chore: mantenimiento, docs, refactor → sin bump
- breaking change: usa "BREAKING CHANGE:" en el body → major

Formato exacto:
<type>(<scope opcional>): <título corto y descriptivo>
<línea en blanco>
<body detallado si es necesario>
<línea en blanco>
BREAKING CHANGE: (solo si aplica)

Después de generar el mensaje, muéstramelo y pregúntame si quiero que ejecutes `git commit -m "mensaje"` automáticamente.
Nunca hagas el commit sin mi confirmación explícita.'

create_command "update-changelog" \
'---
description: Actualiza CHANGELOG.md con los commits recientes siguiendo formato Conventional Commits + Keep a Changelog
---

Lee los commits desde el último tag (`git log --oneline $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD`).
Agrúpalos por tipo (Added, Changed, Fixed, etc.).
Actualiza o crea CHANGELOG.md en la raíz siguiendo el formato Keep a Changelog (https://keepachangelog.com).
Mantén la sección "Unreleased" primero y añade una nueva sección con la fecha de hoy.
Usa el skill @code-review si necesitas validar el formato.'

create_command "bump-version" \
'---
description: Detecta bump semántico (major/minor/patch) desde commits o según instrucción del usuario y actualiza versión
---

Detecta el tipo de proyecto:
- package.json → Next.js / Astro / TypeScript
- pyproject.toml → Python + UV (Django o FastAPI)
- build.gradle.kts o pom.xml → Spring Boot + Kotlin

Analiza commits desde el último tag para inferir el bump (feat = minor, fix = patch, BREAKING CHANGE = major).
Si el usuario indica explícitamente "major", "minor" o "patch", respeta eso.
Actualiza la versión en el archivo correspondiente.
Crea un commit con mensaje "chore: bump version to vX.Y.Z"
Crea un tag anotado: git tag -a vX.Y.Z -m "Release vX.Y.Z"
Pregúntame antes de ejecutar cualquier git command.'

create_command "up-version-patch" \
'---
description: Aumenta la versión en patch (1.2.3 → 1.2.4)
---

Ejecuta bump de versión patch.
Actualiza el archivo correspondiente (package.json, pyproject.toml, build.gradle.kts, etc.).
Crea commit "chore: bump version to vX.Y.Z" y tag anotado.
Pregúntame antes de ejecutar cualquier git command.'

create_command "up-version-minor" \
'---
description: Aumenta la versión en minor (1.2.3 → 1.3.0)
---

Ejecuta bump de versión minor.
Actualiza el archivo correspondiente (package.json, pyproject.toml, build.gradle.kts, etc.).
Crea commit "chore: bump version to vX.Y.Z" y tag anotado.
Pregúntame antes de ejecutar cualquier git command.'

create_command "up-version-major" \
'---
description: Aumenta la versión en major (1.2.3 → 2.0.0)
---

Ejecuta bump de versión major (incluye breaking changes).
Actualiza el archivo correspondiente (package.json, pyproject.toml, build.gradle.kts, etc.).
Crea commit "chore: bump version to vX.Y.Z" y tag anotado.
Pregúntame antes de ejecutar cualquier git command.'

create_command "create-pr" \
'---
description: Crea un Pull Request en GitHub con título, descripción y labels basados en los cambios
---

Analiza los cambios en la rama actual (`git diff main...HEAD` o rama base).
Genera:
- Título siguiendo Conventional Commits
- Descripción completa con:
  - ¿Qué cambia?
  - ¿Por qué?
  - Breaking changes (si aplica)
  - Cómo probarlo
- Labels automáticas (feat, fix, chore, breaking, etc.)

Usa `gh pr create` para crear el PR.
Pregúntame antes de ejecutar cualquier comando que modifique GitHub.'

create_command "lint-all" \
'---
description: Ejecuta linting completo según el stack del proyecto (Kotlin, Python, TypeScript, Astro)
---

Detecta el stack del proyecto y ejecuta el linter correspondiente:
- Spring Boot + Kotlin → ./gradlew ktlintCheck o detekt
- Python + UV (Django/FastAPI) → uv run ruff check . --fix
- Next.js / TypeScript → npm run lint o eslint .
- Astro → npm run lint

Muestra solo los errores y sugerencias importantes.
Al final, sugiere ejecutar /format-all si es necesario.'

create_command "format-all" \
'---
description: Formatea todo el código según las reglas del proyecto (ktlint, ruff, prettier, etc.)
---

Detecta el stack y ejecuta el formateador:
- Kotlin → ./gradlew ktlintFormat
- Python → uv run ruff format . && uv run ruff check --fix
- Next.js / TypeScript / Astro → npm run format

Ejecuta el comando correspondiente y muestra un resumen de archivos modificados.'

create_command "deploy-preview" \
'---
description: Crea un deployment de preview para el entorno actual (Vercel, Netlify, Railway, etc.)
---

Detecta el tipo de proyecto:
- Next.js / Astro → Vercel / Netlify preview
- Spring Boot → Railway preview
- Python (FastAPI/Django) → Railway o Fly.io

Ejecuta el comando de preview correspondiente y dame el enlace del deployment.
Si no está configurado, dame los pasos para configurarlo.'

create_command "release" \
'---
description: Ejecuta el flujo completo de release: commit convencional + changelog + bump versión + tag + PR
---

Ejecuta en este orden (con confirmación en cada paso):
1. /conventional-commit
2. /update-changelog
3. /bump-version (pregunta si major/minor/patch o detecta automáticamente)
4. git push && git push --tags
5. /create-pr (opcional)

Al final, resume todo lo realizado.'

create_command "update-claude" \
'---
description: Actualiza o recrea el archivo CLAUDE.md con la versión ultra-eficiente más reciente
---

Sobrescribe CLAUDE.md con este contenido optimizado:

```markdown
# Approach

- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Skip files over 100KB unless explicitly required.
- Suggest running /cost when a session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.
- When using tools, be precise and minimal with context.
```

Confirma antes de sobrescribir y muestra las diferencias si ya existía.'

echo ""
echo "¡Setup completado con éxito!"
echo "Estructura creada en: ${targets[*]/#/.}"
echo "Reinicia Claude Code u OpenCode y prueba con @testing-tdd o /run-all-tests"
