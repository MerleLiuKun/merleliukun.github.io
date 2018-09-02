---
title: 渣翻之NeverWriteFor-LoopsAgain
date: 2017-09-17 17:15:00
categories: python
tags: python
---

### 渣翻

文章来自Randy Daw-Ran Liou ： [Never Write For-Loops Again](https://dev.to/dawranliou/never-write-for-loops-again).

作者本人[Blog](http://dawranliou.com/)

### 正文如下

这是一个挑战，我挑战你去避免在每一个场景下写for循环。并且，我挑战你去寻找那些很难写出除了for循环之外的其他代码的场景，请分享出来。我很愿意去了解它们。
<!-- more -->

我开始探索Python语言中一些令人惊异的功能已经有一段时间了。在初始阶段，这只是一个我挑战我自己去使用更多的语言特性去代替我从其他语言上学习到的使用方法。然后事情变得很有趣。不仅仅是代码变得更加简短和干净，并且代码看起来更加的有结构和有规律。我将会在这篇文章中更深入这些益处。

但是，首先我们要退后一步去了解一下写一个for循环的直观原因：

1. 通过遍历一个序列得到一些信息
2. 通过当前序列生成一个新的序列
3. 因为我是一个程序员，所以我很自然地去写for循环

幸运的是，在Python的内置模块中已经有很多很好的工具去帮助你达到这样的目标！你要做的只是改变你的思维去从另外一个角度理解。

#### 你能在不写for循环中得到什么？

1. 更少的代码行数
2. 更好的代码可读性
3. 仅仅让缩进管理代码文本


让我们先看下面的代码结构

``` python
# 1
with ...:
    for ...:
        if ...:
	    try:
	    except:
	else:
```
		
在这个示例中，我们正在处理很多层的代码，这很难去阅读。我所发现的问题是这段代码通过给定的无处不在的缩进混合了管理逻辑(`with`和`try-except`)以及业务逻辑(`for`、`if`)。如果你只使用缩进去规范管理逻辑，那么你的业务就可以脱离出来。

> "扁平优于嵌套" - Python之禅

#### 你可以用来避免使用for循环的工具

一、列表推导式 / 生成器表达式 

我们可以先看这样一个简单的示例。你想要在一个已存在的序列上得到一个新的序列

``` python
result = []
for item in item_list:
    new_item = do_something_with(item):
    result.append(item)
```		

如果你喜欢MapReduce的话可以使用`map`或者Python拥有列表推导式。代码如下：

``` python
result = [do_something_with(item) for item in item_list]
```
	
同样的如果你想要得到一个生成器，你可以使用生成器表达式，他们的语法很类似。(你怎么能不喜爱Python的一致性呢？)代码如下：

``` python
result = (do_something_with(item) for item in item_list)
``` 

二、 函数

从一个更高阶，更实用的编码方式，如果你想要映射一个序列到另一个序列，只需要使用`map`函数。(从我的理解，可以使用列表推导式代替它)

``` python
doubled_list = map(lambda x: x * 2, old_list)
```

如果你想要将一个序列生一个最终结果。可以使用`reduce`。
``` python
from functools import reduce
	
summation = reduce(lambda x, y: x + y, numbers)
```
	
另外，很多Python的内置方法都可以使用迭代器(iterables)：
``` python
In [1]: a = list(range(10))
In [2]: a
Out[2]: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
In [3]: all(a)
Out[3]: False
In [4]: any(a)
Out[4]: True
In [5]: max(a)
Out[5]: 9
In [6]: min(a)
Out[6]: 0
In [7]: list(filter(bool, a))
Out[7]: [1, 2, 3, 4, 5, 6, 7, 8, 9]
In [8]: set(a)
Out[8]: {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
In [9]: dict(zip(a, a))
Out[9]: {0: 0, 1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9}
In [10]: sorted(a, reverse=True)
Out[10]: [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
In [11]: str(a)
Out[11]: '[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]'
In [12]: sum(a)
Out[12]: 45
...........
```
	
三、提取函数或者生成器

上面两个方法很好的处理了简单的逻辑。那么怎么去处理复杂的逻辑呢？作为一个程序员，我们经常会把困难的事情抽象成函数。同样的方法也适用与这里。如果你写下面这样的代码：

``` python
results = []
for item in item_list:
    # setups
    # condition
    # processing
    # calculation
    result.append(result)
```
	
显然的你让一段代码承担了太多的责任。取而代之的，我建议你这样做：

``` python
do process_item(item):
    # setups
    # conditions
    # processing
    # calculation
    return result
	
results = [process_item(item) for item in item_list]
```
	
嵌套循环是怎么样的呢？

``` python
results = []
for i in range(10):
    for j in range(i):
        results.appens((i, j))
```

列表表达式这样帮助你：

``` python
results = [(i, j)
           for i in range(10)
           for j in range(i)]
```

如果你想在代码中保存一些内部的状态怎么办呢？

``` python
# finding the max prior to the current item
a = [3, 4, 6, 2, 1, 9, 0, 7, 5, 8]
results = []
current_max = 0
for i in a:
    current_max = max(i, current_max)
    results.append(current_max)

# results = [3, 4, 6, 6, 6, 9, 9, 9, 9, 9]
```
	
让我们抽象成一个生成器去做到这样的功能：

``` python
def max_generatir(numbers):
    current_max = 0
    for i in numbers:
	current_max = max(i, current_max)
	yield current_max
			
a = [3, 4, 6, 2, 1, 9, 0, 7, 5, 8]
results = list(max_generator(a))
```

> Oh! 等一下， 你刚刚在代码段中使用了一个for循环， 这是欺骗！

好啦，自作聪明的家伙，让我们试一下下面的。

四、不要自己写，`itertools`已经写了

这个模块(`itertools`)简直精彩极了。我相信这个模块实现了80%的你想写for循环的情况。举个栗子， 刚才的最后一个示例可以被这样重写：
``` python
from itertools import accumulate
	
a = [3, 4, 6, 2, 1, 9, 0, 7, 5, 8]
results = list(accumulate(a, max))
```
	
当然，如果你要迭代一个组合的序列， 你可以使用`product()`、`permutations()`、`combinations()`。


### 结论

1. 你在大多数场景下是不需要写for循环的
2. 为了拥有更好的代码可读性，你应当避免使用for循环

### 行动

1. 再次查看你的代码，找到那些你凭借直觉写for循环的地方。再次思考一下，看看是否可以不使用for循环去重写它。
2. 分享你的那些很难不使用for循环的例子。

--

菜鸟级别的翻译。。见谅。嘻嘻

