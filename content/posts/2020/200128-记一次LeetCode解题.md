---
title: "记一次LeetCode解题（087-扰乱字符串）"
date: 2020-01-28T08:00:27+08:00
slug: solve-leetcode-087
tags: [ leetcode, algorithm, 递归 ]
---

## 背景

最近几个月，[每周坚持做力扣（LeetCode）的算法题](https://github.com/yanlinlin82/leetcode/)。计算机编程果然是熟能生巧的技能，目前我已经完成了八十多道力扣算法题，明显感觉到自己算法编写的能力又提升了。

今天这一篇，打算对刚完成的一道算法题做下记录，顺便写写自己的一些简单心得体会。这是[力扣第87题《扰乱字符串》](https://leetcode-cn.com/problems/scramble-string/)，其难度级别是“困难”，我也的确花了些时间，才最终完成解题，不过[最终成绩](https://leetcode-cn.com/submissions/detail/44677541/)还不错：

* 执行用时4 ms，排名超过97.87%的C++提交者。
* 内存消耗8.4MB，排名超过95.70%的C++提交者。

[![](200128-leetcode.png)](images/2020-01-28/leetcode.png)

解题尝试的具体代码（包含中间版本和最终版本）详见于：<https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/>

## 题目描述

原题是这样的（转载自力扣网站）：

> 给定一个字符串 s1，我们可以把它递归地分割成两个非空子字符串，从而将其表示为二叉树。
> 
> 下图是字符串 s1 = "great" 的一种可能的表示形式。
> 
> ```
>         great
>        /    \
>       gr    eat
>      / \    /  \
>     g   r  e   at
>                / \
>               a   t
> ```
> 
> 在扰乱这个字符串的过程中，我们可以挑选任何一个非叶节点，然后交换它的两个子节点。
> 
> 例如，如果我们挑选非叶节点 "gr" ，交换它的两个子节点，将会产生扰乱字符串 "rgeat" 。
> 
> ```
>         rgeat
>        /    \
>       rg    eat
>      / \    /  \
>     r   g  e   at
>                / \
>               a   t
> ```
>
> 我们将 "rgeat” 称作 "great" 的一个扰乱字符串。
> 
> 同样地，如果我们继续交换节点 "eat" 和 "at" 的子节点，将会产生另一个新的扰乱字符串 "rgtae" 。
> 
> ```
>         rgtae
>        /    \
>       rg    tae
>      / \    /  \
>     r   g  ta  e
>            / \
>           t   a
> ```
>
> 我们将 "rgtae” 称作 "great" 的一个扰乱字符串。
> 
> 给出两个长度相等的字符串 s1 和 s2，判断 s2 是否是 s1 的扰乱字符串。
> 
> 示例 1:
> 
> ```
> 输入: s1 = "great", s2 = "rgeat"
> 输出: true
> ```
>
> 示例 2:
> 
> ```
> 输入: s1 = "abcde", s2 = "caebd"
> 输出: false
> ```

## 我的解题过程


### 第一次尝试

代码链接：[200128-1.cpp](https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/200128-1.cpp)

解算法题，首先第一步，是正确理解题意。正确理解题意后，才能思考如何使用算法实现该过程，进而解决问题。

1. 对于这道题，最直接的做法，是按照题意的示例说明，也构造相应的二叉树。然而，二叉树的构建，尤其是枚举所有可能的不同分叉节点，会是非常耗时的做法，所以，应考虑等价效果的其他高效方法。

2. 于是，一个直接的思路是，从已经排序好的数组中，挑选一个元素，元素左边的所有元素都比该元素小，而元素右边的所有元素都比该元素大，则认为合法，否则非法。再考虑到原题设定允许二叉树的任意节点做左右交换，于是考虑这样的判断条件：“左边都小”且“右边都大”，或者“左边都大”且“右边都小”。

3. 由于二叉树的左枝和右枝，都分别是一个二叉树，于是将上述判断递归地应用于左右两个子枝，即可完成题目所需的最终判断。

4. 此外，由于输入的是字符串，要判断“都大”或“都小”，就需要把字符串转换成为整数数组，数组元素用字符所在的位置表示即可。

上述思路，就形成了这第一次尝试的代码。

代码简单说明如下：

1. 主函数`bool Solution::isScramble(string s1, string s2)`中，使用了`unordered_map`帮助，首先将字符映射成为表示位置的整数字符串：

    ```cpp
    bool isScramble(string s1, string s2) {
        unordered_map<char, int> index;
        for (int i = 0; i < s1.size(); ++i) {
            index[s1[i]] = i;
        }
        vector<int> a;
        for (int i = 0; i < s2.size(); ++i) {
            a.push_back(index[s2[i]]);
        }
        return isScramble(a, 0, a.size() - 1);
    }
    ```

2. 主函数中调用了一个重载的执行函数`bool Solution::isScramble(const vector<int>& a, int i, int j)`，用以实现递归判断，参数中给出了判断的数组范围边界（i和j分别表示左边界和右边界），使不需要每次都做繁琐耗时的数组拷贝：

    ```cpp
    bool isScramble(const vector<int>& a, int i, int j) {
        if (j - i < 2) return true;
        for (int k = i + 1; k <= j - 1; ++k) {
            if (isPartition(a, i, j, k)) {
                if (isScramble(a, i, k - 1) && isScramble(a, k + 1, j)) {
                    return true;
                }
            }
        }
        return false;
    }
    ```

3. 在上面的执行函数中，用循环依次尝试不同位置的划分，并使用了一个`bool Solution::isPartition(const vector<int>& a, int i, int j, int k)`函数，根据左右是否“都大”或“都小”，来确认划分是否正确，不正确的划分，就不需要进一步递归判断子枝了：

    ```cpp
    bool isPartition(const vector<int>& a, int i, int j, int k) {
        if (a[i] < a[k] && a[j] < a[k]) return false;
        if (a[i] > a[k] && a[j] > a[k]) return false;
        if (a[i] < a[k]) {
            for (int l = i + 1; l < k; ++l) {
                if (a[l] > a[k]) return false;
            }
            for (int l = k + 1; l < j; ++l) {
                if (a[l] < a[k]) return false;
            }
        } else {
            for (int l = i + 1; l < k; ++l) {
                if (a[l] < a[k]) return false;
            }
            for (int l = k + 1; l < j; ++l) {
                if (a[l] > a[k]) return false;
            }
        }
        return true;
    }
    ```

整个逻辑看起来不错，提交后，却发现出现“解答错误”。检查发生错误的输入内容，原来是s2字符串中有s1中不存在的字符（`s1="a", s2="b"`）。

### 第二次尝试

代码链接：[200128-2.cpp](https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/200128-2.cpp)

第二次尝试的修改很简单，真丢上面遇到的问题，在构造位置数组时，判断一下是否存在即可。如下代码所示，新增的第8行代码，就是判断s2中若存在新字符，则直接返回false：

* 代码：

    ```cpp
	bool isScramble(string s1, string s2) {
		unordered_map<char, int> index;
		for (int i = 0; i < s1.size(); ++i) {
			index[s1[i]] = i;
		}
		vector<int> a;
		for (int i = 0; i < s2.size(); ++i) {
			if (index.find(s2[i]) == index.end()) return false;
			a.push_back(index[s2[i]]);
		}
		return isScramble(a, 0, a.size() - 1);
	}
    ```

然而，这次提交也失败了，“解答错误”的输入内容是：`s1="ab", s2="aa"`。也就是说，s2中存在重复字符。的确，s2中的所有字符在s1中都出现过了，但因为重复字符，并没有对s1覆盖全呢。

### 第三次尝试

代码链接：[200128-3.cpp](https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/200128-3.cpp)

所以，接下来，自然是把s1与s2的字符是否一一对应的判断，做得更完备了。

* 代码：

    ```cpp
	bool isScramble(string s1, string s2) {
		unordered_map<char, int> index;
		for (int i = 0; i < s1.size(); ++i) {
			index[s1[i]] = i;
		}
		vector<int> a;
		unordered_map<char, int> flag;
		for (int i = 0; i < s2.size(); ++i) {
			if (index.find(s2[i]) == index.end()) return false;
			if (flag.find(s2[i]) != flag.end()) return false;
			a.push_back(index[s2[i]]);
			flag[s2[i]] = 1;
		}
		return isScramble(a, 0, a.size() - 1);
	}
    ```

然而，这次提交还是失败了，“解答错误”的输入内容是：`s1="aa", s2="aa"`。也就是说，s1中存在重复字符，于是，把字符映射成单一位置整数的做法，似乎就行不通了。

### 第四次尝试

代码链接：[200128-4.cpp](https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/200128-4.cpp)

既然“把字符映射成表示位置的整数”这条思路行不通，那么就还是考虑直接用原字符串做“二叉树节点翻转”的尝试吧。把“左右两侧的某侧，是否都大或都小”判断，改成“翻转后的字符，是否与翻转前的字符，集合上完全一致”。

在进行这个尝试前，还注意到之前的一个误解，认为需要先找到一个“相等的中间节点”，然后分别判断其“左侧”和“右侧”。然而，从题目示例给出的二叉树看，其实划分并不是发生在某个元素上，而是发生在两个元素之间的间隔上。

顺着这个思路，就有了第四次尝试的代码，使用单一函数递归即可完成判断，代码也简化了许多：

* 代码：

    ```cpp
	bool isScramble(string s1, string s2) {
		int n = s1.size(), n2 = s2.size();
		if (n != n2) return false;
		if (n == 1) return (s1 == s2);
		for (int i = 1; i < n; ++i) {
			if (isScramble(s1.substr(0, i), s2.substr(0, i)) &&
					isScramble(s1.substr(i), s2.substr(i))) {
				return true;
			}
			if (isScramble(s1.substr(0, i), s2.substr(n - i)) &&
					isScramble(s1.substr(i), s2.substr(0, n - i))) {
				return true;
			}
		}
		return false;
	}
    ```

然而，这次提交依然失败，报出了“超出时间限制”的错误。对于失败的输入，字符串本身并不长（`s1="ccabcbabcbabbbbcbb", s2="bbbbabccccbbbabcba"`），在本地测试，的确结果并不能秒回。看来，接下去需要进一步优化代码运行速度了。

### 第五次尝试

代码链接：[200128-5.cpp](https://github.com/yanlinlin82/leetcode/blob/master/00087_scramble-string/200128-5.cpp)

优化代码速度，考虑几个方面：

1. 在递归过程中，使用了字符串处理函数`substr`，重新构造了新字符串，这个过程的确很耗时，考虑使用指针和字符串长度来替代，这样整个程序中，只需要保留原字符串一个拷贝即可。
2. 对于字符串长度只有1或2的情况，若能保证字符集合相同，则肯定是能满足“二叉树翻转能得到”的，可以直接返回true，简化运算。
3. 对于是否进行分支的递归判断，应该首先判断字符集合是否相同。
4. 字符集合相同，考虑到字符取值一定是0~255（按照无符号计算），于是直接使用一个固定大小的局部数组（256长度），在s1中累加，在s2中递减，预期刚好每个字符的计数应该都减为0，若有减为负数的，说明字符集合不相同。

* 基于上述策略，得到最终的成功代码：

    ```cpp
    bool isScramble(string s1, string s2) {
        int n = s1.size(), n2 = s2.size(); if (n != n2) return false;
        return isScramble(s1.c_str(), s2.c_str(), n);
    }
    bool isScramble(const char* s1, const char* s2, int n) {
        if (n==1) return *s1 == *s2;
        if (n==2) return (*s1 == *s2 && *(s1+1) == *(s2+1)) || (*s1 == *(s2+1) && *(s1+1) == *s2);
        if (!isLetterTheSame(s1, s2, n)) return false;
        for (int i = 1; i < n; ++i) {
            if (isScramble(s1, s2, i) && isScramble(s1 + i, s2 + i, n - i)) return true;
            if (isScramble(s1, s2 + (n - i), i) && isScramble(s1 + i, s2, n - i)) return true;
        }
        return false;
    }
    bool isLetterTheSame(const char* s1, const char* s2, int n) {
        int c[256] = { 0 };
        for (int i = 0; i < n; ++i) { ++c[(unsigned int)s1[i]]; }
        for (int i = 0; i < n; ++i) { if (--c[(unsigned int)s2[i]] < 0) return false; }
        return true;
    }
    ```

## 心得小结

* 算法实现，不太容易一步到位，经常有边界条件容易被忽略，需要在后期测试过程中，充分发散考虑，并逐个进行修补。
* 对于一些基本题意，尽量不要想当然（比如假定没有重复字符等），因为这可能导致某些行不通的错误思路上浪费时间。
* 相比使用原生C语言，C++提供了诸如`vector`、`list`、`set`/`unordered_set`、`map`/`unordered_map`等基础常用数据结构，方便了各类算法实现。
* 避免数组、字符串的大量拷贝，是提高运行速度的关键。
* 递归函数是利器，通过函数参数，区分出问题的简化情况和复杂情况，对简化情况直接处理，对复杂情况则用简单情况进行构建，在代码实现上会很方便，也很有效，这有点像数学证明中的归纳法。
