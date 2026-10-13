# Roadmap

Ideas for growing PLO-droid, roughly in order.

1. **First apps.** Pick an initial set of FOSS apps useful locally
   (transport, maps, municipal information…) and publish them.
2. **Custom domain.** Serve the repo from a commune domain
   (e.g. `apps.plan-les-ouates.ch`) instead of `github.io`, so the URL
   survives a change of hosting. Changing `repo_url` later is possible but
   clients must be told; better to decide early.
3. **Mirrors.** Add a second mirror (commune server) via `mirrors` in
   `config.yml` for resilience.
4. **Reproducible builds from source.** Use `fdroid build` with build recipes
   in `metadata/`, run in CI or on a dedicated build server, so the store
   builds apps itself and can verify that published APKs match their source.
5. **Branded client.** Fork the F-Droid client (or Droid-ify) with PLO-droid
   preconfigured as the default repo and Plan-les-Ouates branding, so residents
   install one app and are done.
6. **Translations.** French (fr-CH) metadata and descriptions for every app.
