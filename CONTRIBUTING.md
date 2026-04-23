# Contributing to WinNotch-Plugins

This repository controls what appears in the WinNotch Plugin Browser.

## Before you open a pull request

Make sure your plugin is already built and publicly downloadable. The browser needs a direct DLL URL and a manifest entry in `library.json`.

## Submission checklist

- Your plugin ID is unique.
- The plugin version is updated.
- `minimumWinNotchVersion` matches the APIs your plugin actually uses.
- `downloadUrl` points directly to the DLL asset.
- `homepage` points to the repo, release page, or project page.
- `sha256` matches the published DLL.
- `category` is one of the supported values.
- `permissions` and `dependencies` are arrays, even when empty.
- `releaseDate` is valid ISO 8601 UTC text.
- You tested the plugin in WinNotch before submitting.

## Recommended workflow

1. Build your plugin in `Release`.
2. Upload the DLL to a public release.
3. Compute its SHA-256 hash.
4. Add or update the entry in `library.json`.
5. Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\validate-library.ps1
```

6. Open a pull request.

## How the browser sees your plugin

WinNotch does not crawl plugin repositories automatically. The browser reads only the manifests listed in this repository's `library.json`.

That means:

- publishing a DLL alone is not enough
- adding the manifest entry here is what makes the plugin discoverable

## Need help building a plugin?

Start here:

- app repository: `https://github.com/N3uralCreativity/WinNotch`
- docs: `https://n3uralcreativity.github.io/WinNotch/documentation/`
- plugin guide: `https://github.com/N3uralCreativity/WinNotch/blob/main/PLUGIN_DEVELOPMENT.md`
