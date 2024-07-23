---
title: 关于std::string的效率问题
date: 2009-07-01T10:39:00+08:00
place: 北京
tags: [ 编程, C++, std::string, 传参方式 ]
host-at: Oray
---
受CString的影响，我一直以为`std::string`也是Copy On Write机制的。可实际测试下来却不太一样：

    #include <string>
    #include <cstdio>

    int main()
    {
        std::string a = "test";
        std::string b = a;
        printf("Before modify:\n");
        printf("a = 0x%p\n", a.c_str());
        printf("b = 0x%p\n", b.c_str());

        b[2] = 'x';
        printf("After modify:\n");
        printf("a = 0x%p\n", a.c_str());
        printf("b = 0x%p\n", b.c_str());

        return 0;
    }

用VC++2008编译后运行，输出结果：

    Before modify:
    a = 0x0012FE94
    b = 0x0012FE6C
    After modify:
    a = 0x0012FE94
    b = 0x0012FE6C

用mingw-g++-4.4.0编译后运行，输出结果：

    Before modify:
    a = 0x003E3E6C
    b = 0x003E3E6C
    After modify:
    a = 0x003E3E6C
    b = 0x003E2BBC

可以发现，在不同的STL实现中，并不一定都使用Copy On Write的机制。看来，如果需要注重效率的话，还是应该尽量考虑使用`const std::string&`的方式来传递参数。
