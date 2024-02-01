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


## Wiki
Please see the RSMP Core [Wiki](https://github.com/rsmp-nordic/rsmp_core/wiki)
for best practices and frequently asked questions.

## Generating the specification from source

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/
- Graphviz: https://graphviz.org

On Ubuntu:

```
# apt-get install python3-sphinx texlive texlive-latex-extra \
  texlive-humanities texlive-fonts-extra mscgen imagemagick \
  librsvg2-bin latexmk graphviz python3-sphinx-rtd-theme
```

On MacOS using MacTex and Homebrew:

Download MacTeX and install from http://www.tug.org/mactex

```
$ pip3 install -U sphinx sphinx_rtd_theme
$ brew install gts
$ brew install graphwiz
# wget http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz
```

Install mscgen

```
curl -O http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz
tar xfz mscgen-src-0.20.tar.gz 
cd mscgen-0.20/
./configure
make
make check
sudo make install
```

Then:

```
$ make latexpdf # For generating pdf
$ make html # For generating a hierarchy of html pages
$ make singlehtml # For generating a single html page
```

