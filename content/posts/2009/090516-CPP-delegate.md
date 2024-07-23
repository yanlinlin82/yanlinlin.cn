---
title: C++中的delegate
date: 2009-05-16T21:15:00+08:00
place: 北京
tags: [ 编程, boost, C#, C++, delegate ]
host-at: LiveSpace
---
在C#中，一个比较漂亮的语法就是delegate，它的“+=”操作符很优雅地使众多事件订阅者能够被一个调用所触发。如：

    class Program
    {
        delegate void DelegateFoo();
    
        static void Foo() { Console.WriteLine("Foo"); }
    
        static void Foo2() { Console.WriteLine("Foo2"); }
    
        static void Main()
        {
            DelegateFoo d = new DelegateFoo(Foo);
            d += Foo2;
            d();
        }
    }
    
    // Output:
    //   Foo
    //   Foo2

这项语法，被很多C#使用者大为称道。其实在C++的boost库中，也有同样功能的实现，一点不比C#的delegate差，那就是boost::signal：

    #include <iostream>
    #include <boost/signal.hpp>
    
    void Foo() { std::cout << "Foo" << std::endl; }
    
    void Foo2() { std::cout << "Foo2" << std::endl; }
    
    int main()
    {
        boost::signal<void ()> s;
        s.connect( Foo );
        s.connect( Foo2 );
        s();
        return 0;
    }
    
    // Output:
    //   Foo
    //   Foo2

## 参考：

1. <http://msdn.microsoft.com/en-us/library/aa288459(VS.71).aspx>
2. [http://www.boost.org/doc/libs/1\_39\_0/doc/html/signals/tutorial.html#id3341837](http://www.boost.org/doc/libs/1_39_0/doc/html/signals/tutorial.html#id3341837)

> 评论（备份自LiveSpace）：
> 
> * 2009-05-18 - [Alan Chen](http://cid-bc50ca5b7024dc31.profile.live.com/): 小疯想说这个能做那个也能做？<br>没必要吧，不同点仅仅是使用者的习惯吧
> * 2009-05-18 - 颜林林: “这个能做那个也能做”的确是小疯想表达的一层意思。毕竟delegate受限于C++语法而难以直接实现，而boost却实现了大量类似的C++奇迹，不得不让人称赞。<br>
> C++（和boost）的这种伸缩性，使得它即使在诸如开发企业应用等“非擅长”的领域，也并不比公认的C#等语言差太多。<br>
> 表面上看是使用习惯不同，实质上是编程思想的差异。<br>
> 总结下来，每一件神器都是有灵性的，能发挥多大法力，关键还在于使用者的修炼。
