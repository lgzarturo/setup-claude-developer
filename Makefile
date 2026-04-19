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
# update — actualiza el script instalado con la versión actual del repo.
# Equivalente a reinstalar sobre la versión anterior.
# -----------------------------------------------------------------------------
.PHONY: update
update: ## Actualiza el script instalado con la versión actual del repo
	@test -f $(INSTALL_PATH) || { \
		printf "$(YELLOW)Script no instalado. Usa 'make install' primero.$(RESET)\n"; exit 1; }
	@cp $(SCRIPT_SRC) $(INSTALL_PATH)
	@chmod +x $(INSTALL_PATH)
	@printf "$(GREEN)✓ Script actualizado en $(INSTALL_PATH)$(RESET)\n"

# -----------------------------------------------------------------------------
# status — muestra si el script está instalado y su versión de PATH
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
