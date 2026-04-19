## Descripción

Resumen de los cambios y qué issue resuelve. Incluye motivación y contexto relevante.

Cierra # (issue)

## Tipo de cambio

- [ ] Corrección de bug (cambio no disruptivo que resuelve un problema)
- [ ] Nueva funcionalidad (cambio no disruptivo que agrega algo)
- [ ] Soporte para nuevo stack
- [ ] Cambio disruptivo (breaking change — afecta funcionalidad existente)
- [ ] Actualización de documentación
- [ ] Refactorización
- [ ] Mejora de rendimiento

## Cambios realizados

### Archivos modificados

- `archivo1` — descripción del cambio
- `archivo2` — descripción del cambio

### Descripción detallada

Explica los cambios con el nivel de detalle necesario para que el revisor los entienda.

## Testing

### Entorno de prueba

**Sistema operativo:**

- [ ] Windows 11
- [ ] Windows 10
- [ ] macOS
- [ ] Linux

**Shell:**

- [ ] PowerShell
- [ ] Bash
- [ ] Otro: \_\_

### Pruebas realizadas

- [ ] El script corre sin errores en entorno limpio
- [ ] El script maneja correctamente instalaciones existentes
- [ ] Todos los archivos generados se crean correctamente
- [ ] Los skills tienen el formato correcto
- [ ] Probado en múltiples stacks (si aplica)
- [ ] Probado con las tres opciones de herramienta (solo Claude / solo OpenCode / ambas)

### Salida de las pruebas

```
Pega aquí la salida relevante de las pruebas
```

## Checklist

### Calidad del código

- [ ] Revisé mi propio código antes de solicitar revisión
- [ ] Mi código no genera nuevas advertencias en shellcheck ni PSScriptAnalyzer
- [ ] Comenté el código en las partes no evidentes

### Sincronización (obligatorio para cambios en los scripts)

- [ ] Los cambios están sincronizados entre `setup-claude-project.sh` y `setup-claude-project.ps1`
- [ ] Ambos scripts producen la misma estructura de archivos
- [ ] El contenido de los skills es idéntico en ambos scripts

### Documentación

- [ ] Actualicé `README.md` si es necesario
- [ ] Actualicé `CHANGELOG.md` si es necesario

### Commits

- [ ] Mis commits siguen el formato convencional (`feat:`, `fix:`, `docs:`, etc.)
- [ ] Hice squash de commits intermedios si fue necesario

## Notas adicionales

Limitaciones conocidas, mejoras futuras o cualquier otro detalle relevante para el revisor.

## Issues / PRs relacionados

- Relacionado con #
- Depende de #
