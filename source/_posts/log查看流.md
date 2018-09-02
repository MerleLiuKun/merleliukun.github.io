---
title: log查看流
date: 2017-11-03 19:35:23
categories: linux
tags: linux
---

## 背景
最近看各种log文件，所以有一些常用的命令去查看文件，记录一下。

## 流程

1、先查看文件的行数

``` shell
wc -l xxx.log
```

<!-- more -->

2、 参看文件末尾100行

``` shell
tail -n 20 xx.log
# 不执行行数 则默认出10行
```

3、查看文件全部内容

``` shell
cat -n xx.log
```

4、查看文件头20行

``` shell
head -n 20 xx.log
# 如果不指定行数 则默认10行
```

5、 实时查看文件变动

``` shell
tail -f xx.log
```

6、查看文件中的某些行

``` shell
sed -n '10,100p' xx.log
# p不能省去。 表示10-100行
```

7、从后往前显示文件

``` shell
tac xxx.log
```
但是 tac 可以和tail一起用，可以查看debug的log(其实用处也不大)

``` shell
tail xx.log | tac 
```

8、组合命令查看文件中的某些行

``` shell
# 从3000行开始，展示100行，
cat -n xx.log | tail -n 3000 | head -n 100

# 显示1000到1500行
cat -n xx.log | head -n 1500 | tail -n +1000

# 其中
tail -n 100 # 显示最后100行
tail -n +100 # 显示第100行之后的所有行
head -n 100 # 显示当前开始的前100行
```

## 参考资料

[Linux显示文件中间几行](http://www.cnblogs.com/xianghang123/archive/2011/08/03/2125977.html)

安利一个全文搜索工具：
[The\_silver\_searcher----AG](https://github.com/ggreer/the_silver_searcher)

