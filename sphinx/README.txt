This is the RSMP core specification
Unofficial English translation

Requirements:

- Sphinx: https://www.sphinx-doc.org
- LaTeX (and pdflatex, and various LaTeX packages)
- Mscgen: http://www.mcternan.me.uk/mscgen/

On Ubuntu:

# apt-get install python-sphinx texlive texlive-latex-extra \
  texlive-humanities mscgen imagemagick librsvg2-bin latexmk sphinx \
  python-sphinx-rtd-theme

On Arch:

# pacman -S python-sphinx texlive-most texlive-latexextra texlive-humanities \
  imagemagick librsvg python-sphinx_rtd_theme
$ git clone https://aur.archlinux.org/mscgen.git
$ cd mscgen; makepkg -sri

Then:

$ make latexpdf # For generating pdf
$ make html # For generating a hierarchy of html pages
$ make singlehtml # For generating a single html page

