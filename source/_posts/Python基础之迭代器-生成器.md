---
title: Python基础之迭代器+生成器
date: 2017-08-06 23:31:57
categories: Python
tags: python
---

迭代器(iterator)
===

简介
---

迭代器是访问集合内元素的一种方式。迭代器对象从集合的第一个元素开始访问，直到所有的元素都被访问一遍后结束。

- 优点：

	1. 对于无法随机访问的数据结构(比如set)而言,迭代器是唯一的访问元素的方式。
	2. 迭代器不要求你事先准备好整个迭代过程的所有的元素，它仅仅是在迭代至某一个元素时才计算该元素。在这之前或者之后，元素可以不存在或者被销毁。适合巨大的或者无限的集合。
	3. 迭代器提供了一个统一的访问集合的接口。只要实现了__iter__()方法的对象，就可以使用迭代器进行访问。

<!-- more -->

- 缺点
	
	1. 迭代器无法回退，只能向前进行迭代。
	2. 迭代器不是线程安全的，在多线程环境中对可变集合使用迭代器是一个危险的操作。
	
简单使用
---
使用内建函数`iter`可以从可迭代的对象中获得迭代器。

	>>it = iter([1, 2, 3])
	>>it.next()
	1
	>>it.next()
	2
上述的`it.next()`可以使用`next(it)`替换。

如果迭代到最后一位后，再调用`it.next()`就会出现`StopIteration`的异常。但是我们可以通过检测到异常信息，来退出迭代器。

使用迭代器的循环可以避开索引，但有时候我们还是需要索引来进行一些操作的。这时候内建函数enumerate就派上用场咯，它能在iter函数的结果前加上索引，以元组返回，用起来就像这样：

	>>lst = range(3)
	>>for idx, ele in enumerate(lst):
    >>    print idx, ele
    0 0
	1 1
	2 2

> Tips：使用list的构造方法显式地将迭代器转化为列表、

---

生成器(Generator)
===

简介
---
生成器是一种用普通函数语法定义的迭代器。它主要依赖于`yield`关键字，任何包含`yield`语句的函数都称为生成器。

生成器和函数的主要区别在于函数`return a value`，生成器`yield a value`同时标记且记忆`point of the yield` 以便于在下次调用时从标记点恢复执行。

示例学习
---

创建生成器

我们创建一个函数，用来展开列表的列表的值顺序打印。

	In [35]: my_list = [[1, 2], [3, 4], [5]]

	In [36]: def un_fold(the_list):
    	...:     for _list in the_list:
	    ...:         for element in _list:
	    ...:             yield element
	    ...:             

	In [37]: list(un_fold(my_list))
	Out[37]: [1, 2, 3, 4, 5]

在这里，就是一个生成器，如果我们将`yield element`换成`print element`那么就是一个普通的函数。区别就在于，生成器并没有return一个值，而是产生多个值。每次产生一个值(即使用yield语句),函数就被冻结：重新唤醒后，就会延续刚才运行的状态继续。

递归生成器

Demo:
	
	In [38]: def flatten(the_list):
    	...:     try:
    	...:         for sublist in the_list:
    	...:             for element in flatten(sublist):
    	...:                 yield element
    	...:     except TypeError:
    	...:         yield the_list
    	...: 
	In [39]: list(flatten([[[1],2], 3,4, [5, [6, 7]], 8]))
	Out[39]: [1, 2, 3, 4, 5, 6, 7, 8]

在函数flatten被调用时存在两种可能性：

- 函数被告知展开一个元素时(如一个数字),这时，for循环会出现一个`TypeError`,生成器会产生一个元素。 

- 如果展开的是一个列表(或者其他迭代器对象)，那么程序就会遍历所有的子列表(一些也可能不是列表)，并对他们调用flatten函数。然后用另一个flatten函数展开子列表中的所有元素。

但是上述的例子由一个问题。如果the_list是一个类似字符串的对象。那么它就是一个序列，不会引发TypeError，但是我们不想对这样的对象进行迭代。
所以我们可以在生成器的开始添加一个检查语句。如下

	# demo2
	In [6]: def flatten(the_list):
	   ...:     try:
	   ...:         try: the_list + ''
   	   ...:         except TypeError: pass
   	   ...:         else: raise TypeError
   	   ...:         for sublist in the_list:
	   ...:             for element in flatten(sublist):
   	   ...:                 yield element
	   ...:     except TypeError:
   	   ...:         yield the_list
   	   ...:         

	In [7]: list(flatten(['foo', ['bar', ['baz']]]))
	Out[7]: ['foo', 'bar', 'baz']


通用生成器

当生成器被调用时，在函数体的代码不会被执行，而会返回一个迭代器。每次请求一个值，就会执行生成器的代码，直到遇到一个`yield`或者`return`语句。`yield`语句意味着应该生成一个值，`return`语句意味着生成器要停止运行(不在生成任何东西,`return`语句只有在一个生成器中使用时才能 进行无参数调用).

换句话说，生成器由两部分构成：`生成器的函数和生成器的迭代器`。生成器的函数是用def定义的，包含yield的部分。生成器的迭代器是这个函数返回的部分。

	# demo
	In [1]: def simple_generator():
   	   ...:     yield 1
       ...:     

	In [2]: simple_generator
	Out[2]: <function __main__.simple_generator>

	In [3]: simple_generator()
	Out[3]: <generator object simple_generator at 0x7f2b98d66dc0>

> Tips： 在生成器中返回的迭代器，可以像其他的迭代器一样使用。

生成器方法

- send()方法

	1. 在外部作用域访问生成器的send()方法就像访问next()方法一样，只不过前者使用一个参数(即要发送的消息---任意对象)
	2. 在内部则挂起生成器，yield现在作为表达式而不是语句来用，也就是说，在生成器重新运行时，yield函数返回一个值，也就是外部通过send方法发送的值，如果next方法被使用，那么yield返回None
	3. 注意在使用send方法，只有在生成器挂起的时候，才会有意义，否则就要提供更多信息。

	# demo 说明这种机制
	In [4]: def repeater(value):
	   ...:     while True:
   	   ...:         new = (yield value)
   	   ...:         if new is not None:
	   ...:             value = new
	   ...:             

	In [5]: r = repeater(100)

	In [6]: r.next()
	Out[6]: 100

	In [7]: r.send(101)
	Out[7]: 101

	In [8]: r.send("Alex")
	Out[8]: 'Alex'

- throw方法：用于在生成器内引发一个异常（在yield表达式中）

- close方法:调用时不需要参数， 用于停止生成器。

---

使用enumerate函数
---

普通的遍历索引+值 

	In [5]: seq = ["one", "two", "three"]

	In [6]: i = 0

	In [7]: for ele in seq:
   	   ...:     seq[i] = '%d: %s' % (i, seq[i])
   	   ...:     i += 1
   	   ...:     

	In [8]: print seq
	['0: one', '1: two', '2: three']

使用enumerate后

	In [9]: seq = ["one", "two", "three"]

	In [10]: for i, ele in enumerate(seq):
    	...:     seq[i] = '%d: %s' % (i, seq[i])
	    ...:     

	In [11]: print seq
	['0: one', '1: two', '2: three']

更加pythonic的写法

	In [12]: seq = ["one", "two", "three"]

	In [13]: print ['%d: %s' % (i, ele) for i, ele in enumerate(seq)] 
	['0: one', '1: two', '2: three']


