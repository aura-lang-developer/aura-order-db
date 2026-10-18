# ==============================================================================
# Aura ORM - Makefile
# ==============================================================================

.PHONY: all test test-builder test-schema check fmt clean help

all: check test

# Run all test suites
test: test-builder test-schema

test-builder:
	aurac run tests/builder_test.aura

test-schema:
	aurac run tests/schema_test.aura

# Type-check all modules
check:
	@echo "Checking Aura syntax and types..."
	aurac check src/dialect/dialect.aura
	aurac check src/builder/query.aura
	aurac check src/schema/schema.aura
	aurac check src/orm.aura
	aurac check tests/builder_test.aura
	aurac check tests/schema_test.aura
	@echo "✓ All files passed type checking."

# Code formatting
fmt:
	aurac fmt -w src tests

# Clean temporary files
clean:
	rm -rf *.tmp.mjs *.tmp.go *.tmp.mjs.map test_bin

help:
	@echo "Available make targets:"
	@echo "  make test          Run all unit tests"
	@echo "  make test-builder  Run query builder tests"
	@echo "  make test-schema   Run schema and DDL migration tests"
	@echo "  make check         Type-check all source and test files"
	@echo "  make fmt           Format source code"
	@echo "  make clean         Remove temporary build files"
