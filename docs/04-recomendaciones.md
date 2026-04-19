# 04 — Herramientas complementarias recomendadas

Después de ejecutar `setup-claude-project` y tener tu entorno base configurado,
estas cinco herramientas complementan el flujo de trabajo con Claude Code para
reducir consumo de tokens, mejorar la revisión de código y mantener contexto
entre sesiones.

---

## Resumen rápido

| Herramienta                                         | Tipo           | Qué hace                                                              | Ahorro reportado                 |
| --------------------------------------------------- | -------------- | --------------------------------------------------------------------- | -------------------------------- |
| [RTK](#1-rtk)                                       | Proxy CLI      | Comprime outputs de comandos bash antes de que Claude los lea         | 60–90% tokens en bash            |
| [code-review-graph](#2-code-review-graph)           | MCP Server     | Grafo de conocimiento del codebase — Claude lee solo lo que importa   | 6.8×–49× menos tokens en reviews |
| [token-savior](#3-token-savior)                     | MCP Server     | Navegación de código por símbolo + memoria persistente entre sesiones | 97% menos tokens en navegación   |
| [caveman](#4-caveman)                               | Skill / Plugin | Claude responde como cavernícola — misma información, menos palabras  | ~75% tokens en output            |
| [claude-token-efficient](#5-claude-token-efficient) | CLAUDE.md      | Reglas en CLAUDE.md que eliminan verbosidad por defecto de Claude     | ~63% tokens en output            |

> **Nota:** El `CLAUDE.md` que genera `setup-claude-project` ya implementa las
> mismas reglas de `claude-token-efficient`. No necesitas instalar ese proyecto
> por separado — ya está integrado.

---

## 1. RTK

**Repositorio:** [github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk)  
**Tipo:** Proxy CLI (binario Rust, zero dependencias)  
**Impacto:** Actúa en los _inputs_ a Claude — comprime el output de comandos
bash antes de que lleguen al contexto.

### Qué hace

RTK se instala como un hook de bash en Claude Code. Cuando Claude ejecuta
`git status`, `cat archivo`, `npm test`, etc., RTK intercepta el output y lo
comprime eliminando ruido (líneas en blanco, paths redundantes, colores ANSI,
cabeceras repetitivas) antes de enviarlo al modelo.

**Ahorro medido en sesión de 30 minutos:**

| Comando                   | Sin RTK       | Con RTK     | Ahorro   |
| ------------------------- | ------------- | ----------- | -------- |
| `ls` / `tree` × 10        | 2,000 tokens  | 400         | −80%     |
| `cat` / `read` × 20       | 40,000 tokens | 12,000      | −70%     |
| `git diff` × 5            | 10,000 tokens | 2,500       | −75%     |
| `npm test` / `pytest` × 5 | 25,000 tokens | 2,500       | −90%     |
| **Total estimado**        | **~118,000**  | **~23,900** | **−80%** |

### Instalación

**macOS / Linux — Homebrew (recomendado):**

```bash
brew install rtk
```

**macOS / Linux — Script de instalación:**

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
```

**Linux / macOS — Cargo:**

```bash
cargo install --git https://github.com/rtk-ai/rtk
```

**Windows — Binario precompilado:** Descarga el `.zip` desde
[releases](https://github.com/rtk-ai/rtk/releases)
(`rtk-x86_64-pc-windows-msvc.zip`), extrae y coloca `rtk.exe` en un directorio
de tu `PATH`. En Windows se recomienda usar WSL para la experiencia completa.

**Verificar instalación:**

```bash
rtk --version   # ej. rtk 0.28.2
rtk gain        # muestra estadísticas de ahorro
```

### Configurar con Claude Code

```bash
rtk init -g
```

Este comando inyecta el hook de bash en la configuración de Claude Code.
Reinicia Claude Code después. A partir de ahí, todos los comandos bash que
Claude ejecute pasan automáticamente por RTK.

### Integración con setup-claude-project

RTK opera a nivel de sistema, no de proyecto — se instala una vez y funciona en
cualquier proyecto configurado con el script.

**Flujo de uso:**

```bash
# 1. Instalar RTK globalmente (una sola vez)
brew install rtk
rtk init -g

# 2. Configurar tu proyecto con el script
cd mi-proyecto
setup-claude-project

# 3. RTK ya comprime automáticamente todos los bash calls de Claude
```

> **Importante:** RTK solo actúa en llamadas al tool `Bash`. Las herramientas
> nativas de Claude Code (`Read`, `Grep`, `Glob`) no pasan por el hook. Para
> máximo ahorro en esos casos, Claude debe usar `cat`, `rg`, `find` en lugar de
> las herramientas built-in — o llamar directamente a `rtk read`, `rtk grep`,
> `rtk find`.

---

## 2. code-review-graph

**Repositorio:**
[github.com/tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph)  
**Tipo:**
MCP Server (Python, Tree-sitter, SQLite)  
**Impacto:** Actúa en _cuánto_ del codebase lee Claude — en vez de leer archivos
enteros, navega un grafo de símbolos.

### Qué hace

Parsea tu codebase con Tree-sitter y construye un grafo de nodos (funciones,
clases, imports) y aristas (llamadas, herencia, cobertura de tests). Cuando
Claude necesita entender un cambio, el grafo calcula el "blast radius" —
exactamente qué archivos se ven afectados — y Claude lee solo esos, no todo el
proyecto.

**Ahorro medido:**

- Reviews diarias: **6.8× menos tokens**
- Monorepos grandes: **hasta 49× menos tokens** (Next.js: 27,732 archivos → ~15
  leídos)
- Actualización incremental tras cada commit: **< 2 segundos** para re-indexar

**Lenguajes soportados:** 23 lenguajes + Jupyter notebooks, incluyendo Kotlin,
Python, TypeScript, JavaScript, y PowerShell.

### Instalación

**Requisito:** Python 3.10+ y `uv` (recomendado) o `pip`.

```bash
# Con pipx (recomendado — instala en entorno aislado)
pipx install code-review-graph

# Con pip
pip install code-review-graph

# Con uvx (sin instalar, ejecución directa)
uvx code-review-graph install
```

### Configurar con Claude Code

```bash
# 1. Auto-detecta Claude Code y configura el MCP + reglas
code-review-graph install --platform claude-code

# 2. Construye el grafo de tu proyecto (ejecutar en el directorio del proyecto)
cd mi-proyecto
code-review-graph build
```

El comando `install` escribe la configuración MCP en `~/.claude/settings.json` e
inyecta instrucciones en el CLAUDE.md del proyecto. El grafo inicial tarda ~10
segundos en un proyecto de 500 archivos. Después se actualiza solo con cada
cambio.

**Verificar que funciona:** Abre Claude Code en el proyecto y escribe:

```
Build the code review graph for this project
```

### Integración con setup-claude-project

`code-review-graph` complementa el skill `code-review` que el script instala.
Mientras el skill define _cómo_ Claude debe hacer el review (estructura,
prioridades), `code-review-graph` reduce _cuánto_ código Claude necesita leer
para hacerlo.

```bash
# Flujo completo post-setup:
cd mi-proyecto
setup-claude-project           # configura skills, agente code-reviewer, CLAUDE.md
code-review-graph install --platform claude-code  # configura MCP
code-review-graph build        # indexa el codebase
```

Cuando uses `@code-review`, Claude tendrá el grafo disponible para navegar el
código de forma eficiente.

---

## 3. token-savior

**Repositorio:**
[github.com/Mibayy/token-savior](https://github.com/Mibayy/token-savior)  
**Tipo:** MCP Server (Python, SQLite WAL + FTS5, 105 herramientas)  
**Impacto:** Dos capacidades en una: navegación de código por símbolo (97% menos
tokens) + memoria persistente entre sesiones.

### Qué hace

**Parte 1 — Navegación de código:**  
En vez de leer archivos completos, Claude navega por símbolo.
`find_symbol("send_message")` retorna 67 chars vs 41M chars leyendo el archivo
completo. Indexed con AST, call graph y análisis de impacto transitivo.

**Parte 2 — Memoria persistente:**  
Cada decisión, convención, bug fix y guardrail de la sesión se almacena en
SQLite con embeddings vectoriales. Al inicio de la próxima sesión, re-inyecta el
contexto relevante como delta compacto. Las observaciones tienen TTL, se
detectan contradicciones al guardar, y las más usadas se promueven
automáticamente.

**Benchmark en 60 tareas reales:**

|                  | Sin token-savior | Con token-savior |
| ---------------- | ---------------- | ---------------- |
| Score            | 67/120 (56%)     | 115/120 (96%)    |
| Chars inyectados | 1,431,624        | 234,805 (−84%)   |

### Instalación

**uvx (sin venv, sin clonar — recomendado):**

```bash
uvx token-savior-recall
```

**pip:**

```bash
pip install "token-savior-recall[mcp]"

# Con búsqueda vectorial híbrida (BM25 + embeddings):
pip install "token-savior-recall[mcp,memory-vector]"
```

**En entorno virtual (recomendado para uso estable):**

```bash
python3 -m venv ~/.local/venvs/token-savior
~/.local/venvs/token-savior/bin/pip install "token-savior-recall[mcp]"
```

### Configurar con Claude Code

Añade el MCP server a tu configuración de Claude Code. Edita
`~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "token-savior-recall": {
      "command": "/ruta/a/venv/bin/token-savior",
      "env": {
        "WORKSPACE_ROOTS": "/ruta/a/tu/proyecto",
        "TOKEN_SAVIOR_CLIENT": "claude-code"
      }
    }
  }
}
```

O con el CLI de Claude Code:

```bash
claude mcp add token-savior -- ~/.local/venvs/token-savior/bin/token-savior
```

**Variables de entorno opcionales:**

```bash
TS_VIEWER_PORT=8080          # activa web viewer en localhost:8080
TS_AUTO_EXTRACT=1            # extracción automática de observaciones post-tool-use
TS_API_KEY=sk-...            # necesario si TS_AUTO_EXTRACT=1
```

### Integración con setup-claude-project

token-savior potencia especialmente el skill `testing-tdd` — al tener memoria de
las convenciones de testing del proyecto, Claude no necesita re-descubrirlas
cada sesión. También complementa `code-review` al navegar el código por símbolo
en lugar de leer archivos completos.

```bash
# Flujo completo:
cd mi-proyecto
setup-claude-project           # skills, agentes, CLAUDE.md
# Configurar token-savior en ~/.claude/settings.json (una vez)
# A partir de ahí, toda sesión en el proyecto se beneficia de la memoria acumulada
```

---

## 4. caveman

**Repositorio:**
[github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)  
**Tipo:** Skill de Claude Code (plugin del marketplace)  
**Impacto:** Actúa en el _output_ de Claude — respuestas con la misma
información técnica pero 75% menos palabras.

### Qué hace

Hace que Claude responda como un cavernícola: elimina artículos, frases de
cortesía, introducciones, summaries finales y redundancias, manteniendo toda la
sustancia técnica.

**Antes vs después:**

| Normal (69 tokens)                                                                                                                                                                                                                                | Caveman (19 tokens)                                                                        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| "The reason your React component is re-rendering is likely because you're creating a new object reference on each render cycle. When you pass an inline object as a prop, React's shallow comparison sees it as a different object every time..." | "New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`." |

**Niveles de intensidad:**

- `/caveman lite` — frases cortas, sin artículos superfluos (~40% menos)
- `/caveman full` — modo cavernícola estándar (~75% menos) ← predeterminado
- `/caveman ultra` — mínimo absoluto de palabras (~85% menos)
- `/caveman wenyan-full` — modo texto clásico chino (modo especial)

### Instalación

**Claude Code — marketplace (recomendado):**

```bash
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman
```

**Otros agentes:**

```bash
# Cursor, Windsurf, Copilot, Cline
npx skills add JuliusBrussee/caveman

# Gemini CLI
gemini extensions install https://github.com/JuliusBrussee/caveman
```

### Integración con setup-claude-project

Caveman es un plugin global de Claude Code — se instala una vez y está
disponible en todos los proyectos configurados con el script.

El script crea `.claude/skills/` en el proyecto. Aunque caveman funciona mejor
como plugin del marketplace (tiene hooks de sesión automáticos), también puedes
copiarlo como skill local si prefieres:

```bash
# Opción A: Plugin global (recomendado)
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman

# Opción B: Skill local en el proyecto (después de ejecutar setup-claude-project)
mkdir -p .claude/skills/caveman
curl -o .claude/skills/caveman/SKILL.md \
  https://raw.githubusercontent.com/JuliusBrussee/caveman/main/skills/caveman/SKILL.md
```

**Flujo típico en una sesión de desarrollo:**

```
# Claude Code abierto en tu proyecto
/caveman            # activa modo caveman
@testing-tdd        # usa tu skill de TDD — respuestas comprimidas automáticamente
@code-review        # review en modo caveman
/caveman ultra      # máxima compresión para tareas repetitivas
```

---

## 5. claude-token-efficient

**Repositorio:**
[github.com/drona23/claude-token-efficient](https://github.com/drona23/claude-token-efficient)  
**Tipo:**
CLAUDE.md optimizado  
**Impacto:** Elimina comportamientos verbosos por defecto de Claude (~63% menos
tokens en output).

### Qué hace

Un archivo CLAUDE.md con reglas precisas que eliminan los comportamientos que
Claude tiene por defecto y que no aportan valor:

- Aperturas sycophánticas ("Sure!", "Great question!", "Happy to help!")
- Cierres innecesarios ("I hope this helps! Let me know if anything!")
- Restatement de la pregunta antes de responder
- Sugerencias no solicitadas más allá de lo pedido
- Sobreingeniería de soluciones simples

**Ahorro medido:**

| Test                      | Baseline         | Optimizado       | Reducción |
| ------------------------- | ---------------- | ---------------- | --------- |
| Explicar async/await      | 180 palabras     | 65 palabras      | −64%      |
| Code review               | 120 palabras     | 30 palabras      | −75%      |
| Corrección de alucinación | 55 palabras      | 20 palabras      | −64%      |
| **Total**                 | **465 palabras** | **170 palabras** | **−63%**  |

### Estado de integración con setup-claude-project

> **Ya está integrado.** El `CLAUDE.md` que genera `setup-claude-project`
> contiene exactamente las mismas reglas que este proyecto. No necesitas
> instalar nada adicional.

El contenido generado por el script es idéntico al `CLAUDE.md` del repositorio
`drona23/claude-token-efficient`. Si quieres explorar sus perfiles adicionales:

```bash
# Ver perfiles especializados del repositorio
git clone https://github.com/drona23/claude-token-efficient /tmp/cte

# Perfil para tareas de análisis/investigación
cat /tmp/cte/profiles/CLAUDE.analysis.md

# Perfil con reglas más agresivas (M-drona23-v8, ganó benchmark externo)
cat /tmp/cte/profiles/M-drona23-v8/CLAUDE.md
```

Puedes fusionar reglas adicionales de esos perfiles en el `CLAUDE.md` que generó
el script si tus workflows lo requieren.

---

## Flujo de instalación completo post-setup

Orden recomendado para instalar las herramientas complementarias después de
ejecutar `setup-claude-project`:

```bash
# ── PASO 0: Configurar el proyecto ─────────────────────────────────────────
cd mi-proyecto
setup-claude-project
# → Selecciona herramienta (Claude / OpenCode / ambas)
# → Selecciona stack
# → CLAUDE.md + skills + agentes creados

# ── PASO 1: RTK — compresión de bash (global, una sola vez) ────────────────
brew install rtk          # macOS
# curl -fsSL .../install.sh | sh  # Linux
rtk init -g               # configura hook en Claude Code
# Reiniciar Claude Code

# ── PASO 2: Caveman — compresión de output (global, una sola vez) ──────────
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman
# Reiniciar Claude Code

# ── PASO 3: code-review-graph — grafo del codebase (por proyecto) ──────────
pipx install code-review-graph
code-review-graph install --platform claude-code
code-review-graph build   # indexa el proyecto actual (~10s)

# ── PASO 4: token-savior — navegación + memoria (configuración global) ──────
python3 -m venv ~/.local/venvs/token-savior
~/.local/venvs/token-savior/bin/pip install "token-savior-recall[mcp]"
claude mcp add token-savior -- ~/.local/venvs/token-savior/bin/token-savior
# Reiniciar Claude Code

# ── Verificar todo ──────────────────────────────────────────────────────────
rtk gain                  # muestra ahorro acumulado de RTK
rtk --version
code-review-graph build --stats  # estadísticas del grafo
```

---

## Cómo trabajan juntas

Cada herramienta actúa en una capa diferente del pipeline de tokens:

```
┌─────────────────────────────────────────────────────────────────┐
│                    SESIÓN DE DESARROLLO                         │
│                                                                 │
│  Tu pregunta / instrucción                                      │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────────┐                                           │
│  │  CLAUDE.md      │  claude-token-efficient (ya integrado)    │
│  │  + caveman      │  → Claude responde terse, sin fluff       │
│  └────────┬────────┘                                           │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────┐                                           │
│  │  token-savior   │  Navega código por símbolo, no por archivo │
│  │  code-review-   │  Solo lee archivos relevantes del grafo   │
│  │  graph          │                                           │
│  └────────┬────────┘                                           │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────┐                                           │
│  │  Skills de tu   │  @testing-tdd, @code-review, @security    │
│  │  proyecto       │  (instalados por setup-claude-project)    │
│  └────────┬────────┘                                           │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────┐                                           │
│  │  RTK            │  Comprime outputs de bash antes de        │
│  └─────────────────┘  que lleguen al contexto de Claude        │
└─────────────────────────────────────────────────────────────────┘
```

**Resultado combinado estimado:**

- RTK: −80% en tokens de inputs por comandos bash
- code-review-graph + token-savior: −84% a −97% en navegación de código
- CLAUDE.md + caveman: −63% a −75% en tokens de output

En sesiones de desarrollo activo con comandos frecuentes y reviews de código, la
combinación puede reducir el consumo total de tokens en un **85–95%** respecto a
una sesión sin ninguna optimización.

---

## Troubleshooting

**RTK no comprime los comandos:**

```bash
rtk gain   # si muestra 0, el hook no está activo
rtk init -g --force  # reinstala el hook
# Reiniciar Claude Code completamente (no solo recargar)
```

**code-review-graph no encuentra el MCP:**

```bash
# Verificar que está en la config de Claude Code
cat ~/.claude/settings.json | grep -A5 "code-review-graph"
# Si no está, re-ejecutar:
code-review-graph install --platform claude-code
```

**token-savior no inicia:**

```bash
# Verificar la ruta del binario
~/.local/venvs/token-savior/bin/token-savior --version
# Si falla, reinstalar:
~/.local/venvs/token-savior/bin/pip install --upgrade "token-savior-recall[mcp]"
```

**caveman no se activa automáticamente al iniciar sesión:**

```bash
# Verificar instalación del plugin
claude plugin list | grep caveman
# Si no aparece:
claude plugin marketplace add JuliusBrussee/caveman
claude plugin install caveman@caveman
```

**Windows — RTK:**  
En Windows nativo, RTK tiene soporte limitado. Se recomienda usar WSL donde el
hook completo funciona de forma nativa. Extrae `rtk.exe` en un directorio de tu
PATH y ejecuta desde PowerShell o Windows Terminal (no con doble click).
