# ================================================
# Setup Claude + OpenCode - Windows 11 PowerShell
# Version: 1.0.0
# ================================================

Write-Host "=== Setup Claude Project v1.0.0 ===" -ForegroundColor Cyan

# ====================== SELECCIÓN DE HERRAMIENTA ======================
Write-Host ""
Write-Host "¿Qué herramienta quieres configurar?" -ForegroundColor Yellow
Write-Host "1. Solo Claude"
Write-Host "2. Solo OpenCode"
Write-Host "3. Claude + OpenCode"
$toolSel = Read-Host "Selecciona (1-3)"

$targets = switch ($toolSel) {
    "1" { @("claude") }
    "2" { @("opencode") }
    default { @("claude", "opencode") }
}

Write-Host "Herramienta(s) seleccionada(s): $($targets -join ', ')" -ForegroundColor Green

# ====================== SELECCIÓN DE STACKS ======================
Write-Host ""
Write-Host "Selecciona el tipo de proyecto (puedes elegir varios separados por coma):" -ForegroundColor Yellow
Write-Host "1. Spring Boot + Kotlin"
Write-Host "2. Python + UV + Django"
Write-Host "3. Python + FastAPI"
Write-Host "4. Next.js + TypeScript"
Write-Host "5. Astro"
Write-Host "6. Todos los stacks (recomendado)"
$rawInput = Read-Host "Ingresa los números (ejemplo: 1,3,6)"
$selections = $rawInput -split ',' | ForEach-Object { $_.Trim() }

# ====================== CREAR DIRECTORIOS ======================
foreach ($t in $targets) {
    New-Item -ItemType Directory -Force -Path ".$t/skills", ".$t/commands", ".$t/agents" | Out-Null
}

# ====================== CLAUDE.md (solo si Claude está en targets) ======================
if ($targets -contains "claude") {
    $claudeContent = @'
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
'@
    Set-Content -Path "CLAUDE.md" -Value $claudeContent -Encoding UTF8
    Write-Host "✓ CLAUDE.md creado/actualizado" -ForegroundColor Green
}

# ====================== FUNCIÓN PARA CREAR SKILL ======================
function Create-Skill {
    param([string]$name, [string]$content)

    foreach ($t in $targets) {
        $dir = ".$t/skills/$name"
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Set-Content -Path "$dir/SKILL.md" -Value $content -Encoding UTF8
    }
    Write-Host "✓ Skill creado: $name" -ForegroundColor Green
}

# ====================== SKILLS UNIVERSALES ======================
Create-Skill -name "testing-tdd" -content @'
---
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
- "Añade test de integración para el endpoint /orders"
'@

Create-Skill -name "security" -content @'
---
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
- "Revisa este código por vulnerabilidades"
'@

Create-Skill -name "code-review" -content @'
---
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
- "Revisa este PR"
'@

Create-Skill -name "testing-coverage" -content @'
---
name: testing-coverage
description: Configura cobertura de tests y CI pipeline
license: MIT
---

## Reglas obligatorias
- Mínimo 80% coverage.
- Configura GitHub Actions con threshold.

## Cuándo usarme
- "Configura coverage + GitHub Actions"
'@

