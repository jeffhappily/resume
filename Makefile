filename ?= jeff-cheah.pdf
html-file ?= resume.html
wkhtmltopdf-flags ?= --enable-local-file-access --dpi 350
fontconfig-file ?= $(CURDIR)/fontconfig/resume-fonts.conf

render-html:
	stack main.hs > $(html-file)

local-generate: render-html
	FONTCONFIG_FILE=$(fontconfig-file) wkhtmltopdf $(wkhtmltopdf-flags) $(html-file) $(filename)

generate: local-generate

clean:
	rm -f *.pdf *.html
