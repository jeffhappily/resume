filename ?= jeff-cheah.pdf
html-file ?= resume.html
wkhtmltopdf-flags ?= --enable-local-file-access --dpi 350
font-data-home ?= $(CURDIR)

render-html:
	stack main.hs > $(html-file)

local-generate: render-html
	XDG_DATA_HOME=$(font-data-home) wkhtmltopdf $(wkhtmltopdf-flags) $(html-file) $(filename)

generate: local-generate

clean:
	rm -f *.pdf *.html
