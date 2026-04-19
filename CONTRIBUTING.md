# Contributing to Setup Claude + OpenCode Developer Environment

¡Gracias por tu interés en contribuir a este proyecto! Este documento proporciona las pautas para contribuir de manera efectiva.

---

## 📋 Código de Conducta

Este proyecto se adhiere a un código de conducta que esperamos que todos los contribuyentes sigan:

- Sé respetuoso y constructivo en todas las interacciones
- Acepta críticas constructivas con gracia
- Enfócate en lo que es mejor para la comunidad
- Muestra empatía hacia otros miembros de la comunidad

---

## 🚀 Cómo Contribuir

### Reportar Bugs

Si encuentras un bug, por favor abre un [issue](https://github.com/lgzarturo/setup-claude-developer/issues) con la siguiente información:

1. **Título claro y descriptivo**
2. **Pasos para reproducir** el bug
3. **Comportamiento esperado** vs **comportamiento actual**
4. **Sistema operativo** y versión (Windows 11, macOS, Linux)
5. **Versión de PowerShell/Bash** utilizada
6. **Capturas de pantalla** (si aplica)

#### Template para reportar bugs:

```markdown
**Descripción del bug**
Una descripción clara y concisa del bug.

**Para reproducir**
Pasos para reproducir el comportamiento:
1. Ir a '...'
2. Ejecutar '....'
3. Ver el error

**Comportamiento esperado**
Una descripción clara de lo que esperabas que sucediera.

**Screenshots**
Si aplica, añade screenshots para ayudar a explicar el problema.

**Entorno (por favor completa la información):**
 - OS: [e.g., Windows 11, macOS 14, Ubuntu 22.04]
 - Shell: [e.g., PowerShell 7.4, Bash 5.2]
 - Versión del script: [e.g., v1.0.0]
```

### Sugerir Nuevas Características

Para sugerir nuevas características o mejoras:

1. Abre un [issue](https://github.com/lgzarturo/setup-claude-developer/issues) con el label `enhancement`
2. Describe la característica y el problema que resuelve
3. Explica por qué sería útil para otros usuarios
4. Si es posible, incluye ejemplos de uso

### Proponer Nuevos Stacks

Para proponer un nuevo stack tecnológico:

1. Abre un [issue](https://github.com/lgzarturo/setup-claude-developer/issues) con el label `new-stack`
2. Incluye la siguiente información:
   - **Nombre del stack**: Ej., "Ruby on Rails"
   - **Versión recomendada**: Ej., "Rails 7+"
   - **Herramientas clave**: Ej., "RSpec, Capybara, FactoryBot"
   - **Casos de uso comunes**: Ej., "API REST, MVC tradicional"
   - **Ejemplo de skill**: Un borrador del contenido del skill

### Contribuir con Código

#### Configuración del Entorno de Desarrollo

1. **Fork** el repositorio
2. **Clona** tu fork localmente:
   ```bash
   git clone https://github.com/tu-usuario/setup-claude-developer.git
   cd setup-claude-developer
   ```
3. Crea una **rama** para tu contribución:
   ```bash
   git checkout -b feature/nueva-caracteristica
   # o
   git checkout -b fix/arreglo-bug
   ```

#### Flujo de Trabajo

1. Realiza tus cambios siguiendo las [Convenciones de Código](#convenciones-de-código)
2. **Prueba** tus cambios en diferentes sistemas operativos si es posible
3. **Documenta** cualquier cambio en el README.md si es necesario
4. Haz **commit** de tus cambios:
   ```bash
   git add .
   git commit -m "feat: añade soporte para nuevo stack XYZ"
   ```
5. **Push** a tu fork:
   ```bash
   git push origin feature/nueva-caracteristica
   ```
6. Abre un **Pull Request** desde tu fork al repositorio original

#### Convenciones de Código

##### Scripts Bash (`setup.sh`)

- Usa `#!/bin/bash` en la primera línea
- Sigue el estilo de código existente
- Usa comentarios descriptivos con `# === SECCIÓN ===`
- Prefiere `printf` sobre `echo` para mayor portabilidad
- Usa comillas dobles para variables: `"$variable"`
- Indentación: 2 espacios

Ejemplo:

```bash
#!/bin/bash
# ================================================
# Sección descriptiva
# ================================================

my_function() {
  local var="$1"
  printf '%s\n' "$var"
}
```

##### Scripts PowerShell (`setup.ps1`)

- Usa verbos de PowerShell aprobados (Get, Set, New, etc.)
- Nombra funciones con PascalCase: `Create-Skill`
- Usa nombres descriptivos para variables: `$skillName`
- Indentación: 4 espacios
- Usa comentarios con `#` para líneas simples

Ejemplo:

```powershell
function Create-Skill {
    param([string]$name, [string]$content)

    $skillPath = ".claude/skills/$name"
    New-Item -ItemType Directory -Force -Path $skillPath
    Set-Content -Path "$skillPath/SKILL.md" -Value $content -Encoding UTF8
}
```

##### Skills y Archivos Markdown

- Usa YAML frontmatter en todos los skills
- Mantén la estructura consistente: `name`, `description`, `license`
- Usa secciones claras: `## Reglas obligatorias`, `## Cuándo usarme`
- Licencia siempre MIT (a menos que se especifique lo contrario)

Ejemplo:

```markdown
---
name: mi-skill
description: Descripción clara y concisa
license: MIT
---

## Reglas obligatorias
- Regla 1
- Regla 2

## Cuándo usarme
- "Frase de activación 1"
```

#### Mensajes de Commit

Seguimos una versión simplificada de [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nueva característica
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Cambios de formato (espacios, indentación)
- `refactor:` Refactorización de código
- `test:` Añadir o corregir tests
- `chore:` Tareas de mantenimiento

Ejemplos:

```
feat: añade soporte para Ruby on Rails
fix: corrige bug en selección múltiple de stacks
docs: actualiza README con instrucciones de Windows
refactor: simplifica función create_skill en bash
```

---

## 🔄 Sincronización entre Scripts

Una regla importante de este proyecto es mantener los dos scripts (`setup.sh` y `setup.ps1`) **sincronizados**. Si haces cambios en uno, debes aplicarlos al otro.

### Checklist de Sincronización

- [ ] Los skills universales son idénticos en ambos scripts
- [ ] Los contenidos de los stacks son idénticos
- [ ] La estructura de carpetas es la misma
- [ ] Los mensajes de salida son equivalentes
- [ ] Los archivos generados (CLAUDE.md, agentes, comandos) son idénticos

---

## 📝 Documentación

Cuando añadas nuevas características, actualiza:

1. **README.md**: Instrucciones de uso
2. **CHANGELOG.md**: Registro de cambios (si aplica)
3. **Comentarios en el código**: Explicación de funciones complejas

---

## ✅ Checklist para Pull Requests

Antes de enviar tu PR, verifica:

- [ ] El código sigue las convenciones del proyecto
- [ ] He probado los cambios en al menos un sistema operativo
- [ ] Los dos scripts (bash y PowerShell) están sincronizados
- [ ] La documentación está actualizada
- [ ] Los mensajes de commit son claros y descriptivos
- [ ] No hay archivos innecesarios incluidos (logs, temporales, etc.)

---

## 🙋 Preguntas Frecuentes

### ¿Puedo contribuir aunque no domine PowerShell o Bash?

¡Sí! Puedes contribuir con:

- Documentación
- Reportes de bugs detallados
- Ideas para nuevos features
- Testing de los scripts en diferentes sistemas

### ¿Cuánto tiempo tardan en revisar los PRs?

Intentamos revisar los PRs dentro de 3-5 días hábiles. PRs más grandes pueden requerir más tiempo.

### ¿Puedo añadir mi propio stack si es muy específico?

Prefierimos stacks que tengan uso generalizado. Para stacks muy específicos, considera crear un fork o mantenerlo en tu propio repositorio.

---

## 📞 Contacto

- **GitHub Issues**: Para bugs y features
- **GitHub Discussions**: Para preguntas y discusiones generales
- **Email**: Puedes encontrar el contacto en el perfil de [Arturo López](https://github.com/lgzarturo)

---

## 🎉 Reconocimientos

Todas las contribuciones serán reconocidas en el archivo [AUTHORS](AUTHORS) o en la sección de contribuyentes del README.

¡Gracias por hacer de este proyecto algo mejor! 🚀
