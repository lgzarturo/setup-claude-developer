# Setup Claude Project

Scripts interactivos para configurar automáticamente un entorno de desarrollo
con **Claude Code** y/o **OpenCode** en cualquier proyecto. Generan skills,
agentes y comandos personalizados según el stack tecnológico que elijas.

---

## Inicio Rápido (Linux/macOS)

```bash
# 1. Clona este repositorio
git clone https://github.com/tu-usuario/setup-claude-developer.git
cd setup-claude-developer

# 2. Instala el script globalmente
make install

# 3. Ve a cualquier proyecto y configúralo
cd /ruta/a/tu/proyecto
setup-claude-project
```

> Si `setup-claude-project` no se reconoce después de instalar, añade
> `~/.local/bin` a tu PATH:
>
> ```bash
> echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
> ```

---

## Inicio Rápido (Windows)

```powershell
# Descarga el script en el directorio de tu proyecto
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tu-usuario/setup-claude-developer/main/setup-claude-project.ps1" -OutFile "setup-claude-project.ps1"

# Configura permisos si es necesario
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Ejecuta
.\setup-claude-project.ps1
```

---

## Comandos Make

El `Makefile` proporciona comandos convenientes para gestionar el script:

```
make install     Instala el script globalmente en ~/.local/bin
make run         Ejecuta el script en el directorio actual (sin instalar)
make update      Actualiza el script instalado con la versión actual del repo
make uninstall   Elimina el script instalado
make check       Verifica dependencias (bash, git)
make status      Muestra si el script está instalado y en PATH
make help        Muestra esta ayuda
```

### Guía de gestión del script

#### Instalación global

La instalación global te permite ejecutar `setup-claude-project` desde cualquier
directorio:

```bash
# Desde el directorio del repositorio clonado
make install

# Verifica la instalación
make status
```

#### Ejecución sin instalar

Si prefieres no instalarlo globalmente, puedes ejecutarlo directamente:

```bash
# Desde el directorio del repositorio
make run

# O directamente con bash
bash /ruta/al/setup-claude-project.sh
```

#### Actualización

Cuando haya una nueva versión del script:

```bash
# Actualiza el script instalado con la versión actual del repo
make update
```

#### Desinstalación

Para eliminar el script instalado:

```bash
make uninstall
```

---

## Qué genera el script

Al ejecutarlo, el script te hace tres preguntas y genera la estructura
correspondiente:

### 1. Herramienta a configurar

```
¿Qué herramienta quieres configurar?
1. Solo Claude
2. Solo OpenCode
3. Claude + OpenCode
```

### 2. Stack tecnológico

```
1. Spring Boot + Kotlin
2. Python + UV + Django
3. Python + FastAPI
4. Next.js + TypeScript
5. Astro
6. Todos los stacks (recomendado)
```

### 3. Skills oficiales de Spring Boot (solo si seleccionas stack 1 o 6)

```
¿Instalar las 18 skills oficiales de Spring Boot? (s/N)
```

Clona e instala automáticamente el paquete de skills desde el repositorio
oficial.

---

## Estructura generada

```
tu-proyecto/
├── CLAUDE.md                        # Reglas base (solo si configuraste Claude)
├── .claude/                         # Configuración Claude Code
│   ├── skills/
│   │   ├── testing-tdd/SKILL.md
│   │   ├── security/SKILL.md
│   │   ├── code-review/SKILL.md
│   │   ├── testing-coverage/SKILL.md
│   │   └── <tu-stack>/SKILL.md
│   ├── agents/code-reviewer.md
│   └── commands/run-all-tests.md
└── .opencode/                       # Configuración OpenCode (idéntica a .claude/)
```

### Skills universales (siempre incluidos)

| Skill              | Propósito                                                              |
| ------------------ | ---------------------------------------------------------------------- |
| `testing-tdd`      | Ciclo TDD (Red-Green-Refactor), fixtures, mocks                        |
| `security`         | OWASP Top 10, autenticación segura, headers                            |
| `code-review`      | Revisiones estructuradas con prioridad seguridad > tests > performance |
| `testing-coverage` | Cobertura mínima 80% + CI con GitHub Actions                           |

