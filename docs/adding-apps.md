# Adding or updating an app

PLO-droid currently works as a **binary repository**: we publish release APKs
that are already built and signed by the app's developer (or by us), and
fdroidserver generates the signed index around them. Building from source
with `fdroid build` is on the [roadmap](roadmap.md).

## Inclusion criteria

An app may be added when:

- it is free and open-source software (OSI/FSF-approved license) and its
  source code is public;
- it is relevant to Plan-les-Ouates (municipal services, local associations,
  mobility, culture, civic life…) or recommended by the commune;
- its anti-features (trackers, proprietary network services, ads…) are
  documented in its metadata;
- someone on the team has reviewed it and installed it on a test device.

## New app

1. Create a branch.
2. Copy `templates/app-metadata.yml` to `metadata/<applicationId>.yml` and
   fill it in. Include the `Plan-les-Ouates` category.
3. Put the signed release APK in `repo/`, named
   `<applicationId>_<versionCode>.apk`. Git LFS stores it (run
   `git lfs install` once).
4. Optional: localised texts and screenshots in
   `metadata/<applicationId>/<locale>/` (fastlane layout, see template).
5. Run `fdroid lint` locally if you can, then open a pull request. CI lints it.
6. Once merged to `main`, the app is live within a few minutes.

## New version of an existing app

Add the new APK to `repo/`. It **must be signed with the same key** as the
previous version, otherwise clients refuse the update. Older versions are
moved to the archive automatically (`archive_older` in `config.yml`).

## Automatic publishing from the app's repository

An app's own CI can publish new versions by pushing the APK straight to
`repo/` on `main`. Photox does this (see its
[`android-publish.yml`](https://github.com/hestiaAI/Photox/blob/main/.github/workflows/android-publish.yml)).
To set it up for another app:

1. Add its `metadata/<applicationId>.yml` here by pull request, as for any
   new app.
2. In the app's repository, generate a key pair
   (`ssh-keygen -t ed25519 -N "" -f deploy`) and store the private key as an
   Actions secret.
3. Here, in *Settings → Deploy keys*, add the public key with **write
   access**. One key per app, so each can be revoked on its own.
4. The app's workflow checks out this repository with that key
   (`actions/checkout` with `ssh-key:` and `lfs: true`), copies the APK to
   `repo/<applicationId>_<versionCode>.apk`, commits and pushes to `main`.
   The push triggers this repository's workflow, which publishes the update.

Pushes made with a deploy key skip review, so only give one to apps whose
maintainers we trust. Branch protection on `main` would block them, unless
deploy keys are allowed to bypass it.

## Removing an app

Delete its APKs from `repo/` and its file(s) from `metadata/`.
