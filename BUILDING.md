# Building instructions
HTML and PDF versions of the documenatation can be builld using Sphinx.

## Requirements

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/
- Graphviz: https://graphviz.org

## Installation

### On Ubuntu

```
apt-get install python3-sphinx texlive texlive-latex-extra \
  texlive-humanities texlive-fonts-extra mscgen imagemagick \
  librsvg2-bin latexmk graphviz python3-sphinx-rtd-theme
```

### On macOS

1. Download MacTeX and install from http://www.tug.org/mactex
2. Install Homebrew
3. Install Python3 using homebrew
4. Install Sphinx

```
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install sphinx sphinx_rtd_theme
```

5. Install Graphviz using homebrew

```
brew install graphviz
```

6. Install mscgen

```
curl -O http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz
tar xfz mscgen-src-0.20.tar.gz 
cd mscgen-0.20/
./configure
make
make check
sudo make install
```

## Building

```
make latexpdf # For generating pdf
make html # For generating a hierarchy of html pages
make singlehtml # For generating a single html page
```
