---
title: R语言中的编程范型(paradigm)
slug: paradigm-in-r-language
date: 2009-05-17T14:26:00+08:00
place: 北京
tags: [ 技术 编程 R 范型 ]
host-at: LiveSpace
comments:
  -
    author: Alan Chen 
    link: http://cid-bc50ca5b7024dc31.profile.live.com/
    date: 2009-05-18
    content: 老婆，快带着孩子一起来看外星人。。。
---
为了学R，同时也为了顺带着练习练习英语，订了R-help的maillist。几个月来，每天都能收到百来封邮件，可惜时间有限，大部分邮件都被我直接跳过了。最近坚持着读了一些，学到不少东西。其中的一组邮件，让我理解了R语言中同一问题在不同范型中的解决方案。

问题是： 如何生成1000个大小为100的正态分布的数据样本？

回复中出现了一系列的解答，如：

方法1：

    > z <- list()
    > for(i in 1:1000) { z[[i]] <- rnorm(100,0,1) }

方法2：

    > z <- matrix(rnorm(1000*100), 1000, 100)

方法3：

    > z <- replicate(1000, rnorm(100))

有人觉得方法1的写法比较适合初学者理解，但是在`for`循环中做`rnorm`计算，然后再追加到`list`中，可能会很费时。然而其实这种方法的效率与直接计算`rnorm(1000*100)`的差别不是太大，有人做了如下比较：

    library(rbenchmark)
    
    n=100; m=100
    benchmark(replications=100,
    columns=c('test', 'elapsed'), order=NULL,
    list={ l=list();
    for (i in 1:n) l[[i]] = rnorm(m) },
    liist={ l=vector('list', n);
    for (i in 1:n) l[[i]] = rnorm(m) },
    matrix=matrix(rnorm(n*m), n, m),
    replicate=replicate(m, rnorm(n)) )
    # test elapsed
    # 1 list 0.247
    # 2 liist 0.235
    # 3 matrix 0.172
    # 4 replicate 0.247
    
    n=10; m=1000
    ...
    # test elapsed
    # 1 list 0.169
    # 2 liist 0.169
    # 3 matrix 0.173
    # 4 replicate 0.771
    
    n=1000; m=10
    ...
    # test elapsed
    # 1 list 1.428
    # 2 liist 0.902
    # 3 matrix 0.172
    # 4 replicate 0.185

从上述结果还能看出在样本大小与样本数量变化时，`list`的方式与`replicate`的方式各自所需要的时间的确是存在差异的。因此具体使用哪种方式，应该还是由数据和目的而定。

此后的回复邮件中，还修改了原题，每个样本的大小使用样本的序号（第一个样本含一个数据，第二个样本含两个数据，以此类推），解决的方法包含了使用`for`循环和`lapply`函数：

    x=list()
    for(i in 1:n){
        x[[i]]=rnorm(i,0,1)
    }

和

    lapply(1:100, rnorm, 0, 1)

在这两种方法中，点出了使用`for`循环与使用`lapply`函数之间的差异。在R语言中，提供了类似`lapply`的强大的函数，相当于在一个函数中就对一系列的数据循环地执行了某个操作，这种方式，其实对于像R这种解释型语言来说，是能很大程度解决运行效率问题的。然而在这里，它们的效率其实差异不大：

    benchmark(columns=c('test','elapsed'),
            for_loop = { x = list();
            for (i in 1:100) { x[[i]] = rnorm(i,0,1) } },
            lapply = lapply(1:100, rnorm, 0, 1) );
    test elapsed
    1 for_loop 0.22
    2 lapply 0.17

关键在于两种写法在对程序的理解角度不同。有人举了另一个“break 6 eggs”例子：要打破六个蛋，可以“for n from 1 to 6, break then nth egg.”（n循环从1到6，分别打破第n个蛋），也可以“apply break to the eggs”（向所有蛋都执行打破动作）。这下子，不同的写法差异，成了一个有点哲学性的问题，也就体现了不同的编程范型（paradigm）。
