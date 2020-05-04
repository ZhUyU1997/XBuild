# XBuild
XBuild是一个基于Makefile的构建框架，旨在提供轻量级的编译功能。目前支持多线程，增量编译，配置。

## Examples
---
- Hello World (`examples/hello`)

```makefile
sinclude ../../scripts/env.mk

NAME		:=	hello
SRC			+=	main.c

$(X_NAME):
	@echo [OUTPUT] $(X_NAME)
	@$(CC) -o $(X_NAME) $(X_OBJS)
```
导入`XBuild`，通常只需要在顶层Makefile设置
```makefile
sinclude ../../scripts/env.mk
```
定义最终目标
```makefile
NAME		:=	hello
```
添加需要编译的源码
```makefile
SRC			+=	main.c
```
定义最终目标的规则
```makefile
$(X_NAME):
	@echo [OUTPUT] $(X_NAME)
	@$(CC) -o $(X_NAME) $(X_OBJS)
```
应该注意到这里使用了`X_NAME`，而非`NAME`。通常`X_`开头的表示`XBuild`内部变量。

`X_NAME`会自动添加后缀名，例如在Windows平台，`X_NAME=hello.exe`	。

`X_OBJS`则代表此模块所有的`.o`文件。在本例中`X_OBJS=hello.o`。