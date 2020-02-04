---
title: Python 数据类 dataclasses 实践
date: 2019-11-23 21:37:40
categories:
- Python
tags:
- python
- dataclasses
keywords: python dataclass
description: Python 数据类 dataclasses 实践
cover: https://i.loli.net/2020/01/26/Y7ZMhtH8XnqPxpI.png
---

从 `Python3.7` 版本开始，引入了一个新的模块 `dataclasses`，该模块主要提供了一种数据类的数据类的实现方式。基于 [PEP-557](https://www.python.org/dev/peps/pep-0557/)实现。 所谓数据类，类似 `Java` 语言中的 `Bean`。通过一个容器类(class)，继而使用对象的属性访问数据。

如果你使用过标准库中的 `collections.namedtuple`, 或者 `typing.NamedTuple`，`dataclasses`是与这两者类似的。

通过 `dataclasses` 我们可以更加方便的去定义一个数据类。并且可以通过原生的方式进行类型检查。

一个基础例子:

``` python
@dataclass
class InventoryItem:
    '''Class for keeping track of an item in inventory.'''
    name: str
    unit_price: float
    quantity_on_hand: int = 0

    def total_cost(self) -> float:
        return self.unit_price * self.quantity_on_hand
```

基础用法
=======

`dataclasses` 提供一个模块级的装饰器 `dataclass` 用来将类转化为数据类。该装饰器的原型定义如下：

``` python
@dataclasses.dataclass(*, init=True, repr=True, eq=True, order=False, unsafe_hash=False, frozen=False)
```

提供的默认参数用来控制是否生成相应的魔术方法。如 `repr` 为 `True` 时，将会自动生成 `__repr__` 方法。

我们定义一个简单的数据类，用以实现一个使用对象的属性存储实体 `Person` 数据：

``` python
@dataclasses.dataclass
class Person:
    name: str
    age: int = 20
```

该类中定义了两个属性 `name` 和 `age`。分别表示名称和年龄，并且说明 `name` 属性是一个字符串，`age` 属性是一个数字(注意： 因为 `Python` 编译器不会对此处的类型进行强制检查)，并为 `age` 属性设置了默认值 `20`。

我们可以这样去使用：

``` bash
In [1]: person = Person('ikaros', 24)

In [2]: person.name
Out[2]: 'ikaros'

# 因为默认情况下 `repr` 是自动生成的，所以我们得到 `person` 的字符串表示。
In [3]: person
Out[3]: Person(name='ikaros', age=24)
```

通过使用 `field` 我们可以对参数做更多的定制化，如：

```
@dataclasses.dataclass
class Person:
    name: str
    age: int = dataclasses.field(default=20, repr=False)
```

此处我们为 `age` 属性赋予了一个额外的 `repr` 为 `False` 的参数。该参数说明，在调用 `__repr__` 方法时，不展示 `age` 属性：

``` bash
In [4]: person
Out[4]: Person(name='ikaros')
```

更多的 `field` 说明，可以查看 [参考文档](https://docs.python.org/zh-cn/3.7/library/dataclasses.html#dataclasses.field)。


实例说明
=======

此处我们通过一个实际的例子展示 `dataclasses` 的用法.

现有一个数据实体内部的数据如下：

``` json
{
    "id": "20531316728",
    "about": "The Facebook Page celebrates how our friends inspire us, support us, and help us discover the world when we connect.",
    "birthday": "02/04/2004",
    "name": "Facebook",
    "username": "facebookapp",
    "fan_count": 214643503,
    "cover": {
        "cover_id": "10158913960541729",
        "offset_x": 50,
        "offset_y": 50,
        "source": "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/73087560_10158913960546729_8876113648821469184_o.jpg?_nc_cat=1&_nc_ohc=bAJ1yh0abN4AQkSOGhMpytya2quC_uS0j0BF-XEVlRlgwTfzkL_F0fojQ&_nc_ht=scontent.xx&oh=2964a1a64b6b474e64b06bdb568684da&oe=5E454425",
        "id": "10158913960541729"
    }
}
```

我们通过定义一个对应的数据类来表示该数据实体：

``` python
@dataclass
class Page:
    id: str = None
    about: str = field(default=None, repr=False)
    birthday: str = field(default=None, repr=False)
    name: str = None
    username: str = None
    fan_count: int = field(default=None, repr=False)
    cover: dict = field(default=None, repr=False)
```

将数据传入到数据类中：

``` bash
# data 为 上述的数据
In [5]: p = Page(**data)
```

对数据进行操作：

``` bash
# 获取数据
In [6]: p.name
Out[6]: 'Facebook'

# 字符串展示
In [7]: p
Out[8]: Page(id='20531316728', name='Facebook', username='facebookapp')

In [9]: p.cover
Out[9]: 
{'cover_id': '10158913960541729',
 'offset_x': 50,
 'offset_y': 50,
 'source': 'https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/73087560_10158913960546729_8876113648821469184_o.jpg?_nc_cat=1&_nc_ohc=bAJ1yh0abN4AQkSOGhMpytya2quC_uS0j0BF-XEVlRlgwTfzkL_F0fojQ&_nc_ht=scontent.xx&oh=2964a1a64b6b474e64b06bdb568684da&oe=5E454425',
 'id': '10158913960541729'}
```

上述完整代码参见 [demo1](https://github.com/MerleLiuKun/my-python/blob/master/sundries/dataclass/demo1.py) 

我们在上述的代码发现, 在调用 `p.cover` 属性时，返回的是一个字典，在正常的使用时，我们是想将 `cover` 属性也声明为一个数据类。则需要对上述的代码进行修改。

添加一个 `Cover` 的数据类实现：

``` python
@dataclass
class Cover:
    id: str = None
    cover_id: str = None
    offset_x: str = field(default=None, repr=False)
    offset_y: str = field(default=None, repr=False)
    source: str = field(default=None, repr=False)

@dataclass
class Page:
    ...  # 此处不再复制上方的属性
    cover: Cover = field(default=None, repr=False)  # 修改 `cover` 属性
```

但是这时候，如果我们按照刚才的初始化方式，`cover` 属性不会被识别到。

我们可以通过添加一个额外的初始化的方法用来初始化到 `cover` 属性.

``` python
def dicts_to_dataclasses(instance):
    """将所有的数据类属性都转化到数据类中"""
    cls = type(instance)
    for f in fields(cls):
        if not is_dataclass(f.type):
            continue

        value = getattr(instance, f.name)
        if not isinstance(value, dict):
            continue

        new_value = f.type(**value)
        setattr(instance, f.name, new_value)

```

并且修改上层数据类 `Page` 的代码，添加一个 `__post_init__` 方法， 该方法会被自动生成的 `__init__` 方法调用，进而将 `Cover` 数据类进行初始化。

``` python
@dataclass
class Page:
    ...  # 上方的属性

    def __post_init__(self):
        dicts_to_dataclasses(self)
```

上述完整代码参见 [demo2](https://github.com/MerleLiuKun/my-python/blob/master/sundries/dataclass/demo2.py)

此时我们去初始化时，便可以将子数据类 `Cover` 也初始化了。

``` bash
In [10]: p.cover
Out[10]: Cover(id='10158913960541729', cover_id='10158913960541729')
```

此外，`dataclasses` 还提供了对数据类到字典的转化。

``` bash
In [11]: from dataclasses import asdict
In [12]: asdict(p)
Out[12]:
{'id': '20531316728',
....
}
```

我们可以对上边的代码进行整合一下。将通用的一些函数放到一个 `base` 基类中。

完整代码参见 [demo3](https://github.com/MerleLiuKun/my-python/blob/master/sundries/dataclass/demo3.py)


第三方增强库
==========

上边我们只是对含有嵌套字典的复杂数据进行了处理。事实上，生产中的数据的样式会更加复杂。我们根据需求自行对 `dicts_to_dataclasses` 函数进行升级处理，或者使用第三方库进行处理。

此处我们以第三方库 `dataclasses-json` 来给出一个示例，详细代码参见 [demo-with-dataclasses-json](https://github.com/MerleLiuKun/my-python/blob/master/sundries/dataclass/demo_with_dataclasses_json.py)


参考资料
=======

- [Python3.7 dataclass 介绍](https://www.kawabangga.com/posts/2959)
- [dataclasses---数据类(官方文档)](https://docs.python.org/zh-cn/3.7/library/dataclasses.html)
- [dataclasses-json](https://github.com/lidatong/dataclasses-json)