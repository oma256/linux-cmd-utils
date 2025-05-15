SCRIPT_PATH = $(DIST)/$(CMD)/$(SERVICE).sh

.PHONY: run
run:
    @if [ -z "$(DIST)" ]; then \
        echo "DIST не задан! Пример: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -z "$(CMD)" ]; then \
        echo "CMD не задан! Пример: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -z "$(SERVICE)" ]; then \
        echo "SERVICE не задан! Пример: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -f "$(SCRIPT_PATH)" ]; then \
        chmod +x "$(SCRIPT_PATH)"; \
        ./$(SCRIPT_PATH); \
    else \
        echo "Скрипт $(SCRIPT_PATH) не найден!"; \
        exit 1; \
    fi