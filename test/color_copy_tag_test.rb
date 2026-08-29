require "minitest/autorun"
require "liquid"
require "jekyll"
require "jekyll/color_copy_tag"

class ColorCopyTagTest < Minitest::Test
  def setup
    @site = Jekyll::Site.new(Jekyll.configuration({}))
    @context = Liquid::Context.new({}, {}, { site: @site })
  end

  def test_button_rendering
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#0D2B45'", [])
    output = tag.render(@context)
    assert output.include?("#0D2B45")
    assert output.include?("color-copy-button")
  end

  def test_button_small_size
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#0D2B45', sm", [])
    output = tag.render(@context)
    assert output.include?("#0D2B45")
    assert output.include?("padding")
  end

  def test_swatch_rendering
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#0D2B45', swatch", [])
    output = tag.render(@context)
    assert output.include?("#0D2B45")
    assert output.include?("color-copy-swatch")
  end

  def test_swatch_custom_dimensions
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#0D2B45', swatch_200x150", [])
    output = tag.render(@context)
    assert output.include?("width: 200px")
    assert output.include?("height: 150px")
  end

  def test_contrast_ratio_calculation
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#FFFFFF'", [])
    output = tag.render(@context)
    # Light background should choose black text
    assert output.include?("color: #000")
  end

  def test_contrast_ratio_dark
    tag = Jekyll::ColorCopyTag.new("color_copy", "'#000000'", [])
    output = tag.render(@context)
    # Dark background should choose white text
    assert output.include?("color: white")
  end
end
