SHELL = /bin/sh
PREFIX = /usr/local
SRC = a2mksite.pl
CONF = a2utils.conf
FILES = a2mksite.pl a2utils.conf LICENSE Makefile README
DEST = a2mksite
BUILD = a2mksite
ARCHIVE = $(BUILD).tar.bz2
ARCHFILES := $(patsubst %, $(BUILD)/%, $(FILES))

all: install

install:
	install $(SRC) $(PREFIX)/bin/$(DEST)
	cp -f $(CONF) $(PREFIX)/etc/

archive: $(ARCHIVE)

$(ARCHIVE): $(ARCHFILES)
	tar jcf $(ARCHIVE) $(BUILD)

$(BUILD)/%: $(FILES) $(BUILD)
	cp $* $(BUILD)

$(BUILD):
	mkdir $(BUILD)

clean:
	rm -rf $(BUILD) $(ARCHIVE)
