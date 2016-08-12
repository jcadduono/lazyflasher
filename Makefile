VERSION ?= 2.0

ZIP := system-supersu-$(VERSION).zip

EXCLUDE := Makefile *.git* README.md *.zip *.sha1

all: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@" . -x $(EXCLUDE)
	@echo "Generating SHA1..."
	@sha1sum "$@" > "$@.sha1"
	@cat "$@.sha1"
	@echo "Done."

clean:
	@rm -f *.zip *.sha1
	@echo "Done."
