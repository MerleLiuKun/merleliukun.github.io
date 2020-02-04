---
title: 链表-单链表
date: 2017-08-02 22:14:29
categories:
- 数据结构
- 链表
tags:
- 数据结构
- 链表
keywords: 链表 linked-list
description: 链表-单链表
---

线性表实现的基本需要：

- 能够找到表中的首元素（无论直接或间接，通常很容易做到）	
- 从表里的任一个元素出发，可以找到它之后的下一个元素

实现线性表的一种方式是基于链接结构，用链接显式地表示元素之间的顺序关联。  
基于链接技术实现的线性表称为链接表或链表

而链表有存在单向链表和双向链表，今天我们先介绍以下单向链表(单链表)


节点
====

链表的单元是节点 `Node`

- 每个结点（对象）有自己的标识（下面也常直接称其为链接）
- 结点之间通过结点链接建立起顺序联系
- 给表的最后一个结点（表尾结点）的链接域设置一个不会作为结点
对象标识的值（Python 里自然应该用 None），称为空链接

简单的节点实现代码：
-----------------

	class Node(object):
    	def __init__(self, x, nxt):
    	    self.val = x
    	    self.next = nxt

基础操作
=======

对单链表的基本操作有：

1.创建空链表:对于链表而言只需要将表头变量设置为空链接  

> 在Python中我们将其设置为None即可

2.删除链表:丢弃表的所有节点  
>在python中我们只需要简单的将表指针设为None，就丢掉了整个链表的所有节点，Python的存储管理系统会自动回收掉不用的存储。

3.判断链表是否为空: 将表头变量的值与空链接进行比较
>在Python中我们只需要检查其值是否为None即可

4.判断链表是否满
> 链表不会满， 除非存储空间全部用完

5.首端加入元素
> 1）创建一个新结点存入数据  
> 2）把原链表首节点的连接存入新结点的链接域  
> 3) 修改表头变量使之引用新结点  

6.尾端加入元素
> 1) 创建一个新结点存入数据  
> 2) 表空时直接让表头变量引用这个新结点并结束，否则找到表尾结点  
> 3) 令表尾结点的链接域引用这一新结点，并将新结点的链接域设置为空链接

7.定位加入元素
> 1) 找到新结点加入位置的前一结点，不存在时结束  
> 2) 创建新结点存入数据  
> 3) 修改前一结点和新结点的链接域将结点连入

8.首端删除元素
> 直接修改表头指针，使之引用当时表头结点的下一个结点。
Python 系统里会自动回收无用对象的存储块，下同

9.尾端删除元素
> 找到倒数第二个结点，将其链接域设置为空链接

10.定位删除元素
> 找到要删除元素所在结点的前一结点，修改它的链接域将
要求删除的结点从表中去掉


代码定义
========

普通单链表
----------

	# 单向链表
	class SinglyLinkedList(object):
	    def __init__(self):
	        self.head = None
	
	    # 判空只需要判断指向的下一个节点是否为None
	    def is_empty(self):
	        return self.head is None
	
	    # 链表首端加入新元素
	    def prepend(self, element):
	        self.head = Node(element, self.head)
	
	    # 尾端加入新元素
	    def append(self, element):
	        # 判断是否为空链表, 是就直接添加
	        if self.head is None:
	            self.head = Node(element, None)
	            return
	
	        # 链表不为空, 遍历得到表里最后一个节点, 然后用这个节点的next域记录新结点的链接
	        p = self.head
	        while p.next is not None:
	            p = p.next
	        p.next = Node(element, None)
	
	    # 首端弹出元素
	    def pop(self):
	        if self.head is None:
	            raise ValueError
	        value = self.head.val
	        self.head = self.head.next
	        return value
	
	    # 弹出尾端元素
	    def pop_last(self):
	        # 首先判断是否为空链表
	        if self.head is None:
	            raise ValueError
	        p = self.head
	        # 如果链表只有一个元素
	        if p.next is None:
	            value = p.val
	            self.head = None
	            return value
	        # 遍历链表 直到找到最后一个节点, 将前一个节点的next置为None
	        while p.next.next is not None:
	            p = p.next
	        value = p.next.val
	        p.next = None
	        return value
	
	    # 查找元素
	    def find(self, element):
	        p = self.head
	        while p is not None:
	            if element == p.val:
	                return p.next.val
	            p = p.next
	        return None
	
	    # 打印出所有元素
	    def print_all(self):
	        p = self.head
	        while p is not None:
	            print(p.val, end="")
	            p = p.next
	        print("")

