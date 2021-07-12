SHELL = /bin/sh

#app info
VERSION = 0.0.1
TARGET = template_app
NAME = Template App
COPYRIGHT = Copyright © 2021
AUTHOR = [Your name here]
COMMENT = GTK+ template Application
CATEGORIES = Utility;ComputerScience;GNOME;GTK;

# Customize below to fit your system

# Install paths
PREFIX ?= /usr

#Build/Source paths
SRC = source
BLD = build
DBG = debug

PKG_CONFIG = pkg-config

INCS = `$(PKG_CONFIG) --cflags gtk+-3.0` \
#      `$(PKG_CONFIG) --cflags next_library`

LIBS = `$(PKG_CONFIG) --libs gtk+-3.0` \
#      `$(PKG_CONFIG) --libs next_library`

RELEASE_CFLAGS = -O2 -g
DEBUG_CFLAGS = -O0 -ggdb -Wpedantic -Wall -Wextra -fsanitize=address -fsanitize=undefined -fstack-protector-strong

_CPPFLAGS = $(CPPFLAGS) -DVERSION=\"$(VERSION)\" -DNAME=\""$(NAME)"\" -DAUTHOR=\""$(AUTHOR)"\" -DCOPYRIGHT="\"$(COPYRIGHT)\"" -DTARGET=\"$(TARGET)\"
_CFLAGS = $(INCS) $(_CPPFLAGS) $(CFLAGS) -march=native -pipe
_LDFLAGS = $(LIBS) $(LDFLAGS) -rdynamic -flto
D_LDFLAGS = $(_LDFLAGS) -fsanitize=address -fsanitize=leak -fsanitize=undefined
