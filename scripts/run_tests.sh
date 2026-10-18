#!/usr/bin/env bash
set -e

echo "================================================================================"
echo "  🚀 RUNNING AURA PURCHASE ORDERS MICROSERVICE TEST SUITE"
echo "================================================================================"

echo ""
echo ">> [1/3] Running Domain Core Unit Tests..."
aurac run tests/domain_test.aura

echo ""
echo ">> [2/3] Running Application Layer Use Case Tests..."
aurac run tests/usecase_test.aura

echo ""
echo ">> [3/3] Running PostgreSQL Integration Tests..."
aurac run tests/integration_test.aura

echo ""
echo "================================================================================"
echo "  🎉 ALL 3 TEST SUITES PASSED SUCCESSFULLY!"
echo "================================================================================"
