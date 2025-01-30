IN_DIR := site
OUT_DIR := _site
.SUFFIXES: .md .html .css .ico .pdf

# Build Time
TEMPLATE := $(IN_DIR)/templates/default.html

# Commands
PANDOC := pandoc \
	    --template=$(TEMPLATE) \
	    --from markdown \
	    --to html \

# Runtime Copy
IN_ASSETS := $(wildcard $(IN_DIR)/assets/*)
OUT_ASSETS := $(patsubst $(IN_DIR)/%,$(OUT_DIR)/%,$(IN_ASSETS))
IN_ARTEFACTS := $(wildcard $(IN_DIR)/artefacts/*)
OUT_ARTEFACTS := $(patsubst $(IN_DIR)/%,$(OUT_DIR)/%,$(IN_ARTEFACTS))
IN_STYLESHEET := $(IN_DIR)/stylesheet.css
OUT_STYLESHEET := $(OUT_DIR)/stylesheet.css
IN_CNAME := $(IN_DIR)/CNAME
OUT_CNAME := $(OUT_DIR)/CNAME
IN_FONTS := $(IN_DIR)/et-book
OUT_FONTS := $(OUT_DIR)/et-book

$(OUT_DIR)/% : $(IN_DIR)/%
	mkdir -p $(@D)
	cp -rL $^ $@

# Runtime Convert
IN_MD := $(shell find $(IN_DIR) -type f -name "*.md")
OUT_HTML := $(patsubst $(IN_DIR)/%.md,$(OUT_DIR)/%.html,$(IN_MD))

$(OUT_DIR)/%.html: $(IN_DIR)/%.md $(TEMPLATE)
	mkdir -p $(@D)
	$(PANDOC) $< \
	--output $@

all: $(OUT_FONTS) $(OUT_STYLESHEET) $(OUT_ARTEFACTS) $(OUT_ASSETS) $(OUT_HTML) $(OUT_CNAME)

.PHONY: deploy clean all

deploy: all
	cd $(OUT_DIR) && \
	 git add --all && \
	 git commit -m "Deploy updates" && \
	 git push origin gh-pages
