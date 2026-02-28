<p align="center">
  <img src="docs/image.png" width="128" height="128" alt="Maclean Icon">
</p>

<h1 align="center">Maclean</h1>

<p align="center">
  A native macOS disk cleanup utility for developers.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS%2015.0%2B-blue" alt="Platform">
  <img src="https://img.shields.io/badge/swift-6.0-orange" alt="Swift">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
</p>

## Features

- **Smart Scan & Cleanup** — Scans system caches, logs, browser caches, and more. All deletions go to Trash first for safe recovery.
- **Xcode Cleanup** — Remove DerivedData, old Archives, Simulator caches, and device logs.
- **Project Cleanup** — Detect and remove build artifacts (`node_modules`, `target`, `.build`, `dist`, `Pods`, `__pycache__`, etc.) across 15+ project types.
- **App Manager** — Find unused apps (90+ days inactive) and remove them along with associated data.
- **Disk Analyzer** — Identify large files (100 MB+) eating up your storage.
- **App Lipo** — Thin universal binaries by removing unused CPU architectures to save space.
- **System Tools** — Flush DNS, prune Docker, rebuild Spotlight / Launch Services, clear font cache.
- **Whitelist** — Exclude specific paths from scans.
- **Sentinel Mode** — Monitors Trash for deleted apps and notifies you to clean up leftover data.
- **Dashboard & History** — Track lifetime cleanup stats, space reclaimed, and session history.
- **Localization** — Supports 15 languages.

## Requirements

- macOS 15.0 (Sequoia) or later
- Xcode 26.1+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## Build

```bash
# Generate Xcode project
xcodegen generate

# Open in Xcode
open Maclean.xcodeproj
```

Build and run with the **Maclean** scheme.

## Scan Modules

| Module | What it cleans |
|--------|---------------|
| System Cache | System-wide cache files |
| System Log | System log files |
| Browser Cache | Web browser caches |
| Xcode | DerivedData, Archives, Simulators, device logs |
| Homebrew | Package caches and downloads |
| Dev Tools Cache | Developer tool caches |
| App Cache | Application-specific caches |
| Installer | Installation temp files |
| iOS Backup | Device backup artifacts |
| Trash | Trash bin contents |

## Safety

Maclean is designed with safety as a priority:

- **Trash-first deletion** — Files are moved to Trash, not permanently deleted.
- **Dry run preview** — Review exactly what will be removed before confirming.
- **Path validation** — Operations are restricted to the user's home directory; critical system paths are blocked.
- **Deduplication** — Files won't appear in multiple scan categories.
- **Whitelisting** — User-defined exclusion paths.
- **History logging** — All cleanup operations are recorded.

## License

This project is licensed under the [MIT License](LICENSE).
