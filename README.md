## RSMP core specification

The RSMP specification is defined by Trafikverket publication TDOK 2011:256.

The following branch defines RSMP version **3.1.4**.

* [View the core specification online](http://rsmp-nordic.github.io/rsmp_core)
* [View the core specification as a PDF](https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.4/rsmp-spec-3.1.4.pdf)

# FAQ

Please see the <a href="faq.md">faq.md</a> for frequently asked questions.

# Generating the specification from source

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/

On Ubuntu:

```
# apt-get install python-sphinx texlive texlive-latex-extra \
  texlive-humanities mscgen imagemagick librsvg2-bin latexmk sphinx \
  python-sphinx-rtd-theme
```

On Arch:

```
# pacman -S python-sphinx texlive-most texlive-latexextra texlive-humanities \
  imagemagick librsvg python-sphinx_rtd_theme
$ git clone https://aur.archlinux.org/mscgen.git
$ cd mscgen; makepkg -sri
```

Then:

```
$ make latexpdf # For generating pdf
$ make html # For generating a hierarchy of html pages
$ make singlehtml # For generating a single html page
```
