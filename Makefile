#
#    Original Copyright (C) 1987, 1988 Chuck Simmons
#
# Updated by SoftwareTesterScott for sts-empire
#
# See the file COPYING, distributed with empire, for restriction
# and warranty information.

VERS=1.00

# Use -g to compile the program for debugging.
#DEBUG = -g -DDEBUG
DEBUG = -O2

# Use -p to profile the program.
#PROFILE = -p -DPROFILE
PROFILE =

LIBS = -lncurses

# You shouldn't have to modify anything below this line.

# There's a dynamic format in the object-display routines; suppress the warning
CFLAGS = $(DEBUG) $(PROFILE) -Wall -Wno-format-security

FILES = \
	attack.c \
	compmove.c \
	data.c \
	display.c \
	edit.c \
	empire.c \
	game.c \
	main.c \
	map.c \
	math.c \
	object.c \
	term.c \
	usermove.c \
	util.c

HEADERS = empire.h extern.h

OFILES = \
	attack.o \
	compmove.o \
	data.o \
	display.o \
	edit.o \
	empire.o \
	game.o \
	main.o \
	map.o \
	math.o \
	object.o \
	term.o \
	usermove.o \
	util.o

all: sts-empire

sts-empire: $(OFILES)
	$(CC) $(PROFILE) -o sts-empire $(OFILES) $(LIBS)

attack.o:: extern.h empire.h
compmove.o:: extern.h empire.h
data.o:: empire.h
display.o:: extern.h empire.h
edit.o:: extern.h empire.h
empire.o:: extern.h empire.h
game.o:: extern.h empire.h
main.o:: extern.h empire.h
map.o:: extern.h empire.h
math.o:: extern.h empire.h
object.o:: extern.h empire.h
term.o:: extern.h empire.h
usermove.o:: extern.h empire.h
util.o:: extern.h empire.h

empire.6: sts-empire.xml
	xmlto man sts-empire.xml

sts-empire.html: sts-empire.xml
	xmlto html-nochunks sts-empire.xml

TAGS: $(HEADERS) $(FILES)
	etags $(HEADERS) $(FILES)

lint: $(FILES)
	lint -u -D$(SYS) $(FILES) -lcurses

# cppcheck should run clean
cppcheck:
	cppcheck --inline-suppr --suppress=unusedStructMember --suppress=unusedFunction  --template gcc --enable=all --force *.[ch]

install: empire.6 uninstall
	install -m 0755 -d $(DESTDIR)/usr/bin
	install -m 0755 -d $(DESTDIR)/usr/share/man/man6
	install -m 0755 -d $(DESTDIR)/usr/share/applications/
	install -m 0755 -d $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/
	install -m 0755 -d $(DESTDIR)/usr/share/appdata
	install -m 0755 sts-empire $(DESTDIR)/usr/bin/
	install -m 0644 empire.6 $(DESTDIR)/usr/share/man/man6/sts-empire.6
	install -m 0644 sts-empire.desktop $(DESTDIR)/usr/share/applications/
	install -m 0644 sts-empire.png $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/
	install -m 0644 sts-empire.xml $(DESTDIR)/usr/share/appdata/

uninstall:
	rm -f /usr/bin/sts-empire /usr/share/man/man6/sts-empire.6
	rm -f /usr/share/applications/sts-empire.desktop
	rm -f /usr/share/icons/hicolor/48x48/apps/sts-empire.png
	rm -f /usr/share/appdata/sts-empire.xml

clean:
	rm -f *.o TAGS sts-empire
	rm -f *.6 *.html

clobber: clean
	rm -f sts-empire sts-empire-*.tar*

SOURCES = README HACKING NEWS control empire.6 sts-empire.xml COPYING Makefile BUGS AUTHORS $(FILES) $(HEADERS) sts-empire.png sts-empire.desktop

sts-empire-$(VERS).tar.gz: $(SOURCES)
	@ls $(SOURCES) | sed s:^:sts-empire-$(VERS)/: >MANIFEST
	@(cd ..; ln -s sts-empire sts-empire-$(VERS))
	(cd ..; tar -czf sts-empire/sts-empire-$(VERS).tar.gz `cat sts-empire/MANIFEST`)
	@(cd ..; rm sts-empire-$(VERS))

dist: sts-empire-$(VERS).tar.gz

release: sts-empire-$(VERS).tar.gz sts-empire.html
	shipper version=$(VERS) | sh -e -x

refresh: sts-empire.html
	shipper -N -w version=$(VERS) | sh -e -x
