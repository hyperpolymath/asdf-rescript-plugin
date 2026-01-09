#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail

TOOL_NAME="rescript"
NPM_PACKAGE="rescript"

fail() {
  echo -e "\e[31mFail:\e[m $*" >&2
  exit 1
}

list_all_versions() {
  npm view "$NPM_PACKAGE" versions --json 2>/dev/null |
    tr -d '[]",' |
    tr ' ' '\n' |
    grep -E '^[0-9]' |
    sort -V
}

download_release() {
  local version="$1"
  local download_path="$2"
  mkdir -p "$download_path"
  echo "$version" > "$download_path/VERSION"
}

install_version() {
  local version="$1"
  local install_path="$2"

  mkdir -p "$install_path"
  cd "$install_path"

  npm install "$NPM_PACKAGE@$version" --prefix "$install_path"

  # Link binary
  mkdir -p "$install_path/bin"
  if [[ -f "$install_path/node_modules/.bin/$TOOL_NAME" ]]; then
    ln -sf "../node_modules/.bin/$TOOL_NAME" "$install_path/bin/$TOOL_NAME"
  fi
}
