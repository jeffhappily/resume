generate:
	stack main.hs | xvfb-run -- wkhtmltopdf --dpi 350 - jeff.pdf

clean:
	rm -f *.pdf
