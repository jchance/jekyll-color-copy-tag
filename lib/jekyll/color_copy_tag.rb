require "liquid"

# Liquid tag that renders a clickable copy-to-clipboard button or swatch for a hex color.
#
# Usage:
#   {% color_copy '#RRGGBB' %}                — medium button (default)
#   {% color_copy '#RRGGBB', sm %}            — small button (inline / notification lists)
#   {% color_copy '#RRGGBB', lg %}            — large button (palette grid)
#   {% color_copy '#RRGGBB', swatch %}        — 100x100 paint swatch (configurable)
#
# The tag uses WCAG contrast ratio math to choose black or white text for the
# highest-contrast accessible label, with a subtle border on light swatches.
#
# The JavaScript function is injected into the page on first use.

module Jekyll
  class ColorCopyTagLiquid < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      parts = markup.strip.split(/\s*,\s*/)
      @hex  = parts[0].gsub(/['"]/, '').strip
      @type = 'button'
      @size = 'md'
      @swatch_width = nil
      @swatch_height = nil
      parts[1..].to_a.each do |part|
        part = part.strip
        case part
        when 'sm', 'md', 'lg'
          @size = part
        when 'swatch'
          @type = 'swatch'
        when /^swatch_(\d+)x(\d+)$/
          @type = 'swatch'
          @swatch_width = $1.to_i
          @swatch_height = $2.to_i
        end
      end
    end

    def render(context)
      hex = @hex
      config = context&.registers&.[](:site)&.config&.[]('color_copy') || {}
      copied_color = config['copied_color'] || '#2BB3B1'
      swatch_width = @swatch_width || config['swatch_width'] || 100
      swatch_height = @swatch_height || config['swatch_height'] || 100

      # Inject the script once per page
      page = context.registers[:page]
      script_injected_key = 'color_copy_script_injected'
      
      output = ""
      unless page && page[script_injected_key]
        output += inject_script(context)
        page[script_injected_key] = true if page
      end

      if @type == 'swatch'
        output += render_swatch(hex, copied_color, swatch_width, swatch_height)
      else
        output += render_button(hex, copied_color)
      end
      
      output
    end

    private

    def inject_script(context)
      %{<script>
if (typeof window.copyToClipboard === 'undefined') {
  window.copyToClipboard = function(hex, element) {
    navigator.clipboard.writeText(hex).then(() => {
      const originalBg = element.style.backgroundColor;
      const originalText = element.innerHTML;
      const copiedColor = element.dataset.copiedColor || '#2BB3B1';
      const checkIcon = '<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="1em" height="1em" style="margin-right: 0.35em; vertical-align: -0.125em; fill: currentColor;"><path fill-rule="evenodd" d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 11-1.06-1.06L12.72 4.22a.75.75 0 011.06 0z"/><path fill-rule="evenodd" d="M7.03 11.03a.75.75 0 111.06-1.06l3.72 3.72a.75.75 0 11-1.06 1.06L7.03 11.03z" transform="rotate(90 8 8)"/></svg>';

      element.style.backgroundColor = copiedColor;
      if (element.tagName === 'BUTTON') {
        element.textContent = ' Copied';
        element.innerHTML = checkIcon + element.textContent;
      } else if (element.classList.contains('color-copy-swatch')) {
        element.innerHTML = checkIcon;
      }

      setTimeout(() => {
        element.style.backgroundColor = originalBg;
        element.innerHTML = originalText;
      }, 1200);
    }).catch(err => console.error('Copy failed:', err));
  };
}
</script>}
    end

    private

    def render_button(hex, copied_color)
      luminance = relative_luminance(hex)
      contrast_with_white = contrast_ratio(luminance, 1.0)
      contrast_with_black = contrast_ratio(luminance, 0.0)

      if contrast_with_black >= contrast_with_white
        text_color  = '#000'
        border_style = "border: 1px solid #{darken(hex)};"
      else
        text_color  = 'white'
        border_style = 'border: none;'
      end

      case @size
      when 'sm'
        padding   = '0.2rem 0.45rem'
        font_size = '0.75rem'
        icon_spacing = '0.3em'
      when 'lg'
        padding   = '0.8rem 1.45rem'
        font_size = '1rem'
        icon_spacing = '0.5em'
      else
        padding   = '0.5rem 1rem'
        font_size = '0.875rem'
        icon_spacing = '0.35em'
      end

      style = [
        "padding: #{padding}",
        "background: #{hex}",
        "color: #{text_color}",
        border_style.chomp(';'),
        'border-radius: 4px',
        'cursor: pointer',
        "font-size: #{font_size}",
        'font-weight: 500'
      ].join('; ')

      copy_icon = %(<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" viewBox="0 0 16 16" width="1em" height="1em" style="margin-right: 0.35em; vertical-align: -0.125em; fill: currentColor;"><path fill-rule="evenodd" d="M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z"/></svg>)

      %(<button class="color-copy-btn color-copy-btn--#{@size}" data-color-copy-button data-color="#{hex}" data-copied-color="#{copied_color}" data-copy-icon="#{ERB::Util.html_escape(copy_icon)}" data-copied-icon="#{ERB::Util.html_escape(copy_icon)}" onclick="copyToClipboard('#{hex}', this)" style="#{style};">#{copy_icon.sub('margin-right: 0.35em', "margin-right: #{icon_spacing}")} #{hex}</button>)
    end

    def render_swatch(hex, copied_color, width, height)
      luminance = relative_luminance(hex)
      contrast_with_white = contrast_ratio(luminance, 1.0)
      contrast_with_black = contrast_ratio(luminance, 0.0)

      text_color = contrast_with_black >= contrast_with_white ? '#000' : 'white'
      border_style = contrast_with_black >= contrast_with_white ? "1px solid #{darken(hex)}" : 'none'

      swatch_style = [
        "width: #{width}px",
        "height: #{height}px",
        "background: #{hex}",
        "border: #{border_style}",
        'border-radius: 4px',
        'cursor: pointer',
        'position: relative',
        'display: inline-flex',
        'align-items: flex-end',
        'justify-content: flex-end',
        'line-height: 1',
        'vertical-align: top'
      ].join('; ')

      hex_style = [
        "color: #{text_color}",
        'font-size: 0.65rem',
        'font-weight: 600',
        'padding: 4px 6px',
        'background: rgba(0, 0, 0, 0.1)',
        'border-radius: 2px',
        'line-height: 1'
      ].join('; ')

      %(<div class="color-copy-swatch" data-color="#{hex}" data-copied-color="#{copied_color}" onclick="copyToClipboard('#{hex}', this)" style="#{swatch_style};" title="Click to copy #{hex}"><span style="#{hex_style}">#{hex}</span></div>)
    end

    def relative_luminance(hex)
      r, g, b = hex_to_rgb(hex).map { |channel| srgb_to_linear(channel) }
      0.2126 * r + 0.7152 * g + 0.0722 * b
    end

    def contrast_ratio(luminance, other_luminance)
      lighter = [luminance, other_luminance].max
      darker = [luminance, other_luminance].min
      (lighter + 0.05) / (darker + 0.05)
    end

    def hex_to_rgb(hex)
      [hex[1, 2], hex[3, 2], hex[5, 2]].map { |channel| channel.to_i(16) / 255.0 }
    end

    def srgb_to_linear(channel)
      if channel <= 0.04045
        channel / 12.92
      else
        ((channel + 0.055) / 1.055) ** 2.4
      end
    end

    # Produce a slightly darker hex border from the swatch color
    def darken(hex)
      r, g, b = hex_to_rgb(hex).map { |channel| (channel * 255).to_i }
      dr = [(r - 40), 0].max
      dg = [(g - 40), 0].max
      db = [(b - 40), 0].max
      format('#%02X%02X%02X', dr, dg, db)
    end
  end
end

Liquid::Template.register_tag('color_copy', Jekyll::ColorCopyTagLiquid)
