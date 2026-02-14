#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.githooks"

git -C "$ROOT_DIR" config core.hooksPath "$HOOKS_DIR"
echo "hooksPath -> $HOOKS_DIR"
