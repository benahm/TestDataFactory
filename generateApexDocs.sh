#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCUMENTATION_DIR="$ROOT_DIR/apexdocs"

echo "Generating ApexDocs markdown..."
npx apexdocs markdown \
  -s force-app/main/default/classes/TestDataFactory.cls \
  -t "$DOCUMENTATION_DIR" \
  --scope global public protected private testMethod

echo "Docs refreshed for Docsify (entry point: apexdocs/index.html)."
echo "Documentation generated in $DOCUMENTATION_DIR."
