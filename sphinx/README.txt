This is the RSMP core specification

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/

On Ubuntu:

# apt-get install python3-sphinx texlive texlive-latex-extra \
  texlive-humanities mscgen imagemagick librsvg2-bin latexmk sphinx \
  python3-sphinx-rtd-theme

On Arch:

# pacman -S python-sphinx texlive-most texlive-latexextra texlive-humanities \
  imagemagick librsvg python-sphinx_rtd_theme
$ git clone https://aur.archlinux.org/mscgen.git
$ cd mscgen; makepkg -sri

On MacOS using MacTex and Homebrew:

Download MacTeX and install from http://www.tug.org/mactex

$ pip install -U sphinx sphinx_rtd_theme
$ brew install mscgen

Then:

$ make latexpdf # For generating pdf
$ make html # For generating a hierarchy of html pages
$ make singlehtml # For generating a single html page

