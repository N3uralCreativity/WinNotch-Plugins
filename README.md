# WinNotch Plugins Library

This repository is the source of truth for the WinNotch in-app Plugin Browser.

If a plugin is not listed in this repository's `library.json`, it will not appear in the browser even if the plugin DLL exists somewhere else online.

## Links

- WinNotch app: `https://github.com/N3uralCreativity/WinNotch`
- Documentation: `https://n3uralcreativity.github.io/WinNotch/documentation/`
- Plugin development guide: `https://github.com/N3uralCreativity/WinNotch/blob/main/PLUGIN_DEVELOPMENT.md`
- Releases in this repo: `https://github.com/N3uralCreativity/WinNotch-Plugins/releases`

## For users

Open WinNotch and go to:

- `Plugin Manager`
- `Browse Plugins`

The browser downloads this repository's `library.json`, shows the entries it contains, and installs the selected plugin DLLs into `%AppData%\WinNotch\Plugins`.

## For plugin authors

To get your plugin into the browser:

1. Build your plugin DLL.
2. Publish it at a stable public URL, usually a GitHub Release asset.
3. Compute its SHA-256 hash.
4. Add an entry to `library.json`.
5. Open a pull request.

Use the official app repository to build plugins:

- examples: `Examples/Plugins/`
- plugin guide: `PLUGIN_DEVELOPMENT.md`
- developer package: `WinNotch.PluginSdk` on GitHub Packages

## Repository files

- `library.json`: the live plugin catalog consumed by WinNotch
- `library.schema.json`: JSON schema for editor validation and tooling
- `CONTRIBUTING.md`: submission checklist for new or updated plugins
- `scripts/validate-library.ps1`: local validation script
- `.github/workflows/validate-library.yml`: CI validation on push and pull request

## Manifest format

```json
{
  "version": "1.0",
  "plugins": [
    {
      "id": "com.example.myplugin",
      "name": "My Plugin",
      "version": "1.0.0",
      "author": "Your Name",
      "description": "What the plugin does",
      "minimumWinNotchVersion": "0.5.3",
      "downloadUrl": "https://github.com/you/repo/releases/download/v1.0.0/MyPlugin.dll",
      "homepage": "https://github.com/you/repo",
      "iconUrl": "",
      "category": "Widget",
      "permissions": [],
      "dependencies": [],
      "sha256": "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF",
      "releaseDate": "2026-04-23T00:00:00Z",
      "isVerified": false
    }
  ]
}
```

## Supported categories

- `Animation`
- `Integration`
- `Productivity`
- `Media`
- `SystemUtility`
- `Theme`
- `Widget`
- `Fun`
- `Other`

## Validate locally

Run this before opening a pull request:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\validate-library.ps1
```
