---
title: Linux修改某用户默认Shell
date: 2017-09-27 14:38:25
categories: linux
tags: linux
---

### 问题:

在Linux服务上，安装了`Oh-My-Zsh`.但是因为自己只是一个普通用户，所以要对自己用户下的默认shell进行设置。

### 方法：

#### 临时修改shell

<!-- more -->

我们可以对当前使用的shell进行改变，直接调用不同`sheel`名称进入到`shell`环境中去。

首先我们可以使用命令`cat /etc/shells`得到当前系统支持的shell环境。
merle
``` shell
merle@bogon ~ ❯❯❯ cat /etc/shells                                                                                                     
/bin/sh                                                                                                                              
/bin/bash                                                                                                                            
/sbin/nologin                                                                                                                        
/usr/bin/sh                                                                                                                          
/usr/bin/bash                                                                                                                        
/usr/sbin/nologin                                                                                                                    
/bin/tcsh                                                                                                                            
/bin/csh                                                                                                                             
/bin/zsh          
```

切换shell环境

``` shell
merle@bogon ~ ❯❯❯ bash                                                                                                                
[merle@bogon ~]$ sh
sh-4.2$ csh
[merle@bogon ~]$ zsh
merle@bogon ~ ❯❯❯    
```
使用`echo $SHELL`可得到当前的shell环境。

#### 修改用户默认的shel

我们知道在linux系统的`/etc/passwd`文件内是保存系统内所有用户和用户的设置。

对某用户的默认设置也在这里。首先我们可以查看一下当前的用户设置。

``` shell
merle@bogon ~ ❯❯❯ grep merle /etc/passwd                                                                                               
merle:x:1000:1000:merle:/home/merle:/bin/zsh 
```

一、我们可以使用`chsh`命令修改某用户的默认`shell`

使用如下：

``` shell
merle@bogon ~ ❯❯❯ chsh                                                                                                                
Changing shell for merle.
New shell [/bin/bash]: /bin/zsh
密码：
Shell changed.
merle@bogon ~ ❯❯❯

# 再次查看该用户设置
merle@bogon ~ ❯❯❯ grep merle /etc/passwd                                                                                               
merle:x:1000:1000:merle:/home/merle:/bin/zsh    
```
但是有可能系统不支持该命令。可以使用如下方法。

二、 使用`usermod`命令

用法如下：

``` shell
usermod -s /bin/zsh merle

# 再次查看该用户设置
merle@bogon ~ ❯❯❯ grep merle /etc/passwd                                                                                               
merle:x:1000:1000:merle:/home/merle:/bin/zsh    
```
由上，我们可以在创建用户的时候指定默认`shell`.

``` shell
useradd -s /bin/zsh username
```

give me a five.
同步更新于简书[笨猪_Merle](http://www.jianshu.com/p/1661b8c03edd)

