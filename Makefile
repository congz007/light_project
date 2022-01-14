all: docs/leaf_light_project_showing.html

docs/leaf_light_project_showing.html:	docs/leaf_light_project_showing.Rmd
	R -e 'system.time(rmarkdown::render("$<", "all"))'


.PHONY: clean
clean:
	rm -rf docs/*_files/* docs/*_cache/*
