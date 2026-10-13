# PLO-droid

**The Android app store of Plan-les-Ouates**, built on [F-Droid](https://f-droid.org).

> 🇫🇷 PLO-droid est le magasin d'applications Android de la commune de
> Plan-les-Ouates. Il s'agit d'un dépôt F-Droid : on l'ajoute dans
> l'application F-Droid (ou Neo Store, Droid-ify…) et on peut ensuite
> installer et mettre à jour les applications qu'il contient.

PLO-droid is an [F-Droid repository](https://f-droid.org/docs/Setup_an_F-Droid_App_Repo/)
generated with [`fdroidserver`](https://gitlab.com/fdroid/fdroidserver) and
published on GitHub Pages. It distributes free and open-source apps that are
useful to the residents, associations and staff of Plan-les-Ouates.

- Repository URL: **https://pdehaye.github.io/PLO-droid/repo**
- Landing page with QR code: https://pdehaye.github.io/PLO-droid/

## Using the store

1. Install an F-Droid client: [F-Droid](https://f-droid.org),
   [Droid-ify](https://github.com/Droid-ify/client) or
   [Neo Store](https://github.com/NeoApplications/Neo-Store).
2. Open the landing page above on your phone and tap the repository link,
   or scan its QR code. The link carries the repository's signing-key
   fingerprint, so the client can verify it is talking to the real PLO-droid.
3. Browse the **Plan-les-Ouates** category.

## How it works

```
metadata/<appId>.yml   ──┐
repo/<appId>_<vc>.apk  ──┼─► fdroid update ──► signed index ──► GitHub Pages
config.yml, icon.png   ──┘     (GitHub Actions, .github/workflows/repo.yml)
```

| Path | What |
|---|---|
| `config.yml` | fdroidserver configuration (repo name, URL, signing alias). No secrets. |
| `config/categories.yml` | Our own categories (e.g. *Plan-les-Ouates*). |
| `metadata/` | One `<applicationId>.yml` per app: descriptions, license, links. |
| `repo/` | Signed release APKs, stored with Git LFS. Everything else in it is generated. |
| `icon.png` | Repository icon shown in clients. |
| `templates/app-metadata.yml` | Starting point for a new app's metadata. |
| `scripts/` | Keystore creation and CI signing helpers. |
| `docs/` | Maintainer documentation. |

On every pull request CI runs `fdroid lint`. On every push to `main` it also
signs the index with the PLO-droid key and deploys to GitHub Pages.

## Maintaining

- [Adding or updating an app](docs/adding-apps.md)
- [Signing key and first-time setup](docs/signing.md)
- [Roadmap](docs/roadmap.md)

Local run:

```sh
python3 -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt     # plus apksigner from your distro / Android SDK
chmod 600 config.yml && mkdir -p repo
fdroid lint
export FDROID_KEYSTORE_PASS=... FDROID_KEY_PASS=...   # needs keystore.p12
fdroid update --pretty
```

## License

Repository tooling and metadata: [AGPL-3.0-or-later](LICENSE). Each app is
distributed under its own license, listed in its metadata.
