# RSMP core specification

RSMP is a open, modern and flexible communication protocol primarily suited
for communication between road side equipment and supervision systems.

RSMP uses signal exchange lists (SXL) to define the message exchange, e.g.
alarms, status and commands to be used for a specific road side equipment.
Please [see the specification](https://rsmp-nordic.org/rsmp_specifications/core/3.2/applicability/sxl.html)
for more in-depth technical information

The following branch defines RSMP version **3.2.1**.

The specification is available the following formats:

* [View the core specification online](https://rsmp-nordic.org/rsmp_specifications/core/3.2.1)
* [View the core specification as a PDF](https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.2/rsmp-spec-3.2.1.pdf)


## FAQ
Please see the <a href="faq.md">faq.md</a> for frequently asked questions.

## Generating the specification from source

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mermaid: https://mermaid.js.org/

On Ubuntu:

```
# apt-get install python3-sphinx texlive texlive-latex-extra \
  texlive-humanities texlive-fonts-extra imagemagick \
  librsvg2-bin latexmk python3-sphinx-rtd-theme \
  python3-sphinxcontrib-mermaid
# npm install -g @mermaid-js/mermaid-cli
```

On MacOS using MacTex and Homebrew:

Download MacTeX and install from http://www.tug.org/mactex

```
$ pip3 install -U sphinx sphinx_rtd_theme
$ brew install gts
```

Then:

```
$ make latexpdf # For generating pdf
$ make html # For generating a hierarchy of html pages
$ make singlehtml # For generating a single html page
```

