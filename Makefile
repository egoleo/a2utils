SHELL = /bin/sh
PREFIX = /usr/local
SRC = a2mksite.pl
DEST = a2mksite

all: install

install:
	install $(SRC) $(PREFIX)/bin/$(DEST)
