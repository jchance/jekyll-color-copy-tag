# Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch: `git checkout -b my-feature`
3. Commit your changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin my-feature`
5. Submit a pull request

## Development

To set up a development environment:

```bash
git clone https://github.com/jchance/jekyll-color-copy-tag.git
cd jekyll-color-copy-tag
bundle install
```

Run tests:

```bash
bundle exec rake test
```

or directly:

```bash
bundle exec ruby -I lib:test test/color_copy_tag_test.rb
```

## Reporting Issues

Please include:

- Jekyll version
- Ruby version
- A minimal reproduction (if applicable)
- Expected vs actual behavior
