NAME ?= no-verity-opt-encrypt

VERSION ?= $(shell awk '$$1 == "print" && $$3 == "version" { print $$4 }' META-INF/com/google/android/update-binary)

DATE := $(shell date +'%Y%m%d-%H%M')

ZIP := $(NAME)-$(VERSION).zip
# ZIP := $(NAME)-$(VERSION)-$(DATE).zip

EXCLUDE := Makefile README.md *.git* "$(NAME)-"*.zip*

all: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@" . -x $(EXCLUDE)
	@echo "Generating SHA1..."
	@sha1sum "$@" > "$@.sha1"
	@cat "$@.sha1"
	@echo "Done."

clean:
	@rm -vf "$(NAME)-"*.zip*
	@echo "Done."
