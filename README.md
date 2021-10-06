# RSMP core specification

RSMP is a open, modern and flexible communication protocol primarily suited
for communication between road side equipment and supervision systems.

RSMP uses signal exchange lists (SXL) to define the message exchange, e.g.
alarms, status and commands to be used for a specific road side equipment.
Please [see the specification](https://rsmp-nordic.org/rsmp_specifications/core/3.1.5/applicability/sxl.html)
for more in-depth technical information

The following branch defines RSMP version **3.2-draft**.

The specification is available the following formats:

* [View the core specification online](https://rsmp-nordic.org/rsmp_specifications/core/3.1.5)
* [View the core specification as a PDF](https://github.com/rsmp-nordic/rsmp_core/releases/download/v3.1.5/rsmp-spec-3.1.5.pdf)

## FAQ
Please see the <a href="faq.md">faq.md</a> for frequently asked questions.

## Generating the specification from source

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/
- Graphviz: https://graphviz.org

On Ubuntu:

```
# apt-get install python3-sphinx texlive texlive-latex-extra \
  texlive-humanities mscgen imagemagick librsvg2-bin latexmk \
  graphviz python3-sphinx-rtd-theme
```

On Arch:

```
# pacman -S python-sphinx texlive-most texlive-latexextra texlive-humanities \
  imagemagick librsvg python-sphinx_rtd_theme
$ git clone https://aur.archlinux.org/mscgen.git
$ cd mscgen; makepkg -sri
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

