---
title: Python中常见的坑
date: 2017-08-18 00:32:17
categories: Python
tags: python
---
简介
===
在Python中也会有很多陷阱，在网上看到一篇文章，在此处记录以下，菜鸡翻译。 [参考来源](#references)在下方。

问题集合
===

类变量问题
---

<!-- more -->
下面的代码将会输出什么？ 并解释。

``` python
def extend_list(value, my_list=[]):
   	my_list.append(value)
    return my_list

list1 = extend_list(10)
list2 = extend_list(123, [])
list3 = extend_list('a')

print('list1 is: {}'.format(list1))
print('list2 is: {}'.format(list2))
print('list3 is: {}'.format(list3))
```

答案揭晓：

``` python
# output:
list1 is: [10, 'a']
list2 is: [123]
list3 is: [10, 'a']
```
		
许多人会误认为`list1`输出`[10]`,`list3`将会输出`['a']`，以为参数`my_list`将会在调用`extend_list`函数的使用被设置为默认的值`[]`.

然而并非如此。在实际上发生的事情是，一个新的列表**只会**在函数被定义的时候创建一次。并且在`extend_list`函数被调用的时候，如果没有指定`my_list`的参数，那么它们将会使用同一个列表(也就是定义的时候初始化的那个)。

所以上边的例子中，`list1`和`list3`操作的是同一个列表。而`list2`则是在它自己创建的空列表中进行操作(通过把自己的空列表作为函数的参数传递给了函数)。

那么我们该如何修改上边的函数定义？来让它实现我们期望的功能呢？
修改函数定义如下：

``` python
def extend_list(value, my_list=None):
    if my_list is None:
        my_list = []
    my_list.append(value)
    return my_list
```

就是说如果在没有指定`my_list`参数的值时，我们重新创建一个空列表。

输出如下：

``` python	
list1 is: [10]
list2 is: [123]
list3 is: ['a']
```

> Tips：我在Pycharm中写这样的代码时， 还有一个警告信息，信息的内容大致就是上边我们所说的会出现的这种问题。神奇！！

late binding(后期绑定)的问题
---

下面的代码会输出什么？ 请解释。

``` python
def multipliers():
    return [lambda x: i * x for i in range(4)]

print([m(2) for m in multipliers()])
```

答案揭晓：

``` python
# output:
[6, 6, 6, 6]
```

是不是有点慌？程序的输出不是我们期待的`[0, 2, 4, 6]`而是`[6, 6, 6, 6]`。

这个原因主要是Python闭包的后期绑定[late binding](https://en.wikipedia.org/wiki/Late_binding)造成的。这就意味着在闭包中变量的值是在内部函数被调用的时候才去寻找的。

所以造成的结果就是，在任何时候由`multiplers()`函数返回的函数集合被调用，变量`i`的值才会在那个时候去从它被调用时的作用域中查找。

在那时，不管在被返回的函数集合中的哪个函数被调用，`for`循环是已经完成的，而变量`i`已经被指定为了最终的值3。因此，被返回的函数集合中的每个函数中的`i`都是3，
所以在参数2被传递进入函数中，函数执行的操作其实是`2*3`，也就是6。

顺便说一点，就像[The Hitchhiker’s Guide to Python](http://docs.python-guide.org/en/latest/writing/gotchas/)指出的那样，人们存在一个误解，以为这种问题是由`lambda`函数造成的，其实不然，由`lambda`关键字创建的函数和由`def`关键字创建的函数是没什么不一样的。

下面我们给出一些解决这种问题的方法。

1.使用Python的生成器

``` python
def multipliers():
   	for i in range(4):
       	yield lambda x: i * x
```

2.创建一个闭包，通过使用默认参数立即绑定到它的参数上。

``` python
def multipliers():
   	return [lambda x, i=i: i * x for i in range(4)]
```

3.使用`funtiontoos`模块中的`partial`进行改写。

``` python
from functools import partial
from operator import mul

def multipliers():
    return [partial(mul, i) for i in range(4)]
```

4.在其他资料上我也发现了另外一种方法。

``` python
def multipliers():
   	return (lambda x: i * x for i in range(4))	
```

类变量的问题
---

下面的代码会输出什么？请解释。

``` python	
class Parent(object):
    x = 1

class ChildFirst(Parent):
    pass
		
class ChildSecond(Parent):
    pass
	
print(Parent.x, ChildFirst.x, ChildSecond.x)
ChildFirst.x = 2
print(Parent.x, ChildFirst.x, ChildSecond.x)
Parent.x = 3
print(Parent.x, ChildFirst.x, ChildSecond.x)
```

答案揭晓：

``` python	
1 1 1
1 2 1
3 2 3
```

WTF? 为什么最后一行输出不是`3 2 1`而是`3 2 3`? 为什么改变了`Parent.x`的值竟然也改变了`ChildSecond.x`的值。但是却没有改变`ChildFirst.x`的值？

这个问题的答案的关键是： 在Python中，类变量在内部是作为字典来处理的。

如果一个变量名没有在当前类的变量字典中找到，就会去搜索父类的变量字典，如果在一直延续到在顶层的祖先类的字典中也没有找到该变量。就会报出一个`AttributeError`的异常。

因此，在`Parent`中设置了类变量`x=1`，在该类和其任何子类的的变量引用中生效`x=1`.这就是为什么第一行输出`1 1 1`。

然后，如果某一个子类重写了这个变量，就像我们执行了`ChildFirst.x=2`，这个值会仅仅在这个子类中发生变化。这就是为什么第二行输出`1 2 1`。

最后，如果在父类`Parent`中改变。就会使得所有没有重写这个变量的子类中的该变量的值发生变化。就是最后一行输出`3 2 3`的原因。

除法操作的问题
---

下面的代码在Python2环境下输出是什么？ 请解释.

``` python	
def div1(x, y):
    print "{}/{}={}".format(x, y, x/y)

def div2(x, y):
    print "{}/{}={}".format(x, y, x//y)

div1(5,2)
div1(5.,2)
div2(5,2)
div2(5.,2.)
```

答案揭晓：

``` python	
5/2 = 2
5.0/2 = 2.5
5//2 = 2
5.0//2.0 = 2.0
```

默认情况下，如果两个操作数都是整数，Python2就会自动执行整型计算，
所以结果是`5/2=2`, 然后`5./2=2.5`.

注意，你可以在Python中重载这个方法达到在Python3中输出的结果，通过以下方式

``` python
from __future__ import division
```

此时输出：

``` python
5/2 = 2.5
5.0/2 = 2.5
5//2 = 2
5.0//2.0 = 2.0
```

并且注意 双斜线`//`操作符一直执行整型运算，所以在Python2中输出`5.0//2.0 = 2.0`。

在Python3中输出是和上边引入`division`的输出是一致的。

注意，在Python3中`/`操作符是做浮点除法，而`//`是做整除(保留商，余数舍弃)，有意思的是： Python3中`(-7) // 3 = -3`因为它的整型运算是向更小的数值取值(即向下取整)。例`7 // 2 = 2`。

列表的问题1
---

下面代码会输出什么？

``` python
my_list = ["a", "b", "c", "d", "3"]
print(my_list[10:])
```

答案揭晓：

``` python
# output:
[]
```

上边的代码会输出`[]`,而不是一个`IndexError`的异常。

正如人们所预料的， 试图使用超过成员数量的索引访问列表的成员(eg..my_list[10])会报出IndexError异常。

但是试图以一个超出列表成员数量的索引作为开始索引的切片操作不会导致下标异常，仅仅是返回一个空列表。

一个特别严重的问题是，它可能导致的错误，但是很难追踪到，因为它并没有出现运行错误。

列表的问题2
---

思考下面的代码片段：

``` python
1. list = [ [ ] ] * 5
2. list  # output?
3. list[0].append(10)
4. list  # output?
5. list[1].append(20)
6. list  # output?
7. list.append(30)
8. list  # output?
```

答案揭晓：

``` python
[[], [], [], [], []]
[[10], [10], [10], [10], [10]]
[[10, 20], [10, 20], [10, 20], [10, 20], [10, 20]]
[[10, 20], [10, 20], [10, 20], [10, 20], [10, 20], 30]
```

第一行的输出是直观的，也很容易理解，仅仅是创建了5个列表的列表。

但是，理解问题的关键是`list = [ [ ] ] * 5`并不是创建了5个不同的列表，而是对一个列表的5个引用，有了这层理解我们对下面的输出就好理解了。

`list[0].append(10)`在第一个列表中添加了元素10， 其他列表都是对同一个列表的引用，所以输出如上。

同样的道理，第二个列表添加了元素20，也是对同一个列表进行的操作。

相反，`list.append(30)`则是添加了一个元素到外层列表中，也就是说， 30是和剩下的5个列表同一层级的(个人理解)。所以输出如上。

列表的问题3
---

给定n个数的列表，使用单列表理解来生成只包含如下这些值的新列表。

1. 偶数
2. 索引也是偶数

我们可以采用如下代码完成这个工作：

``` python
[x for x in my_list[::2] if x % 2 == 0]
```

示例：

``` python
my_list = [ 1 , 3 , 5 , 8 , 10 , 13 , 18 , 36 , 78 ]
new_list = [x for x in my_list[::2] if x % 2 == 0]
#output:
[10, 18, 78]
```

参考文章
=== 
<a name="references"></a>

> https://www.toptal.com/python/interview-questions  
> http://docs.python-guide.org/en/latest/writing/gotchas/


