VERSION ?= 1.1

ZIP := note7-disable-charging-limit-$(VERSION).zip

EXCLUDE := Makefile README.md *.git*

all: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@" . -x $(EXCLUDE)
	@echo "Generating SHA1..."
	@sha1sum "$@" > "$@.sha1"
	@cat "$@.sha1"
	@echo "Done."

clean:
	@rm -f "$(ZIP)" "$(ZIP).sha1"
	@echo "Done."
