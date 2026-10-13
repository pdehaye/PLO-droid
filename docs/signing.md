# Signing key and first-time setup

The repository index is signed with a single key. Clients pin its
fingerprint when they add the repo, so this key **is** the identity of
PLO-droid:

- if it is **lost**, every user has to remove and re-add the repo;
- if it **leaks**, anyone can publish a fake PLO-droid.

(This key signs the *index* only. Each APK keeps its own developer signature.)

## One-time setup

1. On a trusted machine with a Java JDK (`keytool`; on macOS
   `brew install openjdk`), from the repository root:

   ```sh
   bash scripts/new-keystore.sh
   ```

   It asks for a password (min. 12 characters) and writes, at the
   repository root (both git-ignored, never commit them):
   - `keystore.p12`: the binary keystore;
   - `keystore.p12.b64`: the same keystore as one line of text (base64),
     for places that only accept text.

   Do **not** run `scripts/setup-signing.sh` locally: it only runs in CI.

2. Back up the password **and** the content of `keystore.p12.b64` in the
   commune's password manager. In Bitwarden, use a *Secure Note* (the text is
   about 6,000 characters, under the 10,000 limit; file attachments would
   need a paid plan). On macOS, `pbcopy < keystore.p12.b64` copies it to the
   clipboard. A second offline copy (e.g. USB key in a safe) is recommended.
3. In GitHub → *Settings → Secrets and variables → Actions*, add:
   - `FDROID_KEYSTORE_B64`: the content of `keystore.p12.b64`
   - `FDROID_KEYSTORE_PASS`: the password
   - `FDROID_KEY_PASS`: only if different from the keystore password

   Then delete the text copy: `rm keystore.p12.b64`.
4. In GitHub → *Settings → Pages*, set **Source: GitHub Actions**.
5. Push to `main`. The workflow publishes the repo; the fingerprint is shown
   on the landing page and in the job log (`Creating signed index with this
   key (SHA256)`). Record it in the README.

## Restoring the key on a new machine

Paste the secure note's content into `keystore.p12.b64`, then:

```sh
base64 -d < keystore.p12.b64 > keystore.p12 && chmod 600 keystore.p12
```

## Rotation

F-Droid has no smooth key rotation for repositories. Rotating means publishing
under a new fingerprint and asking users to re-add the repo. Avoid it: protect
the key instead.
