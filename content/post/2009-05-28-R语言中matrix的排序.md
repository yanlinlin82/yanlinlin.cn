---
title: R语言中matrix的排序
slug: matrix-sorting-in-r-language
date: 2009-05-28T00:34:00+08:00
place: 北京
tags: [ 编程, 排序, R ]
host-at: LiveSpace
---
刚才在R-help的maillist里看到有人求助matrix的排序问题，已知如下一组数据：

    2 0.5
    1 0.3
    1 0.5
    3 0.2

希望能够按第一列升序、第二列降序的方式排列，得出：

    1 0.5
    1 0.3
    2 0.5
    3 0.2

在R的帮助中找了找，竟然只有一维向量的排序，对于多维向量（矩阵或数据框）也顶多只能根据其中一行或一列排序。不知道是我眼拙，还是我接触的库太少，总之没什么收获。很快该问题有人回答，给出了如下解决方法：

    > x <- matrix( c(2, 1, 1, 3, .5, .3, .5, .2), 4)
    > x
    [,1] [,2]
    [1,] 2 0.5
    [2,] 1 0.3
    [3,] 1 0.5
    [4,] 3 0.2
    > cbind(sort(x[,1]), unlist(tapply(x[,2], x[,1], sort, decreasing = T)))
    [,1] [,2]
    11 1 0.5
    12 1 0.3
    2 2 0.5
    3 3 0.2

然而，个人感觉这种方式不是太爽，于是琢磨半天，使用了递归，写了如下函数：

    order.matrix <- function(m, columnsDecreasing = c('1'=FALSE), rows = 1:nrow(m))
    {
        if (length(columnsDecreasing) > 0)
        {
            col <- as.integer(names(columnsDecreasing[1]));
            values <- sort(unique(m[rows, col]), decreasing=columnsDecreasing[1]);
            unlist(sapply(values, function(x)
                        order.matrix(m, columnsDecreasing[-1], which((1:nrow(m) %in% rows) & (m[,col]==x)))));
        }
        else
        {
            rows;
        }
    }

运行结果：

    > m <- matrix( c(2, 1, 1, 3, .5, .3, .5, .2), 4)
    > m
    [,1] [,2]
    [1,] 2 0.5
    [2,] 1 0.3
    [3,] 1 0.5
    [4,] 3 0.2
    > m[order.matrix(m),]
    [,1] [,2]
    [1,] 1 0.3
    [2,] 1 0.5
    [3,] 2 0.5
    [4,] 3 0.2
    > m[order.matrix(m, c("1"=FALSE, "2"=TRUE)),]
    [,1] [,2]
    [1,] 1 0.5
    [2,] 1 0.3
    [3,] 2 0.5
    [4,] 3 0.2

貌似解决了根据任意多列排序的一般性问题，效果还不错，自己先得意了一下。

但很快有人给出了更简单直接的解决方法：

    > m[order(m[,1],-m[,2]),]
    [,1] [,2]
    [1,] 1 0.5
    [2,] 1 0.3
    [3,] 2 0.5
    [4,] 3 0.2

看来还是对R不够了解啊！
