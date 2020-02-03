---
title: JavaScrip 基本数据类型的常用操作
date: 2017-07-25 22:41:38
categories:
- JavaScript
tags:
- JavaScript
- data
keywords: JavaScript
description: JavaScrip 基本数据类型的常用操作
---

在日常项目中，发现会经常用到JS基本数据类型相关的一些操作。经常是当场搜索相关的用法。还是不利于自己学习。所以还是记录以下，增加自己的记忆。

字符串相关
=========

移除字符串中某些特定的字符
------------------------

使用`replace()`函数替换，去除myStr字符串中的, : ; = '[ ] ' + 等符号

``` js
var myStr = "123,abc:456;abc=abc[]";
myStr.replace(/[,:;=\[\]]+/g,'');
// Output: "123abc456abcabc"
```

使用`split()`和`join()`函数，去掉冒号

``` js
var myString = "12:30:21"
myString.split(":").join("")
// Output: "123021"
```

去除myStr字符串中的, : ; = '[ ] ' + 等符号

``` js
var myStr = "123,abc:456;abc=abc[]";	
my_str.split(/[,:;]/).join("")
// Output: "123abc456abc=abc[]"
```

以上两种方法都使用了正则表达式进行处理。

删除字符串最后一个字符
--------------------

使用`substring()`函数

``` js
var myString = "1,2,3,4,"	
myString.substring(0, s.length-1) 
// output: "1,2,3,4"
```

`substring(start, end)` 函数，经常用于提取一个字符串中下标在 `[start, end)` 之间的子字符串。包含 `start`,不包含 `end`。

- 如果 start 与 end 相等，那么该方法返回的就是一个空串（即长度为 0 的字符串）。
- 如果 start 比 end 大，那么该方法在提取子串之前会先交换这两个参数。
- 如果 start 或 end 为负数，那么它将被替换为 0。


获取字符串中子字符串
------------------

使用 `substring()` 函数，但需要指定下标。

使用`substr()`函数

``` js
var myString = "0123456789"
// 获取从第6位开始的所有剩余字符, 下标从0开始
myString.substr(5)
// Output: 56789
```
	
`substr(start, length)` 函数，用于返回一个从指定位置开始的指定长度的子字符串。

参数说明

- start  必须要有，所需字符串的起始位置。
- length  可选，返回的字符串中应包含字符的个数
- 如果start为负数，那么start=str.length+start
- 如果length为0或者负数，就会返回一个空字符串
- 如果不指定length参数，则字符串就会一直到str的末尾


判断字符串是否在另一个字符串中
----------------------------

使用 `indexof()` 函数

``` js
var fullStr = 'helloWorld';
if(fulleStr.indexof('hello')){
    alert('fullStr has str hello');
}
```

`fullStr.indexof(str)` 函数，用于返回 `String` 对象内第一次出现子字符串的字符位置。如果没有找到子字符串就会返回 `-1`。
