# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5] - 2026-08-29

### Fixed

- **CRITICAL:** Fixed `{% include color_copy.js %}` not being discoverable by Jekyll. The gem's `_includes` directory is now automatically registered with Jekyll's include search path via a post-reset hook. Users no longer need to manually copy the JS file into their site.

## [1.0.0] - 2026-08-29

### Added

- Initial release of jekyll-color-copy-tag
- `{% color_copy '#HEX' %}` Liquid tag for rendering clickable copy buttons
- Button sizing: small, medium (default), large
- Paint swatches with `swatch` modifier and custom dimensions via `swatch_WxH` syntax
- WCAG contrast ratio calculation for automatic black/white text selection
- Copy-to-clipboard feedback: background color change and icon swap
- Configurable copied-to-clipboard feedback color via `_config.yml`
- Configurable default swatch dimensions in `_config.yml`
- Embedded Bootstrap Icons (copy icon, check-lg icon)
- No external dependencies (FontAwesome, etc.)
- Full accessibility support with title attributes
