# WinNotch Plugins Library

Official plugin library for [WinNotch](https://github.com/N3uralCreativity/WinNotch).

## For Users

Browse and install plugins directly from WinNotch: **Settings > Manage Plugins > Browse Plugins**.

## For Plugin Developers

Want to publish your plugin here? See the [Plugin Development Guide](https://github.com/N3uralCreativity/WinNotch/blob/main/PLUGIN_DEVELOPMENT.md).

### Submitting a Plugin

1. Build your plugin DLL
2. Host it (GitHub Releases recommended)
3. Open a PR adding your plugin to `library.json`

### library.json Format

```json
{
  "version": "1.0",
  "plugins": [
    {
      "id": "com.yourname.pluginname",
      "name": "Plugin Name",
      "version": "1.0.0",
      "author": "Your Name",
      "description": "What your plugin does",
      "minimumWinNotchVersion": "0.3.0",
      "downloadUrl": "https://github.com/you/repo/releases/download/v1.0.0/YourPlugin.dll",
      "homepage": "https://github.com/you/repo",
      "iconUrl": "",
      "category": "Widget",
      "permissions": [],
      "dependencies": [],
      "sha256": "hash-of-your-dll",
      "releaseDate": "2026-04-19T00:00:00Z",
      "isVerified": false
    }
  ]
}
```

### Categories

`Animation` · `Integration` · `Productivity` · `Media` · `SystemUtility` · `Theme` · `Widget` · `Other`
