---
title: MySQL中分组后选择首行
date: 2021-01-13 08:31:15+08:00
tags: [mysql, partition, group-by]
slug: mysql-select-first-row-after-grouping
---

在数据库表操作中，一个常见的需求是：如何按照创建时间，取出每天的第一条的记录。

然而，这并不是单纯依靠标准SQL语法就能完成的，而需要配合特定数据库实现的函数辅助才行。在MySQL中，这个函数即`ROW_NUMBER()`。

下面用一个临时创建的表，具体展示下用法：

```
$ mysql

mysql> create table test0113 (grp int, value float);
Query OK, 0 rows affected (0.13 sec)

mysql> insert into test0113 values (1, .1), (1, .2), (1, .3), (2, .2), (2, .4);
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> select * from test0113;
+------+-------+
| grp  | value |
+------+-------+
|    1 |   0.1 |
|    1 |   0.2 |
|    1 |   0.3 |
|    2 |   0.2 |
|    2 |   0.4 |
+------+-------+
5 rows in set (0.00 sec)
```

`ROW_NUMBER()`需要配合`OVER (PARTITION BY ... ORDER BY ...)`的语法结构，来实现所需查询：

```
mysql> select grp, value, row_number() over (partition by grp order by value) row_num from test0113 order by grp, value;
+------+-------+---------+
| grp  | value | row_num |
+------+-------+---------+
|    1 |   0.1 |       1 |
|    1 |   0.2 |       2 |
|    1 |   0.3 |       3 |
|    2 |   0.2 |       1 |
|    2 |   0.4 |       2 |
+------+-------+---------+
5 rows in set (0.00 sec)
```

有了这个结果后，再配合一层嵌套查询，就可以实现最开始的需求了：

```
mysql> select * from (select grp, value, row_number() over (partition by grp order by value) row_num from test0113 order by grp, value) t1 where row_num = 1;
+------+-------+---------+
| grp  | value | row_num |
+------+-------+---------+
|    1 |   0.1 |       1 |
|    2 |   0.2 |       1 |
+------+-------+---------+
2 rows in set (0.00 sec)
```

参考：

* [博客园：MSSQL 分组后取每组第一条（group by order by）](https://www.cnblogs.com/li5206610/p/7447338.html)
* [MySQL ROW\_NUMBER Function](https://www.mysqltutorial.org/mysql-window-functions/mysql-row_number-function/)
