
SHELL = /bin/sh
TARGET = template_app
CC = gcc
CFLAGS = -std=gnu17 -march=native -pipe
FINALCFLAGS = -O2 -g -flto
DEBUGCFLAGS = -O0 -ggdb -Wpedantic -Wall -Wextra -fsanitize=address
GTKLIB =`pkg-config --cflags --libs gtk+-3.0` -rdynamic
SRC = source
BLD = build
DBG = debug
BIN = $(BLD)/bin/$(TARGET)
DBIN = $(DBG)/bin/$(TARGET)
RM = -yes | rm
ROOTCHECK = @echo;\
	if [[ $EUID -ne 0 ]]; then\
		echo "error: you cannot perform this operation unless you are root.";\
		exit 1;\
	fi

.SUFFIXES:
.SUFFIXES: .c .o .h

OBJ = $(BLD)/main.o

.PHONY : all
all: $(BIN)

$(BIN): $(OBJ)
	$(CC) -o $(BIN) $(CFLAGS) $(FINALCFLAGS) $(OBJ) $(GTKLIB)

$(OBJ) : $(SRC)/ui_xml.h $(SRC)/main.c
	-mkdir -p $(BLD)/bin
	$(CC) -c $(CFLAGS) $(FINALCFLAGS) $(SRC)/main.c $(GTKLIB) -o $(OBJ)

$(SRC)/ui_xml.h: $(SRC)/window_main.glade
	echo 'static char *GLADE_UI =' > $(SRC)/ui_xml.h;\
	sed 's/\\/\\\\/g;s/"/\\"/g;s/^.*$$/    "&\\n"/' $(SRC)/window_main.glade >> $(SRC)/ui_xml.h;\
	echo '    ;' >> $(SRC)/ui_xml.h
	

OBJD = $(DBG)/main.o

.PHONY : debug
debug: $(OBJD)
	$(CC) -o $(DBIN) $(CFLAGS) $(DEBUGCFLAGS) $(OBJD) $(GTKLIB);\
	gdb $(DBIN)

$(OBJD): $(SRC)/ui_xml.h
	-mkdir -p $(DBG)/bin
	$(CC) -c $(CFLAGS) $(DEBUGCFLAGS) $(SRC)/main.c $(GTKLIB) -o $(OBJD)

.PHONY : install
install : $(BIN)
	$(ROOTCHECK)
	cp $(BIN) /usr/bin/$(TARGET)
	cp $(SRC)/$(TARGET).desktop /usr/share/applications/$(TARGET).desktop
	cp $(SRC)/$(TARGET).svg /usr/share/icons/hicolor/scalable/apps/$(TARGET).svg
	gtk-update-icon-cache -f -t /usr/share/icons/hicolor

uninstall :
	$(ROOTCHECK)
	$(RM) /usr/bin/$(TARGET) \
	/usr/share/applications/$(TARGET).desktop \
	/usr/share/icons/hicolor/scalable/apps/$(TARGET).svg
	gtk-update-icon-cache -f -t /usr/share/icons/hicolor

.PHONY : clean
clean :
	$(RM) $(SRC)/ui_xml.h $(SRC)/window_main.glade~ $(BLD)/* $(DBG)/* $(BLD)/bin/* $(DBG)/bin/*

.PHONY : format
format :
	clang-format -style="{BasedOnStyle: webkit, IndentWidth: 8,AlignConsecutiveDeclarations: true, AlignConsecutiveAssignments: true, ReflowComments: true, SortIncludes: true}" -i $(SRC)/*.{c,h}