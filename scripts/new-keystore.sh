#!/usr/bin/env bash
# Create the PLO-droid index-signing keystore (run ONCE, by a maintainer).
#
# The resulting keystore.p12 is the identity of the store: every client that
# added the repo pins its fingerprint. Losing it means every user has to
# re-add the repo; leaking it lets anyone impersonate the store. Back it up
# offline and store it as GitHub Actions secrets (see docs/signing.md).
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -e keystore.p12 ]]; then
  echo "keystore.p12 already exists, refusing to overwrite it." >&2
  exit 1
fi

: "${FDROID_KEYSTORE_PASS:?export FDROID_KEYSTORE_PASS first}"

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
echo "       FDROID_KEYSTORE_B64   = output of: base64 -w0 keystore.p12"
echo "       FDROID_KEYSTORE_PASS  = the keystore password"
echo "     (PKCS12 uses the same password for the key, so FDROID_KEY_PASS"
echo "      defaults to FDROID_KEYSTORE_PASS.)"
