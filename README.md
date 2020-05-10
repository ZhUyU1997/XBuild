# XBuild (v0.2)
XBuild是一个基于Makefile的构建框架，旨在提供轻量级的编译功能。目前支持多线程，增量编译，配置。
## Usage
- 编译
```sh
make
make -j8        #多线程编译
make O=Build    #将生成文件导出到Build目录
```
- 清除目标
```sh
make clean
```
## Examples
根目录执行`make`可运行所有`examples`
- Hello XBuild (`examples/hello`)

```makefile
sinclude ../../scripts/env.mk

NAME        :=  hello
SRC         +=  main.c
```
导入`XBuild`，通常只需要在顶层Makefile设置
```makefile
sinclude ../../scripts/env.mk
```
定义最终目标
```makefile
NAME        :=  hello
```
添加需要编译的源码
```makefile
SRC         +=  main.c
```
- 静态库/动态库 (`examples/library`)
```makefile
sinclude ../../scripts/env.mk

#TARGET_TYPE    :=	shared
TARGET_TYPE :=  static
NAME        :=  hello
SRC         +=  hello.c
```
指定`TARGET_TYPE`为`static/shared`，目标输出为`静态库/动态库`。

默认为`binary`（参考Hello XBuild）。`static`会将`hello`改为`libhello.a`，`shared`会将`hello`改为`libhello.s`o或`libhello.dll`。
- 自定义命令 (`examples/custom`)

如果定义了`CUSTOM_TARGET_CMD`，最终目标会保持为原始名字，即便设置了`TARGET_TYPE`。
```makefile
sinclude ../../scripts/env.mk

NAME        :=  hello.bin
SRC         +=  main.c

define CUSTOM_TARGET_CMD
echo [CUSTOM TARGET] $@; \
$(CC) $(X_CFLAGS) $(X_CPPFLAGS) $(X_OBJS) -o $@ $(X_LDFLAGS) $(X_LDLIBS)
endef
```
注意因为一些内部实现的问题，`CUSTOM_TARGET_CMD`内容保持单行命令，需合理使用`;`和`\`。
- 编译器`flags`使用 (`examples/flags`)
```makefile
sinclude ../../scripts/env.mk

X_DEFINES   +=  HELLO=1 #定义HELLO宏，等效代码(#define HELLO 1)
X_CFLAGS    +=  -std=c11 #设置C语言标准为C11

NAME        :=  hello
SRC         +=  main.c
```
最终命令为：
```sh
gcc -std=c11 -DHELLO=1 examples/flags/main.c.o -o examples/flags/hello
```
所有`flags`如下：
```sh
X_ASFLAGS   #汇编器命令行参数
X_CFLAGS    #C编译器命令行参数
X_LDFLAGS   #链接器命令行参数
X_LIBDIRS   #库路径(e.g. libs)
X_LIBS      #依赖库(e.g. hello)
X_DEFINES   #预处理宏定义(e.g. DEBUG=1)
X_INCDIRS   #预处理头文件路径(e.g. include)
X_INCS      #预处理包含头文件(e.g. include/config.h)
INCDIRS     #用户定义预处理头文件路径
            #为了继承父级Makefile的设置，同时支持自动处理路径为命令行参数，单独定义一个变量区别于X_INCDIRS
X_INCDIRS   <- X_INCDIRS(parent define) + INCDIRS
#头文件路径命令行参数(e.g. -I include)
X_CPPFLAGS  <- X_INCDIRS + X_DEFINES + X_INCS
#预处理命令行参数(e.g. -I include -DDEBUG=1 -include include/config.h)
X_LDLIBS    <- X_LIBDIRS + X_LIBS
#链接器链接库命令行参数(e.g. -Llibs -lhello)
```
`X_INCDIRS`，`X_CPPFLAGS`，`X_LDLIBS`会自动将数据加工为编译器可以识别的命令行参数，可以避免用户繁琐的字符串处理，这也意味用户不应该主动设置这些变量。
- 模块化 (`examples/module`)
```makefile
sinclude scripts/env.mk
MODULE      +=  moduleA
MODULE      +=  moduleB
MODULE      +=  moduleC

moduleA: moduleB
moduleB: moduleC
```
定义了三个模块，`moduleA`依赖`moduleB`，`moduleB`依赖`moduleC`。

`moduleA`
```makefile
define CUSTOM_AFTER_BUILD #结束build执行此命令
echo [MOUDLE A]
endef
```
模块化支持意味着每个`Makefile`都是等价的，即便是顶层`Makefile`。


## 联系
QQ：891085309