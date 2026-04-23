## Summary

- [ ] add a new plugin
- [ ] update an existing plugin
- [ ] documentation or repository maintenance only

## Plugin checklist

- [ ] the plugin DLL is already publicly downloadable
- [ ] `library.json` was updated
- [ ] the plugin ID is unique or intentionally unchanged for an update
- [ ] the version is correct
- [ ] `minimumWinNotchVersion` is correct
- [ ] the SHA-256 hash matches the published DLL
- [ ] `pwsh -File scripts/validate-library.ps1` passes locally

## Notes

Describe anything reviewers should know about compatibility, required configuration, or unusual permissions.
