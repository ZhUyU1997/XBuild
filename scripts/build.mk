PHONY		:=	__build
__build:

src			:=	$(obj)

SRC			:=
NAME		:=
MODULE		:=

X_NAME		=	$(if $(NAME),$(obj)/$(NAME)$(SUFFIX))
X_MODULE	=	$(patsubst %/,$(obj)/%,$(MODULE))
X_SUBDIR	:=
X_SUB_OBJ	:=
X_EXTRA		:=
X_PREPARE	:=

include $(XBUILD_DIR)/include.mk
sinclude $(X_CONF_DIR)/auto.conf


ifneq ($(wildcard $(srctree)/$(src)/Makefile),)
include $(srctree)/$(src)/Makefile
else
SRC			:=	*.S *.c
endif # ifneq ($(wildcard $(srctree)/$(src)/Makefile),)

ifeq ($(ISMODULE),0)
X_BUILTIN	:=	$(obj)/built-in.o
endif

X_CUR_OBJ	:=	$(foreach f,$(filter-out %/, $(SRC)),$(wildcard $(srctree)/$(src)/$(f)))
X_CUR_OBJ	:=	$(patsubst $(srctree)/$(src)/%,$(obj)/%.o,$(X_CUR_OBJ))
X_SUBDIR	:=	$(filter %/,$(foreach f,$(filter %/, $(SRC)),$(wildcard $(srctree)/$(src)/$(f))))
X_SUB_OBJ	:=	$(patsubst $(srctree)/$(src)/%/,$(obj)/%/built-in.o,$(X_SUBDIR))

X_OBJS		:=	$(X_CUR_OBJ) $(X_SUB_OBJ)
# case: $(obj)==.
X_OBJS		:=	$(patsubst $(objtree)/%,%,$(abspath $(X_OBJS)))
X_TARGET	:=	$(X_BUILTIN) $(X_OBJS) $(X_EXTRA)
X_DEPS		:=	$(wildcard $(foreach f,$(X_TARGET),$(dir $(f)).$(notdir $(f)).cmd))

# update time
$(sort $(X_SUB_OBJ)) : $(X_SUBDIR) ;
PHONY		+=	$(X_SUBDIR) $(X_MODULE)

$(X_OBJS) $(X_EXTRA) : $(X_PREPARE)
clean: $(X_SUBDIR) $(X_MODULE)

$(X_SUBDIR):
	@$(MAKE) $(build)=$@ ISMODULE=0 $(MAKECMDGOALS)
$(X_MODULE):
	@$(MAKE) $(build)=$@ ISMODULE=1 $(MAKECMDGOALS)

# Create output directory
_dummy		:=	$(shell $(MKDIR) $(obj) $(dir $(X_TARGET)))

PHONY		+=	clean

sinclude $(X_DEPS)

export X_ASFLAGS X_CFLAGS X_CPPFLAGS

__build : $(X_TARGET) $(X_NAME) $(X_MODULE);

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
