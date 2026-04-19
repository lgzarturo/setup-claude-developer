# =============================================================================
# Setup Claude Project - Makefile
# =============================================================================
# Instala setup-claude-project globalmente en ~/.local/bin para que puedas
# ejecutarlo desde cualquier directorio de proyecto con un solo comando.
#
# Uso rápido:
#   make install          → instala el script globalmente
#   make run              → ejecuta el script en el directorio actual
#   make uninstall        → desinstala el script
#   make check            → verifica dependencias
# =============================================================================

SCRIPT_NAME  := setup-claude-project
SCRIPT_SRC   := $(SCRIPT_NAME).sh
INSTALL_DIR  := $(HOME)/.local/bin
INSTALL_PATH := $(INSTALL_DIR)/$(SCRIPT_NAME)
VERSION_FILE := VERSION

# Colores para output
CYAN  := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED   := \033[31m
RESET := \033[0m

.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# help — muestra este menú (target por defecto)
# -----------------------------------------------------------------------------
.PHONY: help
help:
	@echo ""
	@echo "$(CYAN)Setup Claude Project$(RESET)"
	@echo "─────────────────────────────────────────────"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-14s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "  Instalado en: $(INSTALL_PATH)"
	@echo ""

# -----------------------------------------------------------------------------
# check — verifica que bash y git estén disponibles
# git es necesario para instalar las 18 skills oficiales de Spring Boot.
# -----------------------------------------------------------------------------
.PHONY: check
check: ## Verifica dependencias (bash, git)
	@printf "$(CYAN)Verificando dependencias...$(RESET)\n"
	@command -v bash >/dev/null 2>&1 || { \
		printf "$(RED)ERROR: bash no encontrado$(RESET)\n"; exit 1; }
	@printf "  bash   $(GREEN)OK$(RESET)\n"
	@command -v git >/dev/null 2>&1 \
		&& printf "  git    $(GREEN)OK$(RESET)\n" \
		|| printf "  git    $(YELLOW)NO ENCONTRADO$(RESET) (necesario solo para las 18 skills de Spring Boot)\n"

# -----------------------------------------------------------------------------
# install — copia el script a ~/.local/bin y lo hace ejecutable.
# Después de instalar, "setup-claude-project" está disponible en cualquier
# directorio sin necesidad de rutas absolutas.
# -----------------------------------------------------------------------------
.PHONY: install
install: check ## Instala el script globalmente en ~/.local/bin
	@test -f $(SCRIPT_SRC) || { \
		printf "$(RED)ERROR: $(SCRIPT_SRC) no encontrado. Ejecuta 'make install' desde el directorio del repo.$(RESET)\n"; \
		exit 1; }
	@mkdir -p $(INSTALL_DIR)
	@cp $(SCRIPT_SRC) $(INSTALL_PATH)
	@chmod +x $(INSTALL_PATH)
	@printf "$(GREEN)✓ Instalado en $(INSTALL_PATH)$(RESET)\n"
	@printf "\n$(CYAN)Uso:$(RESET)\n"
	@printf "  cd /ruta/a/tu/proyecto\n"
	@printf "  setup-claude-project\n\n"
	@if ! echo "$$PATH" | grep -q "$(INSTALL_DIR)"; then \
		printf "$(YELLOW)AVISO: $(INSTALL_DIR) no está en tu PATH.$(RESET)\n"; \
		printf "Añade esta línea a tu ~/.bashrc o ~/.zshrc:\n\n"; \
		printf "  export PATH=\"\$$HOME/.local/bin:\$$PATH\"\n\n"; \
		printf "Luego recarga tu shell con: source ~/.bashrc\n\n"; \
	fi

# -----------------------------------------------------------------------------
# uninstall — elimina el script instalado de ~/.local/bin
# -----------------------------------------------------------------------------
.PHONY: uninstall
uninstall: ## Desinstala el script de ~/.local/bin
	@test -f $(INSTALL_PATH) || { \
		printf "$(YELLOW)No hay nada que desinstalar ($(INSTALL_PATH) no existe)$(RESET)\n"; \
		exit 0; }
	@rm -f $(INSTALL_PATH)
	@printf "$(GREEN)✓ Eliminado $(INSTALL_PATH)$(RESET)\n"

# -----------------------------------------------------------------------------
# run — ejecuta el script directamente en el directorio actual
# sin necesidad de instalarlo primero. Útil para uso puntual o pruebas.
# -----------------------------------------------------------------------------
.PHONY: run
run: ## Ejecuta el script en el directorio actual (sin instalar)
	@test -f $(SCRIPT_SRC) || { \
		printf "$(RED)ERROR: $(SCRIPT_SRC) no encontrado$(RESET)\n"; exit 1; }
	@bash $(SCRIPT_SRC)

# -----------------------------------------------------------------------------
# update — fuerza la actualización sin verificar versiones.
# Equivalente a reinstalar sobre la versión anterior (siempre sobreescribe).
# Para actualización inteligente usa: make upgrade
# -----------------------------------------------------------------------------
.PHONY: update
update: ## Fuerza actualización del script instalado (sin verificar versión)
	@test -f $(INSTALL_PATH) || { \
		printf "$(YELLOW)Script no instalado. Usa 'make install' primero.$(RESET)\n"; exit 1; }
	@cp $(SCRIPT_SRC) $(INSTALL_PATH)
	@chmod +x $(INSTALL_PATH)
	@printf "$(GREEN)✓ Script actualizado en $(INSTALL_PATH)$(RESET)\n"

# -----------------------------------------------------------------------------
# version — muestra la versión del repo y la del script instalado.
# Indica si hay una actualización disponible o si ya está al día.
#
# Fuente de verdad:
#   Repo     → archivo VERSION en la raíz del repositorio
#   Instalado → línea "# Version: X.Y.Z" en el binario instalado
# -----------------------------------------------------------------------------
.PHONY: version
version: ## Muestra versión del repo e instalada, e indica si hay actualización
	@REPO_VER=$$(cat $(VERSION_FILE) 2>/dev/null || echo "desconocida"); \
	if test -f $(INSTALL_PATH); then \
		INST_VER=$$(grep -m1 '^# Version:' $(INSTALL_PATH) | sed 's/# Version: *//'); \
		INST_VER=$${INST_VER:-desconocida}; \
	else \
		INST_VER="no instalado"; \
	fi; \
	printf "$(CYAN)Versiones:$(RESET)\n"; \
	printf "  Repositorio: $(GREEN)v$$REPO_VER$(RESET)\n"; \
	printf "  Instalado:   "; \
	if [ "$$INST_VER" = "no instalado" ]; then \
		printf "$(RED)no instalado$(RESET)\n"; \
	else \
		printf "$(GREEN)v$$INST_VER$(RESET)\n"; \
	fi; \
	printf "\n"; \
	if [ "$$INST_VER" = "no instalado" ]; then \
		printf "  $(YELLOW)→ Ejecuta 'make install' para instalar v$$REPO_VER$(RESET)\n\n"; \
	elif [ "$$REPO_VER" = "$$INST_VER" ]; then \
		printf "  $(GREEN)✓ Ya estás en la última versión$(RESET)\n\n"; \
	else \
		LATEST=$$(printf '%s\n' "$$REPO_VER" "$$INST_VER" | sort -V | tail -n1); \
		if [ "$$LATEST" = "$$REPO_VER" ]; then \
			printf "  $(YELLOW)↑ Actualización disponible: v$$INST_VER → v$$REPO_VER$(RESET)\n"; \
			printf "  $(CYAN)  Ejecuta 'make upgrade' para actualizar$(RESET)\n\n"; \
		else \
			printf "  $(YELLOW)⚠ La versión instalada (v$$INST_VER) es más nueva que el repo (v$$REPO_VER)$(RESET)\n\n"; \
		fi; \
	fi

# -----------------------------------------------------------------------------
# upgrade — actualiza solo si la versión del repo es superior a la instalada.
# Compara versiones semánticas (X.Y.Z) usando sort -V.
#
#   v1.0.0 → v1.0.1  → actualiza ✓
#   v1.0.1 → v1.0.1  → ya actualizado, no hace nada
#   v1.0.2 → v1.0.1  → versión instalada más nueva, aborta con aviso
# -----------------------------------------------------------------------------
.PHONY: upgrade
upgrade: ## Actualiza solo si hay versión superior disponible en el repo
	@test -f $(SCRIPT_SRC) || { \
		printf "$(RED)ERROR: $(SCRIPT_SRC) no encontrado$(RESET)\n"; exit 1; }
	@test -f $(INSTALL_PATH) || { \
		printf "$(YELLOW)Script no instalado. Usa 'make install' primero.$(RESET)\n"; exit 1; }
	@REPO_VER=$$(cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0"); \
	INST_VER=$$(grep -m1 '^# Version:' $(INSTALL_PATH) | sed 's/# Version: *//'); \
	INST_VER=$${INST_VER:-0.0.0}; \
	printf "$(CYAN)Verificando versiones...$(RESET)\n"; \
	printf "  Instalada:   v$$INST_VER\n"; \
	printf "  Disponible:  v$$REPO_VER\n\n"; \
	if [ "$$REPO_VER" = "$$INST_VER" ]; then \
		printf "$(GREEN)✓ Ya estás en la última versión (v$$INST_VER). No es necesario actualizar.$(RESET)\n\n"; \
		exit 0; \
	fi; \
	LATEST=$$(printf '%s\n' "$$REPO_VER" "$$INST_VER" | sort -V | tail -n1); \
	if [ "$$LATEST" != "$$REPO_VER" ]; then \
		printf "$(YELLOW)⚠ La versión instalada (v$$INST_VER) ya es más reciente que el repo (v$$REPO_VER).$(RESET)\n"; \
		printf "$(YELLOW)  Usa 'make update' si de todos modos quieres sobreescribir.$(RESET)\n\n"; \
		exit 1; \
	fi; \
	cp $(SCRIPT_SRC) $(INSTALL_PATH); \
	chmod +x $(INSTALL_PATH); \
	printf "$(GREEN)✓ Actualizado: v$$INST_VER → v$$REPO_VER$(RESET)\n\n"

# -----------------------------------------------------------------------------
# status — muestra si el script está instalado y disponible en PATH
# -----------------------------------------------------------------------------
.PHONY: status
status: ## Muestra si el script está instalado y disponible en PATH
	@printf "$(CYAN)Estado de instalación:$(RESET)\n"
	@test -f $(INSTALL_PATH) \
		&& printf "  Archivo:    $(GREEN)$(INSTALL_PATH)$(RESET)\n" \
		|| printf "  Archivo:    $(RED)No instalado$(RESET)\n"
	@command -v $(SCRIPT_NAME) >/dev/null 2>&1 \
		&& printf "  En PATH:    $(GREEN)Sí — $$(command -v $(SCRIPT_NAME))$(RESET)\n" \
		|| printf "  En PATH:    $(YELLOW)No (revisa tu PATH o abre nueva terminal)$(RESET)\n"