带有尾结点的单链表
------------------

	# 带尾结点引用的单链表  尾结点引用--->即指向最后一个节点
	# 较之上一个实现, 有效的解决了尾端插入的效率问题
	class SinglyLinkedListWithRearReference(SinglyLinkedList):
	    def __init__(self):
	        SinglyLinkedList.__init__(self)
	        self.rear = None
	
	    # 首端加入新元素
	    def prepend(self, element):
	        # 如果为空列表, 就将将元素置为第一个,并将尾节点引用指向当前节点
	        self.head = Node(element, self.head)
	        if self.rear is None:
	            self.rear = self.head
	
	    # 尾端加入新元素
	    def append(self, element):
	        if self.head is None:
	            # 直接调用首端加入, 对于第一个元素, 加入都是一致的
	            self.prepend(element)
	        else:
	            # 尾端加入新的元素时, 将尾结点引用指向当前新加入的节点
	            self.rear.next = Node(element, None)
	            self.rear = self.rear.next
	
	    # 从首端删除元素
	    def pop(self):
	        if self.head is None:
	            raise ValueError
	        value = self.head.val
	        # 如果尾结点引用指向了头结点, 那么说明 当前链表只有一个元素节点, 删除之后需要将尾结点引用置为None
	        if self.rear is self.head:
	            self.rear = None
	        # 将链表的头指向下一个元素节点
	        self.head = self.head.next
	        return value
	
	    # 从尾端删除元素
	    def pop_last(self):
	        if self.head is None:
	            raise ValueError
	
	        val = self.rear.val
	        p = self.head
	        while p.next.val != val:
	            p = p.next
	
	        p.next = None
	        self.rear = p

循环单链表
----------

	# 循环单链表  不必要使用单链表为基类
	class CircularSinglyLinkedList(object):
	    def __init__(self):
	        self.rear = None
	
	    # 判断是否为空
	    def is_empty(self):
	        return self.rear is None
	
	    # 首端加入新元素
	    def prepend(self, element):
	        p = Node(element, None)
	        # 如果是空链表，就要建立初始的循环链接， 即自己链接自己
	        if self.rear is None:
	            p.next = p
	            self.rear = p
	        # 链表不空，就要链接在尾结点之后， 就是首结点
	        else:
	            p.next = self.rear.next  # 先将原来的首结点链接在自己的后边
	            self.rear.next = p  # 自己成为首结点
	
	    # 尾端加入新元素
	    def append(self, element):
	        # 直接调用之前的加入操作
	        self.prepend(element)
	        # 将尾节点置换为新加入的结点
	        self.rear = self.rear.next
	
	    # 删除首端元素
	    def pop(self):
	        # 首先判断是否为空列表
	        if self.rear is None:
	            raise ValueError
	        p = self.rear.next
	        # 如果尾节点指向自己，说明只有一个结点， 弹出结点之后 将尾节点置空
	        if self.rear is p:
	            self.rear = None
	        # 正常情况下，删除首结点，并将首结点置为原来首结点的下一个
	        else:
	            self.rear.next = p.next
	        return p.val
	
	    # 删除尾端元素
	    def pop_last(self):
	        # 首先判断是否为空列表
	        if self.rear is None:
	            raise ValueError
	        p = self.rear.next
	        if p is self.rear:
	            self.rear = None
	            return p.val
	        while p.next is not self.rear:
	            p = p.next
	        p.next = self.rear.next
	        self.rear = p
	        return p.val
	
	    # 遍历所有结点
	    def print_all(self):
	        p = self.rear.next
	        while True:
	            print(p.val, end="")
	            if p is self.rear:
	                print("")
	                break
	            p = p.next



常见操作
=======

	from data_structure.link_list.singly_linked_list import SinglyLinkedList


	# 反序链表
	def reverse_by_singly(my_list):
	    """
	    使用修改链接关系：
	    1如果一直向首端添加结点，最先进去的就会在尾结点
	    2一直从首端取元素，最后得到的时尾结点。
	    这样就可以实现反转算法了
	    :param my_list: 被操作的链表
	    :return: 无
	    """
	
	    p = None
	    while my_list.head is not None:
	        q = my_list.head
	        my_list.head = q.next
	        q.next = p
	        p = q
	    my_list.head = p


	# 基于移动元素的单链表排序
	def sort_linked_list_by_move_value(my_list):
	    """
	    为了有效实现，算法只能从头到尾方向检查和处理。
	    每次拿出一个元素，在已排序的序列中找到正确位置插入
	    :param my_list: 被操作的链表
	    :return: 无
	    """
	
	    if my_list.head is None:
	        return
	    crt = my_list.head.next  # 计算从首结点之后开始，即首结点已排序完毕
	    while crt is not None:
	        x = crt.val
	        p = my_list.head
	        # 从原链表的首结点开始进行比较，存在如下情况
	        # 1. 当前结点的值大于已排序完毕的结点，跳过
	        while p is not crt and p.val <= x:
	            p = p.next
	        # 2. 当前结点的值小于已排序完毕的结点， 交换元素位置
	        while p is not crt:
	            x, p.val = p.val, x
	            p = p.next
	        crt.val = x
	        crt = crt.next


	# 基于调整链接关系实现排序工作
	def sort_linked_list_by_change_relation(my_list):
	    """
	    基本处理模式与移动元素类似.
	    但是这里不在结点之间移动表元素，而是把被处理的结点取下来接到正确的位置上。
	    :param my_list: 被操作的链表
	    :return: 无
	    """
	    # 判断链表是否为空
	    if my_list.head is None:
	        return
	    # 初始 已排序的段只有一个结点
	    last = my_list.head  # 表示已排序段的尾结点
	    crt = last.next      # 待排序段的首结点
	    # 顺序链表的结点，每次处理一个结点
	    while crt is not None:
	        # 设置扫描指针的初始值
	        p = my_list.head  # 已排序，并且比较完毕的段
	        q = None  # 已排序但为比较完毕的段
	        while p is not crt and p.val <= crt.val:
	            # 顺序更新两个扫描指针
	            q = p
	            p = p.next
	        # 当 p 是 crt 时 不需要修改链接，设置last到下一个结点crt
	        if p is crt:
	            last = crt
	        else:
	            # 取出当前结点
	            last.next = crt.next
	            # 接好后置链接
	            crt.next = p
	            if q is None:
	                # 作为新的首结点
	                my_list.head = crt
	            else:
	                # 接在表中间
	                q.next = crt
	        # crt 指向last的下一个结点
	        crt = last.next

