#!/usr/bin/env bash
# Re-publish the HLS Codegen & Optimization Ontology docs into the course site.
#
# Source of truth: the (private) repo CSG-AgenticAI/hls-codegen-ontology — its
# html/ folder is a self-contained static site. This mirrors that html/ into
# hls-ontology/ here, so the public course site serves an up-to-date snapshot.
# The private repo stays private; only the rendered docs are published.
#
# Usage:
#   ./sync-ontology.sh                 # refresh hls-ontology/ from the source
#   ./sync-ontology.sh --push          # refresh, then commit & push if changed
#   ONTOLOGY_HTML=/path/to/html ./sync-ontology.sh   # override source location
set -euo pipefail

WEB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${ONTOLOGY_HTML:-$HOME/hls-codegen-ontology/html}"
DST="$WEB_DIR/hls-ontology"

if [[ ! -f "$SRC/index.html" ]]; then
  echo "error: no ontology docs at $SRC (expected $SRC/index.html)" >&2
  echo "       set ONTOLOGY_HTML=/path/to/hls-codegen-ontology/html and retry." >&2
  exit 1
fi

echo "sync: $SRC  ->  $DST"
mkdir -p "$DST"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude='.git' "$SRC"/ "$DST"/
else
  # No rsync: rebuild the folder so removed files don't linger.
  rm -rf "$DST"; mkdir -p "$DST"; cp -r "$SRC"/. "$DST"/
fi
echo "sync: $(find "$DST" -type f | wc -l | tr -d ' ') files in hls-ontology/"

cd "$WEB_DIR"
if [[ -z "$(git status --porcelain -- hls-ontology)" ]]; then
  echo "sync: no changes — already up to date."
  exit 0
fi

echo "sync: hls-ontology/ has changes."
if [[ "${1:-}" == "--push" ]]; then
  git add hls-ontology
  git commit -q -m "resources: sync HLS ontology docs snapshot"
  git push origin "$(git rev-parse --abbrev-ref HEAD)"
  echo "sync: committed and pushed — Pages will rebuild in ~1 min."
else
  echo "sync: review, then:  git add hls-ontology && git commit -m 'sync ontology docs' && git push"
fi
