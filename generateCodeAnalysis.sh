#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_JSON="$ROOT_DIR/code-analyzer-results.json"
OUTPUT_HTML="$ROOT_DIR/code-analyzer-report.html"

if ! command -v sf >/dev/null 2>&1; then
  echo "The Salesforce CLI (sf) is required but not found in PATH." >&2
  exit 1
fi

echo "Running Salesforce Code Analyzer with Recommended rules..."
sf code-analyzer run \
  --workspace "$ROOT_DIR" \
  --target "$ROOT_DIR/force-app" \
  --rule-selector Recommended \
  --output-file "$OUTPUT_JSON" \
  --output-file "$OUTPUT_HTML" \
  --view table

echo "Code Analyzer results written to:"
echo "  • $OUTPUT_JSON"
echo "  • $OUTPUT_HTML"
