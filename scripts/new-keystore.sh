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

# Text (base64) copy of the keystore: this is what goes into the GitHub secret
# and into a password manager (e.g. a Bitwarden secure note), which cannot
# hold binary files without attachments.
base64 < keystore.p12 | tr -d '\n' > keystore.p12.b64
chmod 600 keystore.p12.b64

cat <<'MSG'

Created keystore.p12 and its text copy keystore.p12.b64 (both git-ignored).

Next steps:
  1. Back it up: in your password manager (e.g. a Bitwarden secure note),
     store the password AND the content of keystore.p12.b64.
     macOS: pbcopy < keystore.p12.b64   copies it to the clipboard.
  2. Add these GitHub Actions secrets (Settings > Secrets and variables > Actions):
       FDROID_KEYSTORE_B64   = content of keystore.p12.b64
       FDROID_KEYSTORE_PASS  = the keystore password
  3. Delete keystore.p12.b64 once both copies are saved:  rm keystore.p12.b64

To restore keystore.p12 later from the text copy:
  base64 -d < keystore.p12.b64 > keystore.p12
MSG