# ====================== SKILLS POR STACK ======================
if ($selections -contains "1" -or $selections -contains "6") {
    Create-Skill -name "spring-boot-kotlin-rest" -content @'
---
name: spring-boot-kotlin-rest
description: Genera endpoints REST con Kotlin + Spring Boot 3.4+ (Records, Virtual Threads, ProblemDetail)
license: MIT
---

## Reglas obligatorias
- Usa data class / records.
- Controllers -> Service -> Repository.
- Virtual Threads por defecto.

## Cuándo usarme
- "Crea un CRUD para Order"
'@

    # ====================== 18 SKILLS OFICIALES DE SPRING BOOT ======================
    Write-Host ""
    $sbExtra = Read-Host "¿Instalar las 18 skills oficiales de Spring Boot? (s/N)"
    if ($sbExtra -match '^[sS]$') {
        Write-Host "Clonando spring-boot-skills..." -ForegroundColor Yellow
        $tmpDir = "$env:TEMP\spring-boot-skills"
        try {
            git clone --depth 1 https://github.com/rrezartprebreza/spring-boot-skills.git $tmpDir 2>&1 | Out-Null
            foreach ($t in $targets) {
                $dest = ".$t/skills"
                Copy-Item -Path "$tmpDir/skills/*" -Destination $dest -Recurse -Force
            }
            Remove-Item -Recurse -Force $tmpDir
            Write-Host "✓ 18 skills oficiales de Spring Boot instaladas" -ForegroundColor Green
        } catch {
            Write-Host "✗ Error al clonar el repositorio. Verifica tu conexión y que git esté instalado." -ForegroundColor Red
            if (Test-Path $tmpDir) { Remove-Item -Recurse -Force $tmpDir }
        }
    }
}

if ($selections -contains "2" -or $selections -contains "6") {
    Create-Skill -name "python-django-uv" -content @'
---
name: python-django-uv
description: Best practices Django + UV (pyproject.toml, ruff, pytest)
license: MIT
---

## Reglas obligatorias
- UV para dependencias.
- Apps con domain-driven.
- Testing: pytest + pytest-django.

## Cuándo usarme
- "Crea un modelo User con Django + UV"
'@
}

if ($selections -contains "3" -or $selections -contains "6") {
    Create-Skill -name "python-fastapi" -content @'
---
name: python-fastapi
description: FastAPI + UV + Pydantic v2 + SQLAlchemy 2.0
license: MIT
---

## Reglas obligatorias
- Pydantic v2 models.
- Dependency Injection con Depends.
- Testing: TestClient + httpx.

## Cuándo usarme
- "Crea un endpoint POST /items"
'@
}

if ($selections -contains "4" -or $selections -contains "6") {
    Create-Skill -name "nextjs-typescript" -content @'
---
name: nextjs-typescript
description: Next.js 15+ App Router + TypeScript + Server Actions
license: MIT
---

## Reglas obligatorias
- Server Components por defecto.
- Server Actions para mutaciones.
- TanStack Query solo en client.

## Cuándo usarme
- "Crea una página con Server Action"
'@
}

if ($selections -contains "5" -or $selections -contains "6") {
    Create-Skill -name "astro" -content @'
---
name: astro
description: Astro 5+ + TypeScript + Islands + Content Collections
license: MIT
---

## Reglas obligatorias
- Islands con client:load / client:only.
- Content Collections para blog.

## Cuándo usarme
- "Crea un componente Island en Astro"
'@
}

# ====================== AGENTE ======================
$agentContent = @'
---
description: Revisa código por calidad y mejores prácticas
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
---

Proporciona feedback constructivo sin hacer cambios directos. Usa el skill code-review cuando sea necesario.
'@

foreach ($t in $targets) {
    Set-Content -Path ".$t/agents/code-reviewer.md" -Value $agentContent -Encoding UTF8
}
Write-Host "✓ Agente creado: code-reviewer" -ForegroundColor Green

# ====================== COMANDO ======================
$cmdContent = @'
---
description: Ejecuta todos los tests del proyecto (usa skill testing-tdd)
---

# Detecta el stack y ejecuta tests completos con coverage
# Usa el skill @testing-tdd si es necesario
'@

foreach ($t in $targets) {
    Set-Content -Path ".$t/commands/run-all-tests.md" -Value $cmdContent -Encoding UTF8
}
Write-Host "✓ Comando creado: run-all-tests" -ForegroundColor Green

# ====================== FINAL ======================
$targetDirs = ($targets | ForEach-Object { ".$_" }) -join " y "
Write-Host "`n¡Setup completado con éxito!" -ForegroundColor Cyan
Write-Host "Estructura creada en: $targetDirs"
Write-Host "Reinicia Claude Code u OpenCode y prueba con @testing-tdd o /run-all-tests"
