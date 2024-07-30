---
title: flat_set的性能测试及其实现
date: 2024-01-15T11:22:00+08:00
categories: [ 公众号文章, 编程 ]
tags: [ 不靠谱颜论， C++ ]
---

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0115/01.png" alt="题图" style="max-width:640px">
  <div><small>（题图由AI生成）</small></div>
</div>

之前在《[从flat_set管窥C++的价值权衡](/2024/01/07/从flat_set管窥c-的价值权衡/)》中没放代码，今天补上（照惯例，文末“阅读原文”可跳转至GitHub完整源码）。

如前所述，flat_set 的用法与 std::set 几乎完全一样，差别主要在于内存布局和性能。由于 flat_set 能保证所包含的元素按次序存储在连续内存空间中，因此，它（的迭代器）还允许进行随机访问。下面的例子展示了基本用法：

```cpp
#include <boost/container/flat_set.hpp> // 或 <flat_set>
#include <set>
#include <iostream>

int main()
{
  std::flat_set<int> fs;
  fs.insert(1);
  fs.insert(2);
  fs.insert(3);
  for (int e : fs) {
    std::cout << e << std::endl;
  }
  // 下面是随机访问的示例（迭代器加上一个整数）
  std::cout << "The second: " << *(fs.begin() + 1) << std::endl;

  std::set<int> ss;
  fs.insert(1);
  fs.insert(2);
  fs.insert(3);
  for (int e : fs) {
    std::cout << e << std::endl;
  }
  // 对于std::set，则不允许这样的随机访问，下面的语句会导致编译器报错
  //std::cout << "The second: " << *(ss.begin() + 1) << std::endl;

  return 0;
}
```

接下来是重点，性能测试，这里只展示主要的部分代码：

```cpp
#if __cplusplus < 202002L
#include <boost/container/flat_set.hpp>
namespace std {
  using boost::container::flat_set;
}
#endif
```

上面这几句是为了兼容在正式将 flat_set 引入 C++ 标准之前，使用 boost 库中的相应实现进行代替。

```cpp
std::vector<int> generateRandomData(size_t size) {
    std::vector<int> data(size);
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, 1000000);

    for (auto& d : data) {
        d = dis(gen);
    }
    return data;
}
```

上面这个函数用于生成一组随机数，以便将其分别用于 std::set 和 flat_set 的测试。

```cpp
template<typename SetType>
void performTest(SetType& testSet, const std::vector<int>& data) {
  // 插入操作
  auto start = std::chrono::high_resolution_clock::now();
  ...
  auto end = std::chrono::high_resolution_clock::now();
  std::cout << "Insert time: " << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() << " microseconds\n";
 
  // 查找操作
  ...
 
  // 迭代操作
  ...
}
```

上面的函数是测试主体内容，使用了模板函数，从而可以确保对不同的类型（flat_set 和 std::set）分别进行同样的测试。函数中测试了插入、查找和迭代遍历的操作，分别在操作前后使用 std::chrono::high_resolution_clock::now() 获取精确时间，从而计算并打印出每个操作的执行时间。

主函数中的内容如下：

```cpp
int main() {
  const size_t TEST_SIZE = 1000000; // 调整测试数据的大小
  auto data = generateRandomData(TEST_SIZE); // 为公平比较，需确保处理相同的随机数据
 
  std::cout << "Testing flat_set...\n";
  std::flat_set<int> fs;
  performTest(fs, data);
 
  std::cout << "\nTesting std::set...\n";
  std::set<int> ss;
  performTest(ss, data);
 
  ...
  return 0;
}
```

程序执行的结果如下：

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0115/02.png" alt="" style="max-width:350px">
</div>

可以看到，flat_set 在查找和迭代遍历的速度，都明显快于 std::set，但相应做出的牺牲，则是在数据插入上，明显慢于 std::set。因此，可以知道，对于修改少但访问频繁的数据（这种场景在现实中应该还是相当常见的），是应该考虑使用 flat_set 来代替 std::set 的。
当然，具体使用哪种容器类，还需要依赖于最终所处理的数据，如果对性能要求较高，则应该选取有代表性的实际数据进行测试，来帮助决定。而 STL 统一了各种容器的常见操作接口，让容器之间选择替换变得非常容易，这也是我们应该优先使用标准库的实现，而如果我们自行实现，也应该尽量遵守标准库的规范来进行的重要原因。
测试代码还同时展示了两个集合类的前五个元素的地址，能看到 flat_set 的地址的确都是连续的，而 std::set 则不是。
最后，再来说说实现（这里可以看看 boost 中的实现）：

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0115/03.png" alt="" style="max-width:640px">
</div>

为方便展示，这里使用了来自ClickHouse的截图。想查看和学习相应实现的，也推荐使用这个网址在线浏览学习代码（https://clickhouse.com/codebrowser/ClickHouse/contrib/boost/boost/container/flat_set.hpp.html）。
从上面的代码中可以看到，flat_set::insert() 调用了其成员变量 tree_t 的 insert_unique() 方法。该成员变量的类型，来自于 boost 库的底层实现支持，之所以这么封装，是因为它还可以同时用于支持其他 flat_xxx 类型（如 flat_map）的实现。

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0115/04.png" alt="" style="max-width:640px">
</div>

我们继续深入到 flat_tree::insert_unique() 中：

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0115/05.png" alt="" style="max-width:640px">
</div>

可以看到，该插入其实分为三个步骤：(1) 在容器末尾插入新元素；(2) 快速排序；(3) 将重复元素去掉。这里的步骤二（排序）是最耗时的，也因此使用了通常被认为效率最高的快速排序方法，来确保时间复杂度为 O(n * log(n))。
这个分步骤的做法，看起来很绕，但其实它是 STL / boost 中常见的套路，类似于那个“数学家当消防员”的笑话：

> 一天，数学家觉得自己受够了数学，于是他跑去消防队当消防员。  
> 消防队长说：“您看上去不错，可是我得先给您一个测试。”  
> 消防队长带数学家到消防队后院小巷，巷子里有一个货栈，一只消防栓和一卷软管。  
> 消防队长问：“假设货栈起火，您怎么办？”  
> 数学家回答：“我把消防栓接到软管上，打开水龙，把火浇灭。”  
> 消防队长说：“完全正确。最后一个问题：假设您走进小巷，而货栈没有起火，您怎么办？”  
> 数学家疑惑地思索了半天，终于答道：“我就把货栈点着。”  
> 消防队长大叫起来：“什么？太可怕了，您为什么要把货栈点着？”  
> 数学家回答：“这样我就把问题化简为一个我已经解决过的问题了。”

在数学中，这种思考方式被称为化归。

STL / boost 常把各种看似复杂的算法，都化归到很少的几个底层算法去。于是，这些底层算法被大量使用和测试，形成了今天稳定的、容错性极好的基础库。这些库对于应付大多数情况而言，是绰绰有余的。而真当性能仍然不足以达到要求时，就得考虑根据自己实际需求进行重新实现了。

<div class="p-5 text-center">--- END ---</div>

<i><b>注：</b>本文首发表于[“不靠谱颜论”公众号](https://mp.weixin.qq.com/s/wJLsQVTZnqB2gWGYsZaMPg)，并同步至本站。</i>
