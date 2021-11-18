sinclude ../../scripts/env.mk

NAME		:=	hello.bin
SRC			+=	main.c

define CUSTOM_TARGET_CMD
echo [CUSTOM TARGET] $@;
$(CC) $(X_CFLAGS) $(X_CPPFLAGS) $(X_OBJS) -o $@ $(X_LDFLAGS) $(X_LDLIBS)
endef