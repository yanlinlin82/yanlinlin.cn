---
title: CMake快速入门
date: 2020-01-23 23:20:26+08:00
tags: [cmake]
slug: cmake-quick-start
---

我一直习惯于使用GNU Make来构建项目，对于单一Linux环境而言，这种方式基本是足够的。我自己也大致积累了一些固定的技巧写法（可参考我在[项目seqpipe-5中的Makefile](https://github.com/yanlinlin82/seqpipe/blob/cpp-v0.5/Makefile)），包括判断gcc版本、自动判断文件依赖关系、单元测试等。可惜这些技巧多依赖于Linux系统本身，缺乏跨平台的可移植性，为了未雨绸缪，决定了解下诸如CMake的跨平台构建系统。

## 基本概念

CMake其实是一个根据规则生成Makefile文件的构建系统（当然其实它也可以生成其他构建环境的规则文件），相当于是一套更抽象（或者说更高级）的Make规则的定义语法。

作为快速入门，可以生成如下两个文件：

* hello.cpp

    ```cpp
    #include <iostream>
    using namespace std;

    int main()
    {
        cout << "Hello, world!" << endl;
        return 0;
    }
    ```

* CMakeLists.txt

    ```cmake
    add_executable(hello hello.cpp)
    ```

这样，就完成了一个最简化的cmake示例。接下来，就可以使用cmake对它进行构建：

```sh
$ mkdir build
$ cd build
$ cmake ..
$ make
```

## 进阶：配置版本

新增一个配置文件模板：

* config.h.in

    ```cpp
    #define HELLO_VERSION_MAJOR @Hello_VERSION_MAJOR@
    #define HELLO_VERSION_MINOR @Hello_VERSION_MINOR@
    ```

修改C++程序，打印出该版本号：

* hello.cpp

    ```cpp
    #include "config.h"
    #include <iostream>
    using namespace std;

    int main()
    {
        cout << "Hello, world!" << endl;
        cout << HELLO_VERSION_MAJOR << "." << HELLO_VERSION_MINOR << endl;
        return 0;
    }
    ```

修改CMakeLists.txt，定义项目名称和版本：

* CMakeLists.txt

    ```cmake
    cmake_minimum_required(VERSION 3.14)
    project(Hello VERSION 1.0)

    add_executable(hello hello.cpp)

    configure_file(config.h.in config.h)
    target_include_directories(hello PUBLIC "${PROJECT_BINARY_DIR}")
    ```

由于需要由模板`config.h.in`生成`config.h`，而生成的`config.h`并不在原代码目录，而在构建目录（`build/`）中，所以需要用`target_include_directories`将该目录加入include中，以便编译器能够正确识别。

此外，如果没有第一行（`cmake_minimum_required`），`cmake ..`会报如下错误：

```
Make Error at CMakeLists.txt:1 (project):
  VERSION not allowed unless CMP0048 is set to NEW

CMake Warning (dev) in CMakeLists.txt:
  No cmake_minimum_required command is present.  A line of code such as

    cmake_minimum_required(VERSION 3.14)

  should be added at the top of the file.  The version specified may be lower
  if you wish to support older CMake versions for this project.  For more
  information run "cmake --help-policy CMP0000".
This warning is for project developers.  Use -Wno-dev to suppress it.

-- Configuring incomplete, errors occurred!
```

## 规范：工具要求

CMake还可以用于帮助检查编译环境是否符合要求，比如，检查C++11标准支持：

* CMakeLists.txt

    ```
    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED True)
    ```

## 其他

今天还看到另一篇文章，介绍CMake 3中的新特性的：《[Modern CMake is like inheritance](https://kubasejdak.com/modern-cmake-is-like-inheritance)》。文章提到，关于编译目标的属性，可以用面向对象的方式进行属性定义和继承。

CMake系统中，已经集成了很多常见的系统构建相关功能支持，后续继续深入学习，就可以不用每个方面都自己再从头去发明轮子了。

## 参考

1. [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
2. [Wikipedia: CMake](https://en.wikipedia.org/wiki/CMake)
3. [Modern CMake is like inheritance](https://kubasejdak.com/modern-cmake-is-like-inheritance)
