MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_PATH := $(dir $(abspath $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
##CURRENT_DIR := $(HOME)
HTML_FILES := $(patsubst %.Rmd, %.html ,$(wildcard $(CURRENT_PATH)website/*.Rmd)) \
              $(patsubst %.md, %.html ,$(wildcard $(CURRENT_PATH)website/*.md))
#HTML_FILES_OUTPUT := $(patsubst /website/, /docs/ , $(HTML_FILES))

all: html

html: $(HTML_FILES)

%.html: %.Rmd
#	@echo $(MAKEFILE_LIST) $(MKFILE_PATH) $(CURRENT_PATH) $(CURRENT_DIR)
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
	mv $(CURRENT_PATH)website/$(notdir $@) $(CURRENT_PATH)docs/$(notdir $@) 

%.html: %.md
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
	mv $(CURRENT_PATH)website/$(notdir $@) $(CURRENT_PATH)docs/$(notdir $@) 

.PHONY: clean
clean:
#	$(RM) $(CURRENT_PATH)docs/$(notdir $(HTML_FILES))
#	$(RM) $(HTML_FILES_OUTPUT)
	$(RM) $(patsubst /website/, /docs/ , $(HTML_FILES)) 

