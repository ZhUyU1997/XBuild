# XBuild
XBuild是一个基于Makefile的构建框架，旨在提供轻量级的编译功能。目前支持多线程，增量编译，配置。

## Examples
---
- Hello World (`examples/hello`)

```makefile
sinclude ../../scripts/env.mk

NAME		:=	hello
SRC			+=	main.c
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
- 静态库/动态库 (`examples/library`)
```makefile
sinclude ../../scripts/env.mk

#TARGET_TYPE	:=	shared
TARGET_TYPE	:=	static
NAME		:=	hello
SRC			+=	hello.c
```