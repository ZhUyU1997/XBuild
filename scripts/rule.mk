include $(XBUILD_DIR)/include.mk

quiet_cmd_cc_o_c = [CC] $(@:.o=)
cmd_cc_o_c = $(CC) $(X_CFLAGS) -MD -MF $(@D)/.$(@F).d $(X_CPPFLAGS) -c $< -o $@

quiet_cmd_as_o_S = [AS] $(@:.o=)
cmd_as_o_S = $(AS) $(X_ASFLAGS) -MD -MF $(@D)/.$(@F).d $(X_CPPFLAGS) -c $< -o $@

# If the list of objects to link is empty, just create an empty built-in.o
quiet_cmd_link_o_target = [LD] $(obj)/built-in.o
cmd_link_o_target = $(if $(strip $(X_OBJS)), \
		      $(LD) -r -o $@ $(filter $(X_OBJS), $^), \
		      $(RM) $@;$(AR) rcs $@)

$(obj)/built-in.o : $(X_OBJS) FORCE
	$(call if_changed,link_o_target)

$(obj)/%.S.o : $(src)/%.S FORCE
	$(call if_changed_dep,as_o_S)

$(obj)/%.c.o : $(src)/%.c FORCE
	$(call if_changed_dep,cc_o_c)

