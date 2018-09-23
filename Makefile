.PHONY: all clean
all:
	@echo Build all
	Rscript R/setup.R
	Rscript R/read.R
	Rscript R/write.R
	Rscript -e 'unlink("resources", recursive = TRUE)'
clean:
	@echo Clean all
	rm -rf docs/*
