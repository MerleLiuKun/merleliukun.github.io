---
title: Python实现单例模式总结
date: 2017-08-19 14:29:50
categories: Python
tags: python
---

单例模式
===

在某些情况下，有些对象我们只需要一个就可以了，比如，一台计算机上可以连接好多个打印机，但是这个计算机的打印机程序只能有一个，所以我们在这里就可以使用单例模式来避免两个打印作业同时输出到打印机中。相似的例子还有数据库的连接实例。

<!-- more -->

所谓单例模式，又叫单件模式，其作用就是保证整个应用程序的生命过程中，任何一个时刻，单例类的示例都之只存在一个(也可以不存在)。

单例模式特点：

1. 单例类只能有一个实例；
2. 它必须自行创建这个实例；
3. 它必须自行向整个系统提供这个实例

Python实现单例模式
===

使用\_\_new\_\_方法。
---
首先我们明确一件事情，`__init__`方法不是Python对象的构造方法，`__init__`方法只负责初始化实例对象， 在调用`__init__`方法之前，会首先调用`__new__`方法去生成一个对象，所以对于Python来说，`__new__`方法可以被认为是构造方法。

我们可以在`__new__`方法中加以控制，使得某个类只生成唯一对象。

实现如下：

``` python
class Singleton(object):
	def __new__(cls, *args, **kwargs):
		if not hasattr(cls, '_instance'):
			cls._instance = super(Singleton, cls).__new__(cls, *args, **kw)
		return cls._instance
	
# 测试代码
	
one = MyClass()
two = MyClass()

two.a = 3
print(one.a)    # 3
print(id(one))  # 139640940865520 
print(id(two))  # 139640940865520
```

> 优点：相比装饰器，这是一个真正的类   
> 缺点：要使用多重继承， `__new__`方法可能会被重写，单例实现可能会被覆盖

 

使用共享属性
---

通过对单例的理解，我们可以想到，它就是所有引用(实例，对象)都拥有相同的状态(属性)和行为(方法).所以我们可以将不同的对象指向相同的方法和属性即可。

在Python中，`__dict__`用字典保存了类的所有属性和变量。
所以我们可以将不同的对象的`__dict__`指向同一个字典即可。

代码如下：

``` python
class SingletonByShare(object):
    _state = {}
	
	def __new__(cls, *args, **kwargs):
        ob = super().__new__(cls)
        ob.__dict__ = cls._state
        return ob

# 测试代码：
one = MyClass()
two = MyClass()

two.a = 3
print(one.a)             # 3
print(id(one))           # 139779908835312
print(id(two))           # 139779908834808
print(id(one.__dict__))  # 139779883542208
print(id(two.__dict__))  # 139779883542208
```

我们发现one和two其实是两个不同的对象，但是它们包含的属性和方法字典是一样的。也就是实现了单例。

使用metaclass实现
---

代码如下：

``` python
class SingletonByMetaClass(type):
	_instances = {}

   	def __call__(cls, *args, **kwargs):
       	if cls not in cls._instances:
       	    cls._instances[cls] = super(SingletonByMetaClass, cls).__call(\*args,\*\*kw )

	return cls._instances[cls]

# 测试代码  Python3
class MyClass(object, metaclass=SingletonByMetaClass):
   	a = 1
# Python2
class MyClass(object):
	__metaclass__ = SingletonByMetaClass
	a = 1

one = MyClass()
two = MyClass()

two.a = 3
print(one.a)
print(id(one))
print(id(two))
```

> 优点： 是一个真正的类，达到了多重继承的效果，而不会被重写  
> 缺点： 没有其他方式的实现清晰


使用装饰器实现
---

这是一种更pythonic,更elegant的方法，单例类并不知道自己是单例类。

代码如下：

``` python
def singleton_by_decorator(cls, *args, **kwargs):
   	_instances = {}

   	def wrapper():
   	    if cls not in _instances:
   	        _instances[cls] = cls(\*args, \*\*kwargs)
   	    return _instances[cls]
   	return wrapper
# 测试代码
one = MyClass()
two = MyClass()

two.a = 3
print(one.a)         # 3
print(id(one))       # 139683020176072
print(id(two))       # 139683020176072
print(type(MyClass)) # <class 'function'>
```

> 优点：直接添加在类定义代码上面，比多重继承更加直观  
> 缺点：类调用的时候 myclass()是一个单例对象，但是myclass本身变成了一个方法，而不是一个类，因此不能调用这个类的类方法.并且如果A的类型发生变化之后产生的负面作用是很难把握的。

使用import模块
---

将类作为模块让其他的包去引用，是天然的单例模式。

代码实现：

``` python	
# singleton_by_import.py
class SingletonByImport(object):
	def foo(self):
		pass

singleton = SingletonByImport()


# other file 
from singleton_by_import import singleton
	
singleton.foo()
```

这是比较简单和容易理解的一种实现方式。

参考资料：
===

>https://stackoverflow.com/questions/6760685/creating-a-singleton-in-python
> http://blog.csdn.net/ghostfromheaven/article/details/7671853
> http://whosemario.github.io/2016/01/22/pattern-singleton/
