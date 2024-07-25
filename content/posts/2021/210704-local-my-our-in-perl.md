---
title: Perl中的关键字local、my与our的区别
date: 2021-07-04T21:28:03+08:00
---

在Perl中，定义变量，可以使用关键字`local`、`my`或`our`。然而，它们之间究竟有什么区别呢，使用的时候，又该注意什么呢？

首先，`our`与`my`相比，字面上就是英语复数和单数的区别，暗示了变量所属的范围有不同：`our`可以在更大的范围里被使用，比如在包（package）以外：`$package_name::variable`。由此，可以把`our`所定义的变量，看成是全局变量，具有很长的生存期。它其实是在`Perl 5.6.0`版本才引入的，用来代替`use vars`的用法。所

相对地，`local`和`my`定义的都是局部变量，那它们之间的区别又如何呢？简单地说，`local`所定义的变量，可以在后续被调用的子程序中使用，而`my`定义的变量会更严格，只能在当前代码块内使用，更符合C/C++等语言的常规场景的理解。如下例子很好地展示了这个区别：

```perl
$lo = 'global';
$m  = 'global';
A();

sub A {
    local $lo = 'AAA';
    my    $m  = 'AAA';
    B();
}

sub B {
    print "B ", ($lo eq 'AAA' ? 'can' : 'cannot') ,
          " see the value of lo set by A.\n";

    print "B ", ($m  eq 'AAA' ? 'can' : 'cannot') ,
          " see the value of m  set by A.\n";
}
```

上述代码输出：

```
B can see the value of lo set by A.
B cannot see the value of m  set by A.
```

综上，为写出更易于维护的代码，优先推荐使用`my`来定义变量，避免使用`local`，造成变量“污染”到子程序中。同时，也应该避免使用`our`，毕竟，有句老话说得好：全局变量是万恶之源。

最后，Perl语言的变量作用域，可参考这篇文章，写得非常详细且清晰：[Coping with Scoping](https://perl.plover.com/FAQs/Namespaces.html)
