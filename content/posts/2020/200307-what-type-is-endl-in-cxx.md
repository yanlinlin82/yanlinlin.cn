---
title: "C++中的std::endl是什么类型？"
date: 2020-03-07T08:25:20+08:00
tags: [ C++, endl, 函数 ]
---

## 问题提出

初学C++时，通常一开始会学习iostream，给出如下的`hello world`程序：

```cpp
#include <iostream>
using namespace std;

int main()
{
    cout << "Hello, world!" << endl;
    return 0;
}
```

当初没有多想，觉得其中的`endl`就像是一个全局变量。它相当于"\n"字符，只不过相比输出换行字符外，还强制做一下缓存刷新，确保内容被显示到屏幕上（或者写入文件中）。

也就是说：

```cpp
cout << endl;
```

相当于：

```cpp
cout << "\n";   // 输出换行字符
fflush(stdout); // 强制刷新标准输出设备
```

最近，突然想到一连串相关的问题：

1. 如果它是全局变量，那么它到底是个什么类型呢？
2. 同类型是否还有其它变量呢？
3. 若有，分别能执行什么功能呢？

于是，对C++ STL头文件做了搜索和调研，尝试搞清这些问题。

## 问题解决

在（我的系统中安装的）gcc-9.2.0的头文件中，找到如下定义：

```cpp
template<typename _CharT, typename _Traits>
  inline basic_ostream<_CharT, _Traits>&
  endl(basic_ostream<_CharT, _Traits>& __os)
  { return flush(__os.put(__os.widen('\n'))); }
```

答案揭晓：原来“endl”是个函数。

在C/C++中，每个函数都相当于是一个静态的全局唯一的符号。

那么，当执行`cout << endl`时，到底发生了什么呢？

于是找到如下运算符重载的定义：

```cpp
__ostream_type&
operator<<(__ostream_type& (*__pf)(__ostream_type&))
{
  // _GLIBCXX_RESOLVE_LIB_DEFECTS
  // DR 60. What is a formatted input function?
  // The inserters for manipulators are *not* formatted output functions.
  return __pf(*this);
}
```

也就是，如果给ostream（即`cout`的类型）通过运算符`<<`传入一个函数，则编译器会将其解析为运行该函数。

## 技巧解释

这是个很有趣的技巧。通过它，可以不需要定义全局变量，就能够实现类似于全局变量的效果。

为什么不直接使用全局变量呢？

考虑这样一种情况：发布一个非常简单的C++程序库。若使用全局变量，则需要考虑两个方面：

1. 如何取名，确保与其他软件包不冲突。
2. 如何将定义（即对存储空间的占用）塞入程序，这通常需要提供一个静态库（`*.a`）文件，在程序最终生成时，链接进去。

如果不使用全局变量，则可以避免上述麻烦。

当然，也可以使用类来定义临时变量，实现类似功能，例如：

```
class foo { ... };

ostream& operator<<(ostream& os, foo& x) { ...; return os; }

// 使用：

voi test()
{
    cout << foo() << endl;
}
```

但这种方式会需要在`foo`后面写出“()”，这很难看。而且更重要的，每次它都会生成临时变量，创建，然后销毁，这是很大的开销。

## 技巧应用

前段时间，我写了一个很短小的C/C++头文件，用于在终端展示带颜色的文本。当时想实现如下效果：

```cpp
cout << red << "red text " << green << "green text" << endl;
```

通过研究`endl`的类型及实现，找到了这个优雅的方法，实现了该程序库：<https://github.com/yanlinlin82/color-printf>。

为方便，该实现代码转载展示如下：

```cpp
#define COLOR_NORMAL  "\x1B[0m"
#define COLOR_RED     "\x1B[31m"
#define COLOR_GREEN   "\x1B[32m"
#define COLOR_YELLOW  "\x1B[33m"
#define COLOR_BLUE    "\x1B[34m"
#define COLOR_MAGENTA "\x1B[35m"
#define COLOR_CYAN    "\x1B[36m"
#define COLOR_WHITE   "\x1B[37m"

namespace cc // colorized characters
{
	class normal_t {}; void normal (normal_t ) { }
	class red_t    {}; void red    (red_t    ) { }
	class green_t  {}; void green  (green_t  ) { }
	class yellow_t {}; void yellow (yellow_t ) { }
	class blue_t   {}; void blue   (blue_t   ) { }
	class magenta_t{}; void magenta(magenta_t) { }
	class cyan_t   {}; void cyan   (cyan_t   ) { }
	class white_t  {}; void white  (white_t  ) { }
	std::ostream& operator << (std::ostream& os, void(*)(normal_t )) { return (os << COLOR_NORMAL ); }
	std::ostream& operator << (std::ostream& os, void(*)(red_t    )) { return (os << COLOR_RED    ); }
	std::ostream& operator << (std::ostream& os, void(*)(green_t  )) { return (os << COLOR_GREEN  ); }
	std::ostream& operator << (std::ostream& os, void(*)(yellow_t )) { return (os << COLOR_YELLOW ); }
	std::ostream& operator << (std::ostream& os, void(*)(blue_t   )) { return (os << COLOR_BLUE   ); }
	std::ostream& operator << (std::ostream& os, void(*)(magenta_t)) { return (os << COLOR_MAGENTA); }
	std::ostream& operator << (std::ostream& os, void(*)(cyan_t   )) { return (os << COLOR_CYAN   ); }
	std::ostream& operator << (std::ostream& os, void(*)(white_t  )) { return (os << COLOR_WHITE  ); }
}
```

这里用到C/C++编译器的一个特点，每个不同名称的`class XXX { ... };`，即使其内容和结构看起来完全相同，也都是不同的类型。所以，上述`normal_t`和`red_t`看起来都是相同的空类，其实它们是不同的类型。也因此，`normal`和`red`，因为传入参数的类型不同，就成为了不同类型的函数，进而可以用于`operator<<`的重载。

## 小结

* `std::endl`是一个函数。
* 函数本质上是一种特殊的全局变量，充分利用它的特点，结合C++的类型推断，可以帮助软件库的开发，提高库用户的易用性。
