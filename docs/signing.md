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

   It asks for a password (min. 12 characters) and writes `keystore.p12`
   at the repository root. Do **not** run `scripts/setup-signing.sh`
   locally: it only runs in CI.

2. Back up `keystore.p12` and its password offline (e.g. the commune's
   password manager, plus a copy in a safe). It is git-ignored; never commit it.
3. In GitHub → *Settings → Secrets and variables → Actions*, add:
   - `FDROID_KEYSTORE_B64` — output of `base64 < keystore.p12 | tr -d '\n'` (works on macOS and Linux;
     on macOS append `| pbcopy` to copy it straight to the clipboard)
   - `FDROID_KEYSTORE_PASS` — the password
   - `FDROID_KEY_PASS` — only if different from the keystore password
4. In GitHub → *Settings → Pages*, set **Source: GitHub Actions**.
5. Push to `main`. The workflow publishes the repo; the fingerprint is shown
   on the landing page and in the job log (`Creating signed index with this
   key (SHA256)`). Record it in the README.

## Rotation

F-Droid has no smooth key rotation for repositories. Rotating means publishing
under a new fingerprint and asking users to re-add the repo. Avoid it: protect
the key instead.