Josephus 问题
------------

使用循环单链表解决：

	"""
	@description: 经典问题 Josephus问题
	@author: merleLK
	@contact: merle.liukun@gmail.com
	@date: 17-8-2
	@detail: 问题描述：
	    设有n个人围坐一圈，现在从第k个人开始报数，报到第m的人退出。
	    然后继续报数，直至所有人退出。输出出列人顺序编号。
	"""
	from data_structure.link_list.singly_linked_list import CircularSinglyLinkedList


	# 基于list和固定大小的数组
	def josephus_list(n, k, m):
	    """
	    1.建立一个包含n个人（编号）的list
	    2.找到k个人， 从那里开始
	        处理过程中，把对应的表元素修改为0表示人已经退出
	    3.反复操作：
	        数m个（在席）人
	        把表示第m个人的元素修改为0
	    Tips: 数到list最后元素之后转到下标为0的元素继续
	    :param n: 列表的长度
	    :param k: 开始位置
	    :param m: 退出条件
	    :return: 无
	    """
	    people = list(range(1, n + 1))
	    print(people)
	
	    i = k - 1  # 开始位置的下标
	    for num in range(n):
	        count = 0  # 报数编号
	        # 一次循环最多到m， 此时就会把最后一个人踢出
	        while count < m:
	            if people[i] > 0:
	                count += 1
	            if count == m:
	                print(people[i], end="")
	                people[i] = 0
	            i = (i + 1) % n  # 遍历到最后一个位置就会从首位再次开始
	        print("," if num < n - 1 else "\n", end="")
	
	
	def josephus_list_pop(n, k, m):
	    """
	    1.算出应该退出的元素之后, 将其从表中删除
	    2.直至表长度为0的时候结束
	    复杂度： O(n^2)
	    :param n: 列表的长度
	    :param k: 开始位置
	    :param m: 退出条件
	    :return: 无
	    """
	    people = list(range(1, n + 1))
	    i = k - 1
	    for num in range(n, 0, -1):
	        i = (i + int(m) - 1) % num
	        print(people.pop(i), end="")
	        print("," if num > 1 else "\n", end="")
	
	
	class JosephusLinkedList(CircularSinglyLinkedList):
	    """
	    1.从形式看，循环单链表很好地表现了围坐一圈的人
	    2.顺序的数人头，很好的符合了循环表中沿着next链扫描
	    3.某人退出之后，删除相应结点，之后可以继续沿着原来的方向数人头
	
	    算法复杂度 O(m*n)
	    """
	
	    def __init__(self, n, k, m):
	        CircularSinglyLinkedList.__init__(self)
	        # 创建包含n个元素的循环链表
	        for i in range(n):
	            self.append(i + 1)
	        # 将初始结点移动到k处
	        self.turn(k - 1)
	
	        # 循环弹出第m个元素直到链表为空
	        while not self.is_empty():
	            self.turn(m - 1)
	            print(self.pop(), end="")
	            print("," if self.rear is not None else "\n", end="")
	
	    # 将循环表对象的rear指针沿着next移动了m步
	    def turn(self, m):
	        for i in range(m):
	            self.rear = self.rear.next
	
	
	if __name__ == '__main__':
	    josephus_list(10, 2, 7)
	    josephus_list_pop(10, 2, 7)
	    JosephusLinkedList(10, 2, 7)

源代码已经放置于我的 [github](https://github.com/MerleLK/python-demo-small/tree/master/data_structure/link_list).
