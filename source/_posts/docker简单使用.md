---
title: docker简单使用
date: 2017-07-22 16:41:44
tags: 
    - docker
    - linux

categories: linux
---
简介:
==============

Docker是一个开源的引擎，可以轻松的为任何应用创建一个轻量级的、可移植的、自给自足的容器。开发者在笔记本上编译测试通过的容器可以批量地在生产环境中部署，包括VMs（虚拟机）、bare metal、OpenStack 集群和其他的基础应用平台。 
Docker通常用于如下场景：

- web应用的自动化打包和发布；
- 自动化测试和持续集成、发布；
- 在服务型环境中部署和调整数据库或其他的后台应用；
- 从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境
	
<!--more-->
删除：
==============
1.删除container
	
	a.单独删除具体某一个容器
	➜  ~ sudo docker rm CONTAINER_ID
	➜  ~ sudo docker rm -f 删除运行中的容器 
	b.删除当前所有容器(已终止运行)
	➜  ~ sudo docker rm $(sudo docker ps -a -q)

2.删除image

	a.删除某个镜像
	➜  ~ sudo docker rmi <image_id>

	b.删除所有镜像
	➜  ~ sudo docker rmi $(sudo docker images -q)

	c.删除所有untagged的镜像(就是id为None的镜像)
	➜  ~ sudo docker images | grep "^<none>" | awk "{print $3}"

	
查看：
==============

	1.查看所有容器
	➜  ~ sudo docker ps -a
	2.查看所有正在运行的容器
	➜  ~ sudo docker ps

	3.查看镜像
	➜  ~ sudo docker images
	

运行：
==============


	1.创建一个container
	➜  ~ sudo docker run image_name

	2.启动一个container
	➜  ~ sudo docker run container_name
	
	3.重命名container
	➜  ~ sudo docker rename old_name new_name

	4.重启某个容器
	➜  ~ sudo docker restart container_name

Tips:

	docker run 的相关参数说明:
	--name 指定容器名
	
	-p 指定端口映射 eg 3306:3306
	
	-v 挂载数据卷或者本地目录映射 :ro 挂载为只读
	
	-d 后台持续运行
	
	-i 交互式操作
	
	-t 终端

	-rm 容器退出后随之将其删除(与-d 冲突)

停止：
==============

	
	1.停止所有正在运行的容器 
	➜  ~ sudo docker kill $(docker ps -q) 
	
相关示例：
==============


1.使用docker创建postgresql数据库容器

	sudo docker search postgres
	sudo docker pull postgres:9.5.7
	
	使用镜像创建容器，并运行
	sudo docker run --name postgres-server -p 5432:5432 -e POSTGRES_PASSWORD=111111 -d postgres:9.5.7

	启动容器
	sudo docker start container_id

	使用镜像创建一个client
	sudo docker run --name postgresql-client  -it --link postgres-server:postgres postgres:9.5.7 psql -U postgres

此时就可以在client中的命令行上实现操作数据库啦。

2.使用docker创建mysql数据库容器

	
	# 查询mysql镜像
	sudo docker search mysql
	# 拉到本机
	sudo docker pull mysql
	
	# 创建一个mysql服务端,并将端口映射到本机的3306端口
	sudo docker run --name mysql-server -p 3306:3306 -e MYSQL_ROOT_PASSWORD=yourpassword -d mysql	
	
	# 创建一个mysql客户端，用来管理数据库
	sudo docker run --name mysql-client -it --link mysql-server:mysql mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

	# 启动容器
	sudo docker start container_name

注： 
可以通过指定mysql数据库的外部数据卷，让数据保存在本机上，便于迁移。

	-v /my/own/datadir:/var/lib/mysql
	其中 ：号前面是本机的数据卷地址，
	这样表示宿主机的/my/own/datadir目录挂载到容器内的/var/lib/mysql目录。
现在就可以像在本机安装mysql数据库一样的使用啦。

