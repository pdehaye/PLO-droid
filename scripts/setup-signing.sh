#!/usr/bin/env bash
# CI ONLY: restore keystore.p12 from the FDROID_KEYSTORE_B64 GitHub secret.
# You do not need to run this on your own machine: there, keystore.p12 is
# created directly by scripts/new-keystore.sh.
# Re-run under bash if started with `sh script.sh`.
if [ -z "${BASH_VERSION:-}" ]; then exec bash "$0" "$@"; fi
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -z "${FDROID_KEYSTORE_B64:-}" || -z "${FDROID_KEYSTORE_PASS:-}" ]]; then
  echo "::error::Missing FDROID_KEYSTORE_B64 / FDROID_KEYSTORE_PASS secrets. This script runs in GitHub Actions; locally use scripts/new-keystore.sh instead. See docs/signing.md." >&2
  exit 1
fi

umask 077
printf '%s' "$FDROID_KEYSTORE_B64" | base64 -d > keystore.p12