### Skills por stack

| #   | Stack                | Skill                                                         |
| --- | -------------------- | ------------------------------------------------------------- |
| 1   | Spring Boot + Kotlin | `spring-boot-kotlin-rest` + opcionalmente 18 skills oficiales |
| 2   | Python + Django + UV | `python-django-uv`                                            |
| 3   | Python + FastAPI     | `python-fastapi`                                              |
| 4   | Next.js + TypeScript | `nextjs-typescript`                                           |
| 5   | Astro                | `astro`                                                       |

---

## Cómo usar los skills instalados

Reinicia Claude Code u OpenCode después de instalar. Luego:

```
# Usar skills con @
@testing-tdd Escribe tests para la función calculateTotal
@security Revisa este endpoint por vulnerabilidades
@code-review Analiza este archivo
@spring-boot-kotlin-rest Crea un CRUD completo para Order

# Usar comandos con /
/run-all-tests
```

---

## Requisitos

| Sistema     | Requisito                                              |
| ----------- | ------------------------------------------------------ |
| Linux/macOS | Bash, `make`, `git` (para 18 skills de Spring Boot)    |
| Windows     | PowerShell 5.1+, `git` (para 18 skills de Spring Boot) |

**Recomendado:** [Claude Code](https://claude.ai/code) y/o
[OpenCode](https://opencode.ai) instalados.

---

## Recomendaciones para Desarrolladores

> **Nota importante:** Para optimizar tu flujo de trabajo y reducir el consumo de
tokens, te recomendamos leer el documento
[docs/04-recomendaciones.md](docs/04-recomendaciones.md). Este documento
complementario incluye herramientas y configuraciones adicionales que mejoran
significativamente el performance:

### Herramientas recomendadas

| Herramienta | Beneficio | Ahorro de tokens |
|-------------|-----------|------------------|
| **RTK** | Compresión de outputs de bash | 60-90% |
| **code-review-graph** | Grafo de conocimiento del codebase | 6.8x-49x menos tokens |
| **token-savior** | Navegación por símbolo + memoria persistente | 97% menos tokens |
| **caveman** | Respuestas concisas de Claude | ~75% menos tokens |
| **CLAUDE.md optimizado** | Reglas anti-verbosidad (ya incluido) | ~63% menos tokens |

### Por qué leer las recomendaciones

El documento de recomendaciones te ayudará a:

1. **Reducir costos:** Menos tokens = menos costo por sesión de desarrollo
2. **Aumentar velocidad:** Claude procesa contexto más rápido con menos tokens
3. **Mantener contexto:** Memoria persistente entre sesiones
4. **Mejorar navegación:** Encontrar código relevante sin leer archivos completos
5. **Respuestas directas:** Eliminar verbosidad innecesaria en las respuestas

### Flujo recomendado

```bash
# 1. Configura tu proyecto con este script
cd mi-proyecto
setup-claude-project

# 2. Lee y aplica las recomendaciones adicionales
# Ver: docs/04-recomendaciones.md
```

> **Tip:** Las recomendaciones son especialmente valiosas si trabajas con
proyectos grandes o sesiones de desarrollo extensas. La combinación de todas las
herramientas puede reducir el consumo de tokens en un **85-95%**.

---

## Troubleshooting

**`setup-claude-project`: command not found**

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

**Windows: "ejecución de scripts deshabilitada"**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# O con bypass puntual:
PowerShell -ExecutionPolicy Bypass -File setup-claude-project.ps1
```

**Los skills no aparecen en Claude Code**

1. Verifica que `.claude/skills/` tiene contenido: `ls .claude/skills/`
2. Reinicia Claude Code completamente

**Error al clonar las 18 skills de Spring Boot**

- Verifica conexión a internet y que `git` esté instalado (`git --version`)

---

## Licencia

Este proyecto está licenciado bajo la [MIT License](LICENSE).

Copyright (c) 2026 Arturo López
