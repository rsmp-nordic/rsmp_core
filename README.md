# RSMP core specification

RSMP is an open communication protocol for communication between road side
equipment and supervision systems, and directly between road side equipment.
Signal Exchange Lists (SXLs) define equipment-specific alarms, statuses, and commands.

This branch contains the **3.3.0** specification in Markdown, built with Jekyll
and Just the Docs. Its documentation content is synchronized with the upstream
`3.3.0` branch at commit `ffbcb83`.

* [View the core specification online](https://rsmp-nordic.github.io/rsmp_core/3.3.0/)
* [RSMP Core Wiki](https://github.com/rsmp-nordic/rsmp_core/wiki)

## Building the documentation

Install Ruby and Bundler, then run:

```sh
bundle install
bundle exec jekyll build
```

The generated site is written to `_site/`. To preview it locally:

```sh
bundle exec jekyll serve
```

Edit the specification in `pages/`. The home page is `index.md`, and site
configuration is in `_config.yml`.
