generate:
	xvfb-run -- wkhtmltopdf --dpi 350 index.html jeff.pdf

clean:
	rm *.pdf