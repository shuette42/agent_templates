#!/usr/bin/env bash
set -euo pipefail

# Prueft interne Markdown-Links in getrackten *.md-Dateien.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Fehlende Abhaengigkeit: $1" >&2
    exit 1
  fi
}

require_cmd git
require_cmd rg
require_cmd sed
require_cmd tr

slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/`//g; s/&amp;/ /g; s/[^a-z0-9[:space:]-]//g; s/[[:space:]]+/-/g; s/^-+//; s/-+$//; s/--+/-/g'
}

build_anchor_list() {
  local file="$1"
  sed -nE 's/^[[:space:]]{0,3}#{1,6}[[:space:]]+(.+)$/\1/p' "$file" \
    | while IFS= read -r heading; do
        slugify "$heading"
      done
}

errors=0

while IFS= read -r md_file; do
  while IFS=: read -r line_no raw_link; do
    link="$raw_link"

    link="$(echo "$link" | sed -E 's/[[:space:]]+"[^"]*"$//')"
    link="${link#<}"
    link="${link%>}"

    case "$link" in
      http://*|https://*|mailto:*|tel:*|data:*|javascript:*|[#]*)
        continue
        ;;
    esac

    target_path="$link"
    anchor=""
    if [[ "$link" == *"#"* ]]; then
      target_path="${link%%#*}"
      anchor="${link#*#}"
    fi

    if [[ -z "$target_path" ]]; then
      target_file="$md_file"
    elif [[ "$target_path" == /* ]]; then
      target_file="$target_path"
    else
      target_file="$(cd "$(dirname "$md_file")" && cd "$(dirname "$target_path")" 2>/dev/null && pwd)/$(basename "$target_path")"
    fi

    if [[ ! -f "$target_file" ]]; then
      echo "BROKEN FILE: $md_file:$line_no -> $link" >&2
      errors=$((errors + 1))
      continue
    fi

    if [[ -n "$anchor" ]]; then
      anchors_tmp="$(mktemp)"
      build_anchor_list "$target_file" > "$anchors_tmp"
      if ! rg -qx -- "$anchor" "$anchors_tmp"; then
        echo "BROKEN ANCHOR: $md_file:$line_no -> $link" >&2
        errors=$((errors + 1))
      fi
      rm -f "$anchors_tmp"
    fi
  done < <(
    rg -n --no-heading -o '\[[^]]+\]\(([^)]+)\)' "$md_file" \
      | while IFS= read -r match_line; do
          line_no="${match_line%%:*}"
          raw_match="${match_line#*:}"
          raw_link="$(echo "$raw_match" | sed -E 's/^\[[^]]+\]\(([^)]+)\)$/\1/')"
          echo "$line_no:$raw_link"
        done
  )
done < <(git ls-files '*.md')

if [[ $errors -gt 0 ]]; then
  echo
  echo "Docs-Link-Check fehlgeschlagen: $errors Problem(e)." >&2
  exit 1
fi

echo "Docs-Link-Check OK."
