#!/usr/bin/env bash
set -euo pipefail

die() { printf 'install.sh: %s\n' "$*" >&2; exit 1; }

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/config.ghostty"

[[ -f "$SRC" ]] || die "source config not found: $SRC"
[[ -n "${HOME:-}" ]] || die "HOME is not set"

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DEST_DIR="$CONFIG_HOME/ghostty"
DEST="$DEST_DIR/config.ghostty"

if [[ -e "$DEST" && ! -f "$DEST" && ! -L "$DEST" ]]; then
  die "destination exists but is not a regular file or symlink: $DEST"
fi

mkdir -p -- "$DEST_DIR"

if [[ -f "$DEST" ]] && cmp -s -- "$SRC" "$DEST"; then
  printf 'Ghostty config already up to date: %s\n' "$DEST"
  exit 0
fi

if [[ -e "$DEST" || -L "$DEST" ]]; then
  BACKUP="$DEST.bak.$(date -u +%Y%m%dT%H%M%SZ).$$"
  cp -a -- "$DEST" "$BACKUP"
  printf 'Backed up previous config: %s\n' "$BACKUP"
fi

TMP="$(mktemp "$DEST_DIR/.config.ghostty.XXXXXX")"
trap 'rm -f -- "$TMP"' EXIT
cp -p -- "$SRC" "$TMP"
mv -f -- "$TMP" "$DEST"
trap - EXIT

printf 'Installed Ghostty config: %s\n' "$DEST"
