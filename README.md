# jekyll-color-copy-tag

A Jekyll Liquid tag that renders clickable hex color copy buttons and paint swatches with copy-to-clipboard functionality. Uses WCAG contrast ratio math to automatically choose black or white text for optimal accessible contrast.

- **No dependencies** — includes its own SVG icons
- **WCAG accessible** — automatic contrast calculation
- **Flexible sizing** — three button sizes, configurable swatch dimensions, custom per-tag overrides
- **Copy feedback** — visual confirmation with background color change and icon swap
- **Paint swatches** — render clickable color chips with hex label positioned in corner

## Installation

Add the gem to your `Gemfile`:

```ruby
gem "jekyll-color-copy-tag"
```

Enable it in `_config.yml`:

```yaml
plugins:
  - jekyll-color-copy-tag
```

That's it—the JavaScript is automatically injected into pages that use the tag.

## Usage

### Copy Buttons

Render clickable buttons in three sizes:

```liquid
{% color_copy '#2BB3B1' %}        {# medium (default) #}
{% color_copy '#2BB3B1', sm %}    {# small #}
{% color_copy '#2BB3B1', lg %}    {# large #}
```

Text color is automatically chosen (black or white) based on WCAG contrast ratio math against the button background.

### Paint Swatches

Render clickable color swatches with hex value displayed in the corner:

```liquid
{% color_copy '#2BB3B1', swatch %}              {# uses config dimensions (default 100×100) #}
{% color_copy '#2BB3B1', swatch_150x150 %}     {# override to 150×150 #}
{% color_copy '#2BB3B1', swatch_200x100 %}     {# custom width×height #}
```

The hex label has semi-transparent background and adapts text color for readability on any swatch color.

## Configuration

Customize the copied-to-clipboard feedback color and default swatch dimensions in `_config.yml`:

```yaml
color_copy:
  copied_color: "#2BB3B1"
  swatch_width: 100
  swatch_height: 100
```

- `copied_color` — Background color shown when button/swatch is clicked (defaults to `#2BB3B1`)
- `swatch_width` — Default paint swatch width in pixels (defaults to `100px`)
- `swatch_height` — Default paint swatch height in pixels (defaults to `100px`)

Override per-tag with `swatch_WxH` syntax: `{% color_copy '#hex', swatch_200x150 %}`

## How It Works

### WCAG Contrast Ratio

The plugin calculates relative luminance using the sRGB-to-linear conversion algorithm, then computes contrast ratios against both black (#000) and white (#fff). It selects whichever provides higher contrast, ensuring text is always readable per WCAG standards.

### Copy to Clipboard

Clicking a button or swatch triggers JavaScript that:
1. Copies the hex value to clipboard
2. Temporarily changes background to the configured `copied_color`
3. Shows a checkmark icon (buttons show "✓ Copied", swatches show just the checkmark)
4. Restores original background and content after 1.2 seconds

### Icons

Both icons are embedded as inline SVG from Bootstrap Icons:
- Copy icon (16×16 viewBox)
- Check icon (check-lg variant)

## Accessibility

- Text color automatically selected for WCAG AAA contrast on all backgrounds
- Semantic HTML with title attributes
- No reliance on external icon libraries
- Works without JavaScript (buttons render but copy won't function)

## License

MIT License

## Credits

Icons from [Bootstrap Icons](https://icons.getbootstrap.com/) (MIT License)
