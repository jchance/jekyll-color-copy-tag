require_relative "jekyll_color_copy_tag"

# Register the gem's _includes directory with Jekyll
Jekyll::Hooks.register(:site, :after_reset) do |site|
  gem_includes_path = File.expand_path("../../_includes", __dir__)
  site.includes_load_paths << gem_includes_path unless site.includes_load_paths.include?(gem_includes_path)
end
