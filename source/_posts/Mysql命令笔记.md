---
title: Mysql命令笔记
date: 2017-09-19 20:16:00
categories:
- 数据库
tags:
- 数据库 
- MySQL
---
## Mysql相关的命令记录

> 记录一些用到的命令

### docker相关

1、创建一个mysql容器

``` shell
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -d mysql
```
<!-- more -->

2、docker登录进入到容器中

``` shell
docker exec -it (container_name/id) /bin/bash
```

### 数据库整体相关

1、查看数据库的编码

``` sql
show variables like 'character%';
```

2、查看数据表的定义

``` sql
-- 两者都行
desc (table_name);
describe (table_name);
```

3、创建新用户

首先使用`root`账户登录。

执行如下操作：

```sql
insert into mysql.user(Host,User,authentication_string,ssl_cipher,x509_issuer,x509_subject) values("localhost","your-name",password("123456"),"","","");
```

需要注意的是在mysql5.7之前的版本中`authentication_string`字段是对应`Password`字段的。

另外Host指定为`localhost`，表示只能本地访问，如果想要远程访问需要改为`%`。

登录新用户前需要重启一下`mysql`的服务。否则会报出错误。错误代码如下：`ERROR 1045 (28000)`。

4、删除用户

使用`root`账户登录。

执行如下操作：

```sql
use mysql;
Delete from user where User="your-name";
```

5、将数据库的权限授予某个用户

使用`root`账户登录。

``` sql
-- 授权(所有权限)
grant all privileges on test_g.* to name@localhost identified by '123456';

-- 刷新权限表
flush privileges;

-- 授予某用户test数据库的某些权限(select, update)
grant select,update on test.* to name@localhost identified by '123456';

-- 授予某用户所有数据库的某些权限(此处被非本地主机)
-- 要对本地主机授权，使用localhost替换 %
grant select,delete,update,create,drop on *.* to name@"%" identified by "123456";

```
其命令格式为：

grant 权限 on 数据库.* to 用户名@登录主机 identified by "密码";

6、展示当前运行的线程。

展示出当前正在运行的所有线程，子角色只能看到自己发起的线程。

``` sql
show processlist;
```
7、修改数据库的编码

mysql默认的编码是`latin1`。但是我们在使用的时候由于需要一些中文或者其他原因。需要更改数据库的编码格式。

创建数据库的时候可以指定编码格式。

``` sql
create database db_name character set utf8;
```

a.命令行方式 

>此种方式不推荐使用，并且只在当前窗口有效。

``` sql
set character_set_client=utf8;
set character_set_connection=utf8;
...
```

b.修改配置文件`my.cnf`文件，位于`/etc/mysql/my.cnf`
> 需要重启生效

``` sql
-- 增加或者修改。
[client]
default-character-set=utf8

[mysqlId]
character-set-server=utf8
default-character-set=utf8
```

8、展示数据表的状态信息

命令语法：

``` sql
SHOW TABLE STATUS
    [{FROM | IN} db_name]
    [LIKE 'pattern' | WHERE expr]
```
显示出当前数据库中的数据表的各种信息。

eg:

``` sql
show table status like "table_name";
```

持续更新中。。。

