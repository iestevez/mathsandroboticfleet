# fichero principal
latexfile = distproblem
referencefile = distproblem

TEX = pdflatex
BIBTEX = bibtex

./build/$(latexfile).pdf: $(latexfile).tex
	$(TEX) -output-directory ./build $(latexfile).tex

pdf: ./build/$(latexfile).pdf

bib: ./build/$(latexfile).aux 
	bibtex ./build/$(latexfile)