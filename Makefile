ZIP := no-verity-opt-encrypt.zip

EXCLUDE := Makefile *.git*

all: $(ZIP)

$(ZIP):
	zip -r9 "$@" . -x $(EXCLUDE)

clean:
	rm "$(ZIP)"
