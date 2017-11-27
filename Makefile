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
	cp -p $(CURRENT_PATH)website/$(notdir $@) $(CURRENT_PATH)docs/$(notdir $@) 
	head -n 15 $(CURRENT_PATH)docs/$(notdir $@) > $(CURRENT_PATH)docs/$(notdir $@).tmp1
	cat $(CURRENT_PATH)docs/$(notdir $@) | awk '{ if (NR > 25) { print $0 } }' > $(CURRENT_PATH)docs/$(notdir $@).tmp2
	cat $(CURRENT_PATH)docs/$(notdir $@).tmp1 $(CURRENT_PATH)docs/20171127.CorrectHTML.html $(CURRENT_PATH)docs/$(notdir $@).tmp2 > $(CURRENT_PATH)docs/$(notdir $@)
	rm $(CURRENT_PATH)docs/$(notdir $@).tmp1 $(CURRENT_PATH)docs/$(notdir $@).tmp2

%.html: %.md
	R --slave -e "set.seed(100);rmarkdown::render('$<')"
	cp -p $(CURRENT_PATH)website/$(notdir $@) $(CURRENT_PATH)docs/$(notdir $@) 
	head -n 15 $(CURRENT_PATH)docs/$(notdir $@) > $(CURRENT_PATH)docs/$(notdir $@).tmp1
	cat $(CURRENT_PATH)docs/$(notdir $@) | awk '{ if (NR > 25) { print $0 } }' > $(CURRENT_PATH)docs/$(notdir $@).tmp2
	cat $(CURRENT_PATH)docs/$(notdir $@).tmp1 $(CURRENT_PATH)docs/20171127.CorrectHTML.html $(CURRENT_PATH)docs/$(notdir $@).tmp2 > $(CURRENT_PATH)docs/$(notdir $@)
	rm $(CURRENT_PATH)docs/$(notdir $@).tmp1 $(CURRENT_PATH)docs/$(notdir $@).tmp2

.PHONY: clean
clean:
#	$(RM) $(HTML_FILES_OUTPUT)
#	$(RM) $(CURRENT_PATH)docs/$(notdir $(HTML_FILES))
	$(RM) $(patsubst /website/, /docs/ , $(HTML_FILES)) 

