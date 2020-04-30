all:

include $(XBUILD_DIR)/define.mk
include $(XBUILD_DIR)/env.mk
include $(XBUILD_DIR)/include.mk

SRCDIRS		:=
INCDIRS		:=

# config
X_CONF_DIR	:=	$(obj)/include/config
X_CONF_FILE	:=	$(srctree)/include/xconfigs.h

# compiler's flags
X_ASFLAGS	:=	
X_CFLAGS	:=
X_LDFLAGS	:=
X_LIBS		:=
X_NAME		:=	a.out
X_DEFINES	:=
X_CPPFLAGS	:=

X_LIBDIRS	:=
X_LDFLAGS	:=

X_INCDIRS	=	$(patsubst %, -I %, $(foreach d,$(INCDIRS),$(wildcard $(srctree)/$(d))))
X_OBJS		=	$(patsubst $(srctree)/%, %/built-in.o, $(foreach d,$(SRCDIRS),$(wildcard $(srctree)/$(d))))

include $(srctree)/Makefile

ifneq ($(wildcard $(X_CONF_FILE)),)
X_CPPFLAGS	+=	-include $(X_CONF_DIR)/autoconf.h
endif

export BUILD_OBJ BUILD_SRC
export AS AR CC LD CPP CXX
export X_ASFLAGS X_INCDIRS X_CFLAGS X_CPPFLAGS

PHONY	+=	all clean xbegin xend xclean conf fixdep $(SRCDIRS)

ifneq ($(wildcard $(X_CONF_FILE)),)
include $(XBUILD_DIR)/conf.mk

xbegin: conf
endif

xbegin: $(objtree)/fixdep$(SUFFIX)
all: xend
xend: $(X_NAME)

$(objtree)/fixdep$(SUFFIX): $(XBUILD_DIR)/fixdep.c
	@echo [HOSTCC] $(XBUILD_DIR)/fixdep.c
ifeq ($(strip $(HOSTOS)),windows)
	@$(HOSTCC) -o $@ $< -lwsock32
else
	@$(HOSTCC) -o $@ $<
endif

$(X_NAME): $(X_OBJS)

$(X_OBJS): $(SRCDIRS) ;

ifeq ($(MAKECMDGOALS),clean)
$(SRCDIRS):
	@$(MAKE) $(build)=$@  clean
else
$(SRCDIRS): xbegin
	@$(MAKE) $(build)=$@
endif

clean: $(SRCDIRS)
ifneq ($(wildcard $(objtree)/fixdep$(SUFFIX)),)
	@echo [RM] fixdep
	@$(RM) $(objtree)/fixdep$(SUFFIX)
endif
ifneq ($(wildcard include/config),)
	@echo [RM] include/config
	@$(RM) include/config
endif
ifneq ($(wildcard $(X_NAME)),)
	@echo [RM] $(X_NAME)$(SUFFIX)
	@$(RM) $(X_NAME)$(SUFFIX)
endif
PHONY += FORCE

FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)