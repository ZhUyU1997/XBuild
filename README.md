# XBuild
XBuild是一个基于Makefile的构建框架，旨在提供轻量级的编译功能。目前支持多线程，增量编译，配置。

## Examples
---
- Hello World (**examples/hello**)

```makefile
sinclude ../../scripts/env.mk

X_NAME		:=	hello
SRC			+=	main.c

$(X_NAME):
	@echo [OUTPUT] $(X_NAME)
	@$(CC) -o $(X_NAME) $(X_OBJS)
```