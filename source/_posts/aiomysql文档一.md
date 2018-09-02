---
title: aiomysql文档一
date: 2017-09-25 22:52:50
categories: 数据库
tags: 数据库
---

## aiomysql官方文档


### `aiomysql`-API Rederence

### 连接

这个库提供了一种通过简洁的工厂级别的函数`aiomysql.connect()`去连接MySQL数据库的一种方式。如果你只想要存在一个连接，可以使用这种方式。对于多个连接可以考虑连接池。

<!-- more -->

示例：

``` python

"""
    Just a demo for test the aiomysql.
"""
import asyncio
import aiomysql

loop = asyncio.get_event_loop()


@asyncio.coroutine
def test_example():
    conn = yield from aiomysql.connect(host="127.0.0.1", port=3306,
                                       user="root", password="123456",
                                       db="mysql", loop=loop
                                       )

    cur = yield from conn.cursor()
    yield from cur.execute("select Host, User from user")
    print(cur.description)
    result = yield from cur.fetchall()
    print(result)
    yield from cur.close()
    conn.close()


loop.run_until_complete(test_example())
```

### connect()函数的参数解析：

>**connect(host="localhost", user=None, password="",
            db=None, port=3306, unix_socket=None,
            charset='', sql_mode=None,
            read_default_file=None, conv=decoders, use_unicode=None,
            client_flag=0, cursorclass=Cursor, init_command=None,
            connect_timeout=None, read_default_group=None,
            no_delay=None, autocommit=False, echo=False,
            local_infile=False, loop=None):
**

一个连接MySQL的协程。

这个方法接受了所有来自`pymsql.connect()`的参数，并加上了关键字循环参数和超时参数。

* 字符串参数 host： 数据库服务所在的主机的地址。 默认为“localhost”
* 字符串参数 user：登录数据库的用户名
* 字符串参数 password：对应用户名的密码
* 字符串参数 db: 要使用的数据库， 如果没有指定不会使用其他的，报错。
* 整型参数 port：MySQL服务使用的端口，一般默认的就可以(3306).
* 字符串参数 unix_socket：可选的，你可以使用一个`unix`的`socket`，而不是一个`TCP/IP`。
* 字符串参数 charset： 指定你想要使用的编码格式，例如“utf8”。
* 参数 sql_model：默认使用的SQL模式，例如“NO_BACKSLASH_ESCAPES”
* 参数 read_default_file： 指定读取[client]部分的`my.cnf`文件。
* 参数 conv：使用指定编码器替代默认编码器，通常用来定制一些类型。 具体参考[pymysql.converters](https://github.com/PyMySQL/PyMySQL/blob/master/pymysql/converters.py)
* 参数 user_unicode： 是否使用默认的unicode字符串
* 参数 client_flag： 自定义发送给mysql的flag，从[pymysql.constants.CLIENT](https://github.com/PyMySQL/PyMySQL/blob/master/pymysql/constants/CLIENT.py)中可以找到相应的值。
* 参数 cursorclass：自定义使用的游标类
* 参数 str init_command：连接建立的时候执行的SQL初始化语句。
* 参数 connect_timeout：连接中抛出异常前的保持时间。
* 字符串参数 read_default_group：从配置文件中读取的分组信息
* 布尔参数 no_delay：禁止使用socket连接的[纳格算法](https://zh.wikipedia.org/wiki/%E7%B4%8D%E6%A0%BC%E7%AE%97%E6%B3%95)
* 参数 autocommit：自动提交模式，指定为`None`使用默认的值(default: `False`) 
* 参数 loop：异步循环事件的实例，或者指定为`None`使用默认的实例。
* return：返回值是一个连接的实例

MySQL服务器的socket的标志，获取链接实例的正确方法是调用`aiomysql.connect()`。

它的实例等同于`pymsql.connection`除了他的所有方法都是使用了协程。

最重要的方法是：

> aiomysql.cursor(cursor=None)

一个使用连接创建新游标对象的协程。

默认情况下， `Cursor`将被返回。也可以通过`cursor`参数给定一个自定义的`cursor`，但是他需要一个`Cursor`的子类。

Parameters: cursor- `Cursor`的子类，或者指定为None使用默认的cursor。

Returns： `Cursor`实例。

> aiomysql.close()

立即关闭连接。

立即关闭连接，(除非del操作在执行)。从这之后连接将无法使用。

> aiomysql.ensure_closed()

协程退出指令，然后会关闭socket连接。

> aiomysql.autocommit(value)

指定当前session会话的自动提交模式是否可用的协程

Params：布尔值
value： 切换自动提交模式

> aiomysql.get_autocommit()

返回当前会话的自动提交模式的状态。

Reuturn： 布尔值  自动提交模式的状态

> aiomysql.begin()

开启一个事务的协程。

>aiomysql.commt()

提交更改到存储器的协程

> aiomysql.rollback()

当前事务的rollback的协程

> aiomysql.select_db(db)

选择当前数据库的协程

Paramters： 数据库(字符串)-- 数据库的名字

> aiomysql.closed()

如果连接关闭，返回一个只读的属性 True。

> aiomysql.host

MySQL服务器的IP地址或者主机名

> aiomysql.port

MySQL服务器的`TCP/IP`通信端口

> aiomysql.unix_socket

MySQL套接字文件的位置

> aiomysql.db 

当前数据库的名字

> aiomysql.user

连接MySQL服务器的用户

> aiomysql.echo

返回echo模式的状态(是否打印出SQL语句)

> aiomysql.encoding

当前连接使用的编码格式

> aiomysql.charset

返回当前连接的字符集。




