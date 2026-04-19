#!/bin/bash
# ================================================
# Setup Claude + OpenCode - POSIX (Linux/macOS)
# Version: 1.0.0
# ================================================

echo "=== Setup Claude Project v1.0.0 ==="

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

# ====================== AGENTE ======================
agent_content='---
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

for t in "${targets[@]}"; do
  printf '%s\n' "$agent_content" > ".$t/agents/code-reviewer.md"
done
echo "✓ Agente creado: code-reviewer"

# ====================== COMANDO ======================
cmd_content='---
description: Ejecuta todos los tests del proyecto (usa skill testing-tdd)
---

# Detecta el stack y ejecuta tests completos con coverage
# Usa el skill @testing-tdd si es necesario'

for t in "${targets[@]}"; do
  printf '%s\n' "$cmd_content" > ".$t/commands/run-all-tests.md"
done
echo "✓ Comando creado: run-all-tests"

echo ""
echo "¡Setup completado con éxito!"
echo "Estructura creada en: ${targets[*]/#/.}"
echo "Reinicia Claude Code u OpenCode y prueba con @testing-tdd o /run-all-tests"
