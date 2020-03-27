---
title: Manjaro 使用中出现的奇妙问题
date: 2020-03-08 23:36:17
categories:
- Linux
- Manjaro
tags:
- Linux
keywords: Manjaro questions
cover: https://i.loli.net/2020/03/09/IqEkKYm3zjJQBbH.jpg
---

此处记录使用 `Linux` 发行版 `Manjaro` 中出现的一些小问题，以及对应的解决方式。

包管理
======

Pacman 更新时出现文件已存在
--------------------------

报出的错误如下:

```
conflicting files:
npm: /usr/lib/node_modules/npm/node_modules/minizlib/node_modules/minipass/LICENSE already exists in filesystem
npm: /usr/lib/node_modules/npm/node_modules/minizlib/node_modules/minipass/README.md already exists in filesystem
...
```

解决方式

可以直接使用 `overwrite` 强制重写文件:

```
sudo pacman -S npm --overwrite /path/to/npm
```

硬件
====

蓝牙
----

安装依赖

``` sh
sudo pacman -S bluez bluez-utils pulseaudio-bluetooth pavucontrol pulseaudio-alsa pulseaudio-bluetooth-a2dp-gdm-fix
```
