---
title: docker-compose部署web项目
date: 2017-08-08 09:15:05
categories: docker
tags: docker
---

需求：
===
1. 要在docker中运行运行Web项目
2. 需要一个数据库存储
3. 部署简易。

-------

解决：
===
基于docker-compose实现部署项目
---

<!-- more -->

当前项目结构

├── db_proj  
│   ├── db.sql    
│   └── Dockerfile
├── docker-compose.yml  
└── web\_proj  
    ├── DataPlatformSystem  
    │   ├── manage.py  
    │   ├── README.md  
    │   ├── requirements.txt  
    │   ├── tests  
    │   │   └── \_\_init\_\_.py  
    │   └── webapp  
    │       ├── config.py  
    │       ├── \_\_init\_\_.py  
    └── Dockerfile 

docker-compose的配置文件内容


	db:
	    build: ./db_proj
	    # image: postgres:9.5
    	environment:
        	- POSTGRES_USER=postgres
	        - POSTGRES_PASSWORD=111111
        	# - POSTGRES_DB=testDB
    	ports:
        	- "5432:5432"
	web:
	    build: ./web_proj
	    command: python /app/DataPlatformSystem/manage.py
    	volumes:
	        - /app/DataPlatformSystem
    	ports:
    	    - "5000:5000"
    	    - "8001:8001"
    	    - "9001:9001"
    	links:
    	    - db
    	lables:
			com.dragonteam.des: "数据管理平台"
			com.dragonteam.department: "DragonTeam"
			com.dragonteam.release: "v0.5"

db_proj下的Dockerfile

	FROM postgres
	ENV POSTGRES_DB test
	COPY db.sql /docker-entrypoint-initdb.d/

web_proj下的Dockerfile

	FROM ubuntu
	COPY DataPlatformSystem /app/DataPlatformSystem
	WORKDIR /app/DataPlatformSystem
	RUN buildDeps='python python-pip python-dev python-tk'\
	   	&& cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    	&& sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    	&& apt-get update && apt-get install --assume-yes apt-utils \
    	&& apt-get install -y $buildDeps \
    	&& pip install  --upgrade pip \
    	&& pip install -r /app/DataPlatformSystem/requirements.txt

----------------------------------
所遇问题：
===
数据库容器连接问题：
---

如果web应用的容器和数据库服务的容器分离，就要使用`links`指定关联、

	links:
      	- db

那么在web应用中的配置信息中就要使用此配置信息，

	 SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:111111@db/test'

其中的`db`就是`links`的配置内容。

路径问题：
---
在docker-compose.yml中使用`build`命令时，指定的路径可以是绝对路径，或者是相对于`docker-compose.yml`文件的相对路径。

	build: /path/to/build/dir


------------------------------



参考资料：

[Docker从入门到实战](https://yeasy.gitbooks.io/docker_practice/content/compose/django.html)

[Docker部署Flask项目](http://www.patricksoftwareblog.com/how-to-use-docker-and-docker-compose-to-create-a-flask-application/)

[使用docker-compose](http://dockone.io/article/332)

[docker-postgres-issue](https://github.com/docker-library/postgres/issues/203)

[Docker初始化导入数据库文件](https://stackoverflow.com/questions/37834435/docker-compose-postgresql-import-dump)

