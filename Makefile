SCRIPT_PATH = $(DIST)/$(CMD)/$(SERVICE).sh

.PHONY: run
run:
    @if [ -z "$(DIST)" ]; then \
        echo "DIST required param! Example: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -z "$(CMD)" ]; then \
        echo "CMD required param! Example: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -z "$(SERVICE)" ]; then \
        echo "SERVICE required param! Example: make run DIST=ubuntu CMD=install SERVICE=prometheus"; exit 1; \
    fi
    @if [ -f "$(SCRIPT_PATH)" ]; then \
        chmod +x "$(SCRIPT_PATH)"; \
        ./$(SCRIPT_PATH); \
    else \
        echo "Script $(SCRIPT_PATH) not found!"; \
        exit 1; \
    fi