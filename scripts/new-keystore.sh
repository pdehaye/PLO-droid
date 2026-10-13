#!/usr/bin/env bash
# Create the PLO-droid index-signing keystore (run ONCE, by a maintainer).
#
# The resulting keystore.p12 is the identity of the store: every client that
# added the repo pins its fingerprint. Losing it means every user has to
# re-add the repo; leaking it lets anyone impersonate the store. Back it up
# offline and store it as GitHub Actions secrets (see docs/signing.md).
# Re-run under bash if started with `sh script.sh`.
if [ -z "${BASH_VERSION:-}" ]; then exec bash "$0" "$@"; fi
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -e keystore.p12 ]]; then
  echo "keystore.p12 already exists, refusing to overwrite it." >&2
  exit 1
fi

if ! command -v keytool >/dev/null 2>&1; then
  echo "keytool not found: install a Java JDK first (macOS: brew install openjdk)." >&2
  exit 1
fi

# Ask for the password if it was not provided through the environment.
if [[ -z "${FDROID_KEYSTORE_PASS:-}" ]]; then
  read -r -s -p "Choose a keystore password (min. 12 characters): " FDROID_KEYSTORE_PASS; echo
  read -r -s -p "Repeat the password: " confirm; echo
  if [[ "$FDROID_KEYSTORE_PASS" != "$confirm" ]]; then
    echo "Passwords do not match." >&2
    exit 1
  fi
fi
if (( ${#FDROID_KEYSTORE_PASS} < 12 )); then
  echo "Password too short (min. 12 characters)." >&2
  exit 1
fi

keytool -genkeypair -v \
  -keystore keystore.p12 -storetype PKCS12 \
  -storepass "$FDROID_KEYSTORE_PASS" \
  -alias plo-droid \
  -keyalg RSA -keysize 4096 -sigalg SHA256withRSA \
  -validity 10000 \
  -dname "CN=PLO-droid, OU=Informatique, O=Commune de Plan-les-Ouates, L=Plan-les-Ouates, ST=Geneve, C=CH"

chmod 600 keystore.p12

echo
echo "Created keystore.p12. Next steps:"
echo "  1. Back it up offline (password manager / safe)."
echo "  2. Add these GitHub Actions secrets to the repository:"
echo "       FDROID_KEYSTORE_B64   = output of: base64 < keystore.p12 | tr -d '\\n'"
echo "       FDROID_KEYSTORE_PASS  = the keystore password"
echo "     (PKCS12 uses the same password for the key, so FDROID_KEY_PASS"
echo "      defaults to FDROID_KEYSTORE_PASS.)"
