---
title: MinIO对象存储服务一
date: 2019-05-25 17:40:16
categories: 杂项
tags:
- MinIO
- 存储
---

简介
===

来自官网的介绍:

[MinIO](https://docs.min.io/cn/minio-quickstart-guide.html) 是一个基于 `Apache License v2.0` 开源协议的对象存储服务。它兼容亚马逊S3云存储服务接口，非常适合于存储大容量非结构化的数据，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等，而一个对象文件可以是任意大小，从几kb到最大5T不等。

`MinIO` 是一个非常轻量的服务,可以很简单的和其他应用的结合，类似 NodeJS, Redis 或者 MySQL.

简单来说, 我们可以基于 `MinIO` 搭建一个类似亚马逊S3(腾讯云OSS)的存储服务。

<!--more-->

安装部署
===

官网上给出的安装步骤十分详细和完整。这里只简单罗列一下。 以下使用 `Docker` 进行部署的.

安装
---
[官网详细安装说明](https://docs.min.io/cn/minio-quickstart-guide.html)

拉取镜像

``` bash
sudo docker pull minio/minio
```

为了方便升级，迁移等操作, 我们将 `MinIO` 的数据放到宿主机上, 然后挂载到容器里。另外因为使用 `Docker` 部署, 所以需要自定义初始的账号信息. 基础的命令如下:

``` bash
sudo docker run -p 9000:9000 --name minio-server \
  -e "MINIO_ACCESS_KEY=Your Key" \
  -e "MINIO_SECRET_KEY=Your Secret" \
  -v /data/minio_data:/data \
  -v /data/minio_config:/root/.minio \
  -d minio/minio server /data
```

> 可以将命令写到脚本里, 方便修改和执行。

此时, `MinIO` 服务已经起来了. 如果你是在本地搭建的, 可以使用你指定的账号信息访问 http://127.0.0.1:9000. 如果可以访问, 即表明已经部署成功。

Nginx配置
---

如果我们想要搭建一个私有的存储服务，那么部署一定是在服务器上。我们可以使用 `Nginx` 配置一下代理.
官方也给了使用 `Nginx` 做代理的配置说明 [为MinIO Server设置Nginx代理](https://docs.min.io/cn/setup-nginx-proxy-with-minio.html) 。

简单列一下我的配置.

``` nginx
upstream minioServer {
    server 127.0.0.1:9000;
}

# minio
server {
    listen       80;
    server_name  img.example.com;  # your domain
    return 301 https://$host$request_uri;
}

# https
server {
    listen        443;
    server_name   img.example.com;

    ssl_certificate      /path/to/chain.pem;
    ssl_certificate_key  /path/to/privkey.pem;

    location / {
        proxy_set_header Host $http_host;  # 请求头转发
        proxy_pass http://minioServer;
    }
}
```

重启 `Nginx` 服务. 然后可以 访问 https://img.example.com 来验证配置状态。

其他配置
---

`MinIO` 提供了更多的一些配置，比如 `TLS安全访问`, `状态通知`等, 可以依据官方文档进行相关的配置。


接下来, 就可以愉快的使用它了。

参考
===

- [官方Github](https://github.com/minio/minio)
- [官方文档](https://docs.min.io/)
