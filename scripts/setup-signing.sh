#!/usr/bin/env bash
# Restore keystore.p12 from the FDROID_KEYSTORE_B64 secret (used in CI).
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -z "${FDROID_KEYSTORE_B64:-}" || -z "${FDROID_KEYSTORE_PASS:-}" ]]; then
  echo "::error::Missing FDROID_KEYSTORE_B64 / FDROID_KEYSTORE_PASS secrets. See docs/signing.md." >&2
  exit 1
fi

umask 077
printf '%s' "$FDROID_KEYSTORE_B64" | base64 -d > keystore.p12
