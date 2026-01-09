#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail

TOOL_NAME="rescript"
BINARY_NAME="rescript"

fail() { echo -e "\e[31mFail:\e[m $*" >&2; exit 1; }

list_all_versions() {
  npm view rescript versions --json 2>/dev/null | tr -d '[]" \n' | tr ',' '\n' | sort -V
}

download_release() {
  local version="$1" download_path="$2"
  mkdir -p "$download_path"
  echo "$version" > "$download_path/VERSION"
}

install_version() {
  local install_type="$1" version="$2" install_path="$3"

  export npm_config_prefix="$install_path"
  npm install -g "rescript@${version}" || fail "npm install failed"
}
