---
title: mysqlclient 安装问题
date: 2020-05-06 21:23:11
categories:
- python
tags:
- python
keywords: macos mysqlclient
---


Linux 下如果已经本地安装了 `MySQL` 或者 `MariaDB` 此时可以直接使用命令安装。

``` shell
pip install mysqlclient
```

如果没有安装，需要先准备 `MySQL` 的开发依赖库。

``` shell
sudo apt-get install default-libmysqlclient-dev build-essential # Ubuntu/Debian
sudo yum install mysql-devel # CentOS/RedHat
sudo pacman -S libmysqlclient # Arch/Manjaro

#　执行安装
pip install mysqlclient
```

MacOS
=====

MacOS 下，如果使用了 `Homebrew` 安装了 `MySQL`，可执行如下流程

``` shell
# 确认在 Python 虚拟环境下
# 假设本地为 MySQL 5.7.29 版本
export PATH="/usr/local/Cellar/mysql@5.7/5.7.29/bin/:$PATH"

# 如果安装时爆出 ld: library not found for -lssl
# 需要指定 SSL 的依赖
# 但此问题已在 master 分支处理，但未合并(2020-5-6)
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# 执行安装
pip install mysqlclient
```
