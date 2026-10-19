# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- webOS 10+/flutter screensaver support: on flutter-based firmware the
  screensaver app has no `qml/`, so apply.sh now stages a qml copy of it
  (stock appinfo retyped to `qml` + this app's screensaver-main.qml) and
  bind-mounts the staged directory over the app (#14)
- `apply.sh remove` and a "Restore stock screensaver" button to undo the
  overlay without a reboot (#13)

### Fixed
- apply.sh no longer fails with "Could not detect screensaver QML target" on
  webOS 10+ firmware

## [1.0.1] - 2022-01-07
### Changed
- Replaced logo with an inverted one

## [1.0.0] - 2022-01-05
Initial release

[Unreleased]: https://github.com/webosbrew/custom-screensaver/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/webosbrew/custom-screensaver/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/webosbrew/custom-screensaver/releases/tag/v1.0.0
