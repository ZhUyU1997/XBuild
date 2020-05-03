PHONY		:=	__build
__build:

src			:=	$(obj)

SRC			:=

X_SUBDIR	:=
X_SUB_OBJ	:=
X_EXTRA		:=
X_PREPARE	:=

include $(XBUILD_DIR)/include.mk
sinclude $(X_CONF_DIR)/auto.conf

ifeq ($(X_NAME),)
X_BUILTIN	:=	$(obj)/built-in.o
endif

ifneq ($(wildcard $(srctree)/$(src)/Makefile),)
include $(srctree)/$(src)/Makefile

X_SUBDIR	:=	$(patsubst %/,$(obj)/%,$(filter %/, $(SRC)))
X_SUB_OBJ	:=	$(foreach f,$(X_SUBDIR),$(f)/built-in.o)
X_CUR_OBJ	:=	$(patsubst %,$(obj)/%.o,$(filter-out %/, $(SRC)))
X_EXTRA		:=	$(patsubst %,$(obj)/%.o,$(filter-out %/, $(X_EXTRA)))

X_OBJS		:=	$(X_CUR_OBJ) $(X_SUB_OBJ)

# update time
$(sort $(X_SUB_OBJ)) : $(X_SUBDIR) ;
PHONY		+=	$(X_SUBDIR)

$(X_OBJS) $(X_EXTRA) : $(X_PREPARE)
clean: $(X_SUBDIR)

$(X_SUBDIR) :
	@$(MAKE) $(build)=$@ $(MAKECMDGOALS)

else

SRC			:=	$(wildcard $(srctree)/$(src)/*.S) $(wildcard $(srctree)/$(src)/*.c)
X_OBJS		:=	$(patsubst $(srctree)/$(src)/%,$(obj)/%.o,$(filter-out %/, $(SRC)))
endif # ifneq ($(wildcard $(srctree)/$(src)/Makefile),)

# case: $(obj)==.
X_OBJS		:=	$(patsubst $(objtree)/%,%,$(abspath $(X_OBJS)))
X_TARGET	:=	$(X_BUILTIN) $(X_OBJS) $(X_EXTRA)
X_DEPS		:=	$(wildcard $(foreach f,$(X_TARGET),$(dir $(f)).$(notdir $(f)).cmd))

# Create output directory
_dummy		:=	$(shell $(MKDIR) $(dir $(X_TARGET)))

PHONY		+=	clean

sinclude $(X_DEPS)

export X_ASFLAGS X_CFLAGS X_CPPFLAGS

__build : $(X_TARGET) $(X_NAME);

$(X_NAME): $(X_TARGET)

clean:
ifneq ($(strip $(wildcard $(X_TARGET) $(X_DEPS) $(X_NAME))),)
	@echo [RM] $(obj)
	@$(RM) $(X_TARGET) $(X_DEPS) $(X_NAME)
endif

include $(XBUILD_DIR)/rule.mk

PHONY += FORCE

FORCE: ;

.PHONY : $(PHONY)
