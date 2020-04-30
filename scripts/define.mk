# System environment variable.
ifeq ($(OS),Windows_NT)
	HOSTOS		:= windows
else
	ifeq ($(shell uname),Darwin)
		HOSTOS		:= macos
	else
		ifeq ($(shell uname),Linux)
			HOSTOS		:= linux
		else
			HOSTOS		:= unix-like
		endif
	endif
endif

ifeq ($(HOSTOS),windows)
	SUFFIX	:= .exe
else
	SUFFIX	:=
endif

srctree		:= $(BUILD_SRC)
objtree		:= $(CURDIR)
src			:= .
obj			:= .

VPATH		:= $(srctree)

export srctree objtree VPATH

CROSS_COMPILE	?=

# Make variables (CC, etc...)
AS			:=	$(CROSS_COMPILE)gcc -x assembler-with-cpp
CC			:=	$(CROSS_COMPILE)gcc
CPP			:=	$(CROSS_COMPILE)gcc -E
CXX			:=	$(CROSS_COMPILE)g++
LD			:=	$(CROSS_COMPILE)ld
AR			:=	$(CROSS_COMPILE)ar
OC			:=	$(CROSS_COMPILE)objcopy
OD			:=	$(CROSS_COMPILE)objdump
NM			:=	$(CROSS_COMPILE)nm

HOSTCC		:=	gcc