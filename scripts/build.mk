PHONY		:=	__build
__build:

src			:=	$(obj)

obj-y		:=
subdir-y	:=
subdir_objs	:=
extra-y		:=

PREPARE		:=

SUBDIR_ASFLAGS	:=
SUBDIR_CCFLAGS	:=
SUBDIR_INCDIRS	:=

EXTRA_AFLAGS	:=
EXTRA_CFLAGS	:=

include $(XBUILD_DIR)/include.mk
sinclude include/config/auto.conf

# if ( exist  $(srctree)/$(src)/Makefile && $(srctree) != $(abspath $(srctree)/$(src)) ) == true
ifneq ($(and $(wildcard $(srctree)/$(src)/Makefile),$(patsubst $(srctree),,$(abspath $(srctree)/$(src)))),)

include $(srctree)/$(src)/Makefile

subdir-y	:=	$(patsubst %/,$(obj)/%,$(filter %/, $(obj-y)))
subdir-objs	:=	$(foreach f,$(subdir-y),$(f)/built-in.o)
cur-objs	:=	$(patsubst %,$(obj)/%,$(filter-out %/, $(obj-y)))
extra-y		:=	$(patsubst %,$(obj)/%,$(filter-out %/, $(extra-y)))

X_OBJS		:=	$(cur-objs) $(subdir-objs)

else

X_SFILES	:=	$(wildcard $(srctree)/$(src)/*.S)
X_CFILES	:=	$(wildcard $(srctree)/$(src)/*.c)

X_OBJS		:=	$(X_SFILES:.S=.o) $(X_CFILES:.c=.o)
X_OBJS		:=	$(patsubst $(srctree)/%,%,$(X_OBJS))

endif

# case: $(obj)==.
X_OBJS		:=	$(patsubst $(objtree)/%,%,$(abspath $(X_OBJS)))

X_BUILTIN	:=	$(obj)/built-in.o
X_TARGET	:=	$(X_BUILTIN) $(X_OBJS) $(extra-y)

X_DEPS		:=	$(wildcard $(foreach f,$(X_TARGET),$(dir $(f)).$(notdir $(f)).cmd))

# Create output directory
_dummy		:=	$(shell mkdir -p $(obj) $(dir $(cur-objs) $(extra-y)))

sinclude $(X_DEPS)

X_ASFLAGS	+=	$(SUBDIR_ASFLAGS)
X_CFLAGS	+=	$(SUBDIR_CCFLAGS)
X_CPPFLAGS	+=	$(SUBDIR_CPPFLAGS)

export X_ASFLAGS X_CFLAGS X_CPPFLAGS

quiet_cmd_cc_o_c = [CC] $(@:.o=.c)
cmd_cc_o_c = $(CC) $(X_CFLAGS) -MD -MF $(@D)/.$(@F).d $(X_CPPFLAGS) -c $< -o $@

quiet_cmd_as_o_S = [AS] $(@:.o=.S)
cmd_as_o_S = $(AS) $(X_ASFLAGS) -MD -MF $(@D)/.$(@F).d $(X_CPPFLAGS) -c $< -o $@

# If the list of objects to link is empty, just create an empty built-in.o
quiet_cmd_link_o_target = [LD] $(obj)/built-in.o
cmd_link_o_target = $(if $(strip $(X_OBJS)), \
		      $(LD) -r -o $@ $(filter $(X_OBJS), $^), \
		      $(RM) $@;$(AR) rcs $@)

__build : $(X_TARGET) $(PREPARE) ;

# update time
$(sort $(subdir-objs)) : $(subdir-y) ;

PHONY		+=	$(subdir-y) clean

$(subdir-y) :
ifneq ($(strip $(MAKECMDGOALS)),clean)
	@$(MAKE) $(build)=$@
else
	@$(MAKE) $(build)=$@ clean
endif

$(X_OBJS) $(extra-y) : $(PREPARE)

$(X_BUILTIN) : $(X_OBJS) FORCE
	$(call if_changed,link_o_target)

$(obj)/%.o : $(src)/%.S FORCE
	$(call if_changed_dep,as_o_S)

$(obj)/%.o : $(src)/%.c FORCE
	$(call if_changed_dep,cc_o_c)

clean: $(subdir-y)
ifneq ($(strip $(wildcard $(X_TARGET) $(X_OBJS) $(X_DEPS))),)
	@echo [RM] $(obj)/
	@$(RM) $(X_TARGET) $(X_OBJS) $(X_DEPS)
endif

PHONY += FORCE

FORCE:

.PHONY : $(PHONY)
