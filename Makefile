LATEXMK ?= latexmk
LUA     ?= lua
MAIN     = main
SLIDES   = main-slides

FONTES = $(MAIN).tex fisica.sty \
         $(wildcard capitulos/*.tex) \
         $(wildcard content/*.tex) \
         $(wildcard lua/*.lua) \
         videos/demo-oscilador.png referencias.bib \
         dados/oscilador.csv

all: $(MAIN).pdf

tfb: $(MAIN).pdf

slides: $(SLIDES).pdf

$(MAIN).pdf: $(FONTES)
	$(LATEXMK) -lualatex -interaction=nonstopmode -halt-on-error $(MAIN).tex

$(SLIDES).pdf: $(SLIDES).tex beamerthemefisica.sty fisica.sty fisica-video.sty \
               $(wildcard content/*.tex) $(wildcard lua/*.lua) \
               $(wildcard videos/*) dados/oscilador.csv
	$(LATEXMK) -lualatex -interaction=nonstopmode -halt-on-error $(SLIDES).tex

dados: dados/oscilador.csv

dados/oscilador.csv: scripts/gerar_dados.lua
	$(LUA) scripts/gerar_dados.lua

clean:
	$(LATEXMK) -C $(MAIN).tex
	$(LATEXMK) -C $(SLIDES).tex
	$(RM) capitulos/*.aux
	$(RM) main-tfb.aux main-tfb.bbl main-tfb.blg main-tfb.fdb_latexmk \
	      main-tfb.fls main-tfb.lof main-tfb.log main-tfb.lot \
	      main-tfb.pdf main-tfb.toc

.PHONY: all tfb slides dados clean
