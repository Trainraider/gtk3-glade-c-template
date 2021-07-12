.SUFFIXES:
.SUFFIXES: .c .o .h

include config.mk

#Functions_______________________________________________________________________
RM = -yes | rm -f
CP = yes | cp -f

ROOTCHECK = @echo;\
	if [[ $EUID -ne 0 ]]; then\
		echo "error: you cannot perform this operation unless you are root.";\
		exit 1;\
	fi
#________________________________________________________________________________

BIN = $(BLD)/bin/$(TARGET)

DBIN = $(DBG)/bin/$(TARGET)

OBJ = $(BLD)/main.o

OBJD = $(DBG)/main.o

GLADE = $(SRC)/window_main.glade

GLADEH = $(SRC)/ui_xml.h

DESKTOP = $(BLD)/$(TARGET).desktop

all: options $(BIN) $(DESKTOP)

options:
	@echo Build options:
	@echo ""
	@echo "CFLAGS  = $(_CFLAGS) $(RELEASE_CFLAGS)"
	@echo ""
	@echo "LDFLAGS = $(_LDFLAGS)"
	@echo ""
	@echo "CC      = $(CC)"
	@echo ""

$(BIN): $(OBJ)
	$(CC) -o $@ $(OBJ) $(_LDFLAGS)

$(OBJ) : $(GLADEH) $(SRC)/main.c
	-mkdir -p $(BLD)/bin
	$(CC) -c $(_CFLAGS) $(RELEASE_CFLAGS) $(SRC)/main.c -o $@

$(GLADEH): $(GLADE)
	echo 'static char *GLADE_UI =' > $@;\
	sed 's/\\/\\\\/g;s/"/\\"/g;s/^.*$$/    "&\\n"/' $(GLADE) >> $@;\
	echo '    ;' >> $@

debug: doptions $(DBIN)

doptions:
	@echo Build options:
	@echo ""
	@echo "CFLAGS  = $(_CFLAGS) $(DEBUG_CFLAGS)"
	@echo ""
	@echo "LDFLAGS = $(_LDFLAGS)"
	@echo ""
	@echo "CC      = $(CC)"
	@echo ""

$(DBIN): $(OBJD)
	$(CC) -o $@ $(OBJD) $(D_LDFLAGS);

$(OBJD): $(GLADEH)
	-mkdir -p $(DBG)/bin
	$(CC) -c $(_CFLAGS) $(DEBUG_CFLAGS) $(SRC)/main.c -o $@

$(DESKTOP):
	@echo "[Desktop Entry]"                         > $@
	@echo "Version=$(VERSION)"                     >> $@
	@echo "Type=Application"                       >> $@
	@echo "Name=$(NAME)"                           >> $@
	@echo "Exec=$(DESTDIR)$(PREFIX)/bin/$(TARGET)" >> $@
	@echo "Comment=$(COMMENT)"                     >> $@
	@echo "Icon=$(TARGET)"                         >> $@
	@echo "Terminal=false"                         >> $@
	@echo "Categories=$(CATEGORIES)"               >> $@

install : all
	$(ROOTCHECK)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	$(CP) $(BIN) $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	mkdir -p $(DESTDIR)$(PREFIX)/share/applications
	$(CP) $(BLD)/$(TARGET).desktop $(DESTDIR)$(PREFIX)/share/applications/$(TARGET).desktop
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps
	$(CP) $(SRC)/icon.svg $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/$(TARGET).svg
	gtk-update-icon-cache -f -t $(DESTDIR)$(PREFIX)/share/icons/hicolor
	update-desktop-database $(DESTDIR)$(PREFIX)/share/applications

uninstall :
	$(ROOTCHECK)
	$(RM) $(DESTDIR)$(PREFIX)/bin/$(TARGET) \
	$(DESTDIR)$(PREFIX)/share/applications/$(TARGET).desktop \
	$(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/$(TARGET).svg
	gtk-update-icon-cache -f -t $(DESTDIR)$(PREFIX)/share/icons/hicolor
	update-desktop-database $(DESTDIR)$(PREFIX)/share/applications

clean :
	$(RM) $(GLADEH) $(SRC)/*.glade~ $(SRC)/*.glade# $(BLD)/* $(DBG)/* $(BLD)/bin/* $(DBG)/bin/*

format :
	clang-format -style="{BasedOnStyle: webkit, IndentWidth: 8,AlignConsecutiveDeclarations: true, AlignConsecutiveAssignments: true, ReflowComments: true, SortIncludes: true}" -i $(SRC)/*.{c,h}

.PHONY: all options debug doptions install uninstall clean format