# ==============================================================================
# Aura Purchase Orders Microservice - Makefile
# ==============================================================================

.PHONY: all run test test-domain test-usecase test-integration check clean help

all: check test

# Run HTTP Microservice
run:
	aurac run cmd/server/main.aura

# Type-check codebase
check:
	@echo "Checking syntax and types..."
	aurac check cmd/server/main.aura
	aurac check tests/domain_test.aura
	aurac check tests/usecase_test.aura
	aurac check tests/integration_test.aura
	@echo "✓ All files passed type checking."

# Run all automated test suites
test:
	./scripts/run_tests.sh

# Run individual test suites
test-domain:
	aurac run tests/domain_test.aura

test-usecase:
	aurac run tests/usecase_test.aura

test-integration:
	aurac run tests/integration_test.aura

# Clean temporary files
clean:
	rm -rf *.tmp.mjs *.tmp.go test_bin

help:
	@echo "Available make targets:"
	@echo "  make run              Start HTTP microservice on port 8085"
	@echo "  make test             Execute all 3 test suites (domain, usecase, integration)"
	@echo "  make test-domain      Execute pure domain unit tests"
	@echo "  make test-usecase     Execute application use case tests"
	@echo "  make test-integration Execute PostgreSQL integration tests"
	@echo "  make check            Run Aura compiler type checking on all modules"
	@echo "  make clean            Remove build artifacts and temporary files"
