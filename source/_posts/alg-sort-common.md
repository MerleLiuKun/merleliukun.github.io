---
title: 常见的排序算法一
date: 2017-08-15 16:09:30
categories:
- algorithm
- sort
tags:
- algorithm
- sort
keywords: 排序 
description: 常见的排序算法一
cover: https://i.loli.net/2020/03/04/g1wMk2QrTP9O7LR.jpg
---

按照相关排序算法的解释，手动用Python实现了一遍，记录一下。
排序结果为从小到大。

安利一个学习算法的经典网站：[算法图示](https://visualgo.net)

这个网站上有很多算法的动图示例，还带有操作步骤解释，实在是居家旅行学习必备之网站。


冒泡排序
=======

原理
----

冒泡排序的原理是将临近的数字两两进行比较，然后按照从小到大或者从大到小的顺序进行交换。

动图如下：

![冒泡排序](http://i.imgur.com/ydsjKFN.gif)

步骤

主要步骤如下：

1. 比较相邻的前后二个数据，如果前面数据大于后面的数据，就将二个数据交换。
2. 按照1的方法对源数组的第0个数据到N-1个数据进行一次遍历后，最大的一个数据就“升”到数组第N-1个位置（就是最后一个位置）。
3. 设置N=N-1，如果N不为0就重复前面二步，如果N==0，那么就是将原数组所有的数都排序一遍，此时排序完成。


代码实现
--------

``` python
def bubble_sort(array):
   	length = len(array)
   	while length > 0:
   	    for i in range(length - 1):
   	        if array[i] > array[i + 1]:
   	            array[i], array[i + 1] = array[i + 1], array[i]
   	    length -= 1
   	return array	
```

基本优化
--------

1.对于结束的条件，如果遍历某一趟时，没有发生任何交换，说明此时排序已经完成，所以我们可以在程序中加上一个标志量用来表示某趟是否发生交换。

代码实现
--------

``` python
def bubble_sort_better(array):
    length = len(array)
    flag = False
    while length > 0:
        for i in range(length - 1):
            if array[i] > array[i + 1]:
                array[i], array[i + 1] = array[i + 1], array[i]
                flag = True
            else:
                flag = False
        if flag is False:
            return array
        length -= 1
    return array
```

2.如果存在这样的数组： 假设数组有100个数，但是只有前10个是无序的，后面90个是已经排序完毕，且均大于前面10个数。这样我们分析即可发现，第一趟遍历的时候，最后发生交换的位置必定小于10。所以我们只需要记录下这个最后的位置，下一次，只需要从头遍历到这个位置即可。

代码如下：

``` python
def bubble_sort_best(array):
    length = len(array)
    while length > 0:
        for i in range(length - 1):
            if array[i] > array[i + 1]:
                array[i], array[i + 1] = array[i + 1], array[i]
                length = i + 1
        length -= 1
    return array
```

直接插入排序
==========

原理
----

插入排序的基本思想就是：每次将一个待排序的记录，按其关键字大小插入到前面已经排好序的子序列中的适当位置，直到全部记录插入完成为止。

动图效果如下：
![](http://i.imgur.com/6xxjaz8.gif)

步骤

设数组为a[0…n-1]。

1. 从第一个元素开始，该元素可以认为已经被排序
2. 取出下一个元素，在已经排序的元素序列中从后向前扫描
3. 如果该元素（已排序）大于新元素，将该元素移到下一位置
4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置
5. 将新元素插入到该位置中
6. 重复步骤2


代码实现
-------

``` python
def insert_while(nums):
    for index in range(1, len(nums)):
        deal_num = nums[index]
        j = index - 1
        while j >= 0 and nums[j] > deal_num:
            nums[j + 1] = nums[j]
            j -= 1
        nums[j + 1] = deal_num
```

---

希尔排序
========

原理
----

希尔排序，也称递减增量排序算法，实质是分组插入排序。由 Donald Shell 于1959年提出。希尔排序是非稳定排序算法。

希尔排序是基于插入排序的以下两点性质而提出改进方法的：

- 插入排序在对几乎已经排好序的数据操作时， 效率高， 即可以达到线性排序的效率
- 但插入排序一般来说是低效的， 因为插入排序每次只能将数据移动一位

希尔排序的基本思想是：先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。

![](http://upload.wikimedia.org/wikipedia/commons/d/d8/Sorting_shellsort_anim.gif)

步骤

我们以一组数`[49, 38, 65, 97, 26, 13, 27, 49, 55, 4]`为例。

加入首先我们以步长5排序

> 49 38 65 97 26  
> 13 27 49 55 4

然后我们对每列进行排序。

> 13 27 49 55 4
> 49 38 65 97 26

合并变成了`[13, 27, 49, 55, 4, 49, 38, 65, 97, 26]`。第一轮结束。

更换步长为`5//2=2`,继续排序

> 13 27  
> 49 55  
> 4  49  
> 38 65  
> 97 26  

排序过后

> 4  26  
> 13 27  
> 38 49  
> 49 55  
> 97 65

合并：[4,26,13,27,38,49,49,55,97,65]

更换步长为`2//1=1`
排序之后就得到了结果。

代码实现
-------

``` python
def shell_sort(array, n):
    step = 2
    now_gap = n // step  # 初始步长
    while now_gap > 0:
        for i in range(now_gap, n):
			 # 每个步长进行插入排序
            temp = array[i]
            j = i
			# 插入排序
            while j >= now_gap and array[j - now_gap] > temp:
                array[j] = array[j - now_gap]
                j = j - now_gap
            array[j] = temp
		# 新的步长
        now_gap //= step
    return array
```

基本优化

优化部分主要在与步长的选择上，请移步[维基百科](http://zh.wikipedia.org/wiki/%E5%B8%8C%E5%B0%94%E6%8E%92%E5%BA%![](http://i.imgur.com/pQtUU2X.png)8F#.E6.AD.A5.E9.95.BF.E5.BA.8F.E5.88.97)上查阅。
当前比较优秀的步长序列有：

1. 已知的最好步长序列是由Sedgewick提出的(1, 5, 19, 41, 109,...)，该序列的项来自![](http://i.imgur.com/flXbu1q.png)这两个算式。这项研究也表明“比较在希尔排序中是最主要的操作，而不是交换。”用这样步长序列的希尔排序比插入排序要快，甚至在小数组中比快速排序和堆排序还快，但是在涉及大量数据时希尔排序还是比快速排序慢。
2. 另一个在大数组中表现优异的步长序列是（斐波那契数列除去0和1将剩余的数以黄金分区比的两倍的幂进行运算得到的数列）：(1, 9, 34, 182, 836, 4025, 19001, 90358, 428481, 2034035, 9651787, 45806244, 217378076, 1031612713,…)

---

直接选择排序
===========

原理
-----

直接选择排序和直接插入排序类似，都将数据分为有序区和无序区，所不同的是直接插入排序是将无序区的第一个元素直接插入到有序区以形成一个更大的有序区，而直接选择排序是从无序区选一个最小的元素直接放到有序区的最后。

步骤

1. 在给定的数组中找到最小(大)的元素，将其放置为数组的首位作为已排序区域。
2. 继续在剩下的数组区域中寻找最小(大)的元素，放置到已排序区域的后边。
3. 重复2步知道剩下的元素排序完毕。

动图示例：

![](http://upload.wikimedia.org/wikipedia/commons/b/b0/Selection_sort_animation.gif)

代码实现
-------

``` python
def select_sort(array):
    for i in range(len(array)):
        min_index = i
        for j in range(i + 1, len(array)):
            if array[j] < array[min_index]:
                min_index = j
        array[min_index], array[i] = array[i], array[min_index]
	return array
```

---

归并排序
========

原理
----

归并排序是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。它的思想就是先`递归分解`数组，再`合并`数组。

首先是合并两个数组。思路如下：比较两个数组的最前面的数字，取小的那个，取了之后就要从原来的数组中删除这个数字。 然后继续比较，知道一个数组为空，最后把另一个数组的剩余部分复制过来即可。

再者考虑递归分解。思路如下：将数组分为`left`和`right`，如果这两个数组内部有序，就合并这两个数组。确定两个数组内部有序的方法是，持续二分，知道每个小组中只有一个数字，此时该小组就认为有序。然后合并相邻两个小组。


动图演示：

![](http://i.imgur.com/F7EZKVG.gif)

代码实现
-------

``` python	
def merge_array(array1, array2):
    left_index = right_index = 0
    result = []
    # 循环比较两个数组，知道某个数组为空
    while len(array1) > left_index and len(array2) > right_index:
        if array1[left_index] < array2[right_index]:
            result.append(array1[left_index])
            left_index += 1
        else:
            result.append(array2[right_index])
            right_index += 1
    # 将不为空数组剩下的数字依次加入到结果列表中。另一个是空列表，所以可以这样实现。
    result += array1[left_index:]
    result += array2[right_index:]
    return result
	
	
def divide_array(array):
    # 结束条件
    if len(array) <= 1:
        return array

    index = len(array) // 2

    left = divide_array(array[:index])  # 左半部分
    right = divide_array(array[index:])  # 右半部分
	
    return merge_array(left, right)
```

---

快速排序
========

原理
-----

快速排序通常明显比同为Ο(n log n)的其他算法更快，因此常被采用，而且快排采用了`分治法`的思想，所以在很多笔试面试中能经常看到快排的影子。可见掌握快排的重要性。

步骤

1. 先从数列中取出一个数作为基准数。
2. 分区过程，将比这个数大的数全放到它的右边，小于或等于它的数全放到它的左边。
3. 再对左右区间重复第二步，直到各区间只有一个数

动图示例：

![](http://i.imgur.com/H2HyJ4p.gif)

代码实现
-------

``` python
# 普通实现
def quick_sort_simple(array):
    if len(array) <= 1:
        return array
    key = array[0]
    less, greater = [], []
    for i in range(1, len(array)):
        if array[i] > key:
            greater.append(array[i])
        else:
            less.append(array[i])
    return quick_sort_simple(less) + [key] + quick_sort_simple(greater)


# 使用列表推导式实现
def quick_sort_nic(array):
    if len(array) <= 1:
        return array
    return quick_sort_nic([x for x in array if x < array[0]]) + [x for x in array if x == array[0]] + quick_sort_nic([x for x in array if x > array[0]])

	
# 不开辟空间实现
def quick_sort(ary):
    return qsort(ary,0,len(ary)-1)

def qsort(ary,left,right):
    #快排函数，ary为待排序数组，left为待排序的左边界，right为右边界
    if left >= right : return ary
    key = ary[left]     #取最左边的为基准数
    lp = left           #左指针
    rp = right          #右指针
    while lp < rp :
        while ary[rp] >= key and lp < rp :
            rp -= 1
        while ary[lp] <= key and lp < rp :
            lp += 1
        ary[lp],ary[rp] = ary[rp],ary[lp]
    ary[left],ary[lp] = ary[lp],ary[left]
    qsort(ary,left,lp-1)
    qsort(ary,rp+1,right)
    return ary
```

---

堆排序
======

原理
----

堆排序与快速排序，归并排序一样都是时间复杂度为O(N*logN)的几种常见排序方法，

首先我们要理解数据结构中的二叉堆。具体介绍请移步文章[数据结构之堆](http://lkhardy.cn/2017/08/15/数据结构之堆/)。

我们知道二叉堆的两大性质：  

1. 父节点的键值总是大于或者等于任何一个子节点的键值。
2. 每个节点的左右子树都是一个二叉树堆(都是最大堆或者是最小堆)

步骤

1. 构建最大堆(Build_Max_Heap):若数组下标范围为0~n，考虑到单独一个元素的大根堆，则从下标`n/2`开始的元素均为大根堆。于是只要从`n/2-1`开始，向前依次构造大根堆，这样就保证，构造到某结点时，它的左右子树都已经是大根堆。

2. 堆排序(HeapSort):由于堆是用数组模拟的。得到一个大根堆后，数组内部并不是有序的。因此需要将堆化数组有序化。 这种操作的思想是：移除根节点，并做最大堆调整的递归运算。第一次将`heap[0]`与`heap[n-1]`交换，再对`heap[0...n-2]`做最大堆调整。第二次将`heap[0]`与`heap[n-2]`交换，再对heap[0..n-3]做最大堆调整。重复该操作直至`heap[0]`和`heap[1]`交换。由于每次都是将最大的数字并入到后边的有序区间。所以操作完成时，整个数组就是有序的了。

3. 最大堆调整(Max_Heapify)：该方法是被调用的，目的是将堆的末端子结点作调整。使得子结点永远小于父节点。

动图演示：

![](http://i.imgur.com/QgGdS7K.gif)


代码实现
-------

``` python	
def heap_sort(ary):
    n = len(ary)
    first = int(n / 2 - 1)  # 最后一个非叶子节点
    for start in range(first, -1, -1):  # 构造大根堆
        max_heapify(ary, start, n - 1)
    for end in range(n - 1, 0, -1):  # 堆排，将大根堆转换成有序数组
        ary[end], ary[0] = ary[0], ary[end]
        max_heapify(ary, 0, end - 1)
    return ary


# 最大堆调整：将堆的末端子节点作调整，使得子节点永远小于父节点
# start为当前需要调整最大堆的位置，end为调整边界
def max_heapify(ary, start, end):
    root = start
    while True:
        child = root * 2 + 1  # 调整节点的子节点
        if child > end:
            break
        if child + 1 <= end and ary[child] < ary[child + 1]:
            child = child + 1  # 取较大的子节点
        if ary[root] < ary[child]:  # 较大的子节点成为父节点
            ary[root], ary[child] = ary[child], ary[root]  # 交换
            root = child
        else:
            break
```

---

相关代码都放置在了我的[github](https://github.com/MerleLK/python-demo-small/tree/master/myAlgorithms/sort_demos)


参考资料
=========

1. http://blog.csdn.net/morewindows/article/category/859207
2. http://wuchong.me/blog/2014/02/09/algorithm-sort-summary/
3. https://visualgo.net/zh/sorting
