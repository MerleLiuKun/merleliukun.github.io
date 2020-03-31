---
title: Manjaro 入门
date: 2020-03-26 00:39:57
categories:
- Linux
- Manjaro
tags:
- Linux
keywords: Manjaro install
cover: https://i.loli.net/2020/03/31/x86vStZNAmIokCb.jpg
---

`Manjaro` 是一款基于 `Arch Linux` 的、对用户友好、全球排名第 1 的Linux发行版, 从使用上来看，比 `Arch` 更加易用，面向的人群是新手和初级人员还有那些不愿意折腾，却又想使用 `Arch` 新特性的人群。

系统安装
=======

资源
----

中文镜像地址: 
- [中科大地址](https://mirrors.ustc.edu.cn/manjaro-cd/)
- [清华大学地址](https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/)

官方镜像地址: 
- [Manjaro Downloads](https://manjaro.org/download/)
  
启动盘制作: 
- [Rufus](https://rufus.ie/zh_CN.html)

安装
----

选择中文，根据提示一步一步安装即可，要注意如下情况：

1. 如果是独立显卡时，可能出现黑屏，在启动配置页面可以选择 `nofree` 驱动。
2. 系统安装过程中，分区时，注意给 `boot` 分区增加一些空间，建议 1 G, 避免多内核切换时出现存储不足。


系统配置
=======

软件源
------

[配置 Pacman 源](http://mirrors.ustc.edu.cn/help/manjaro.html)

``` bash
sudo pacman-mirrors -i -c China -m rank
```
可选择，清华源(tuna.tsinghua), 中科大源(ustc)

Pacman 常见命令
```
pacman -Syu # 同步数据包后更新系统

pacman -Sy 包名 # 同步包数据库后安装。

pacman -R 包名 # 删除包不删除依赖
pacman -Rs 包名 # 删除包的同时删除不被其它包使用的依赖
pacman -Rd 包名 # 删除包不检查依赖

pacman -Ss 关键字 # 搜索含关键字的包。
pacman -Qi 包名 # 查看有关包的信息。

pacman -Sc Pacman #清理未安装的包文件
```


[配置 ArchLinuxCN 源](http://mirrors.ustc.edu.cn/help/archlinuxcn.html)

``` bash
sudo vim /etc/pacman.conf
```

输入如下内容
``` conf
[archlinuxcn]
SigLevel = Optional TrustedOnly
# 清华源
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
# 中科大源
# Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
```

导入 GPG key

``` bash
sudo pacman -Syyu && sudo pacman -S archlinuxcn-keyring  && sudo pacman -Syyu
```

[配置 AUR 源](https://mirror.tuna.tsinghua.edu.cn/help/AUR/)

之前有用 `yaourt` 作为 `AUR` 的助手工具，但是这个已经在 `Arch` [官方Wiki](https://wiki.archlinux.org/index.php/AUR_helpers_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))上被列为 "停止或有问题"，所以推荐使用[yay](https://github.com/Jguer/yay)或者[aurman](https://github.com/polygamma/aurman)等。

此处，以 `yay` 为例。

执行以下命令修改 `aururl`:

``` sh
yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
```

修改的配置文件位于 ~/.config/yay/config.json ，还可通过以下命令查看修改过的配置：

``` sh
yay -P -g
```

输入法配置
---------

可以选用 sogou 拼音输入法，google 拼音输入法，sun 拼音输入法。

安装 `fcitx`

``` sh
sudo pacman -S fcitx
sudo pacman -S fcitx-sogoupinyin
sudo pacman -S fcitx-configtool
```

设置环境变量文件

``` sh
vim ~/.pam_environment
```

添加如下内容:

```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```

重启一下电脑即可生效。


字体配置
-------

安装字体支持 `emoji`：

``` sh
sudo pacman -S noto-fonts-emoji  # Google 的 emoji 字体
yay ttf-symbola  # 提供许多 Unicode 符号，包括 Emoji
```

中文字体:

```
sudo pacman -S wqy-microhei
sudo pacman -S wqy-zenhei
sudo pacman -S wqy-bitmapfont 
```

修改主目录为英文
--------------

``` sh
sudo pacman -S xdg-user-dirs-gtk
export LANG=en_US
xdg-user-dirs-gtk-update
# 然后会有个窗口提示语言更改，更新名称即可
export LANG=zh_CN.UTF-8
sudo pacman -Rs xdg-user-dirs-gtk
```

软件安装
=======

zsh
----

使用 [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) 来管理 `zsh` 配置。

``` sh
# 安装
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 如果没有切换到默认 shell 可手动设置
chsh -s /bin/zsh 
```

JDK
----

可以使用 `yay` 安装：

``` sh
yay -S jdk8  # 安装 JDK8
# 查看 JDK
archlinux-java status
# 设置默认
sudo archlinux-java set java-8-jdk
```

VIM
----

```
sudo pacman -S vim  
```

推荐使用 [vim plug](https://github.com/junegunn/vim-plug) 来进行插件管理。

``` sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

代理
----

``` sh
sudo pacman -S proxychains-ng
# 修改配置文件
sudo vim /etc/proxychains.conf
# 添加 如下语句到最后
socks5 127.0.0.1 1080 # 假设端口为 1080
```


常见软件
-------

``` sh
sudo pacman -S deepin-screenshot # 深度截图
sudo pacman -S deepin-system-monitor # 系统状态监控
sudo pacman -S postman-bin # HTTP
sudo pacman -S visual-studio-code-bin
sudo pacman -S unrar unzip
sudo pacman -S net-tools
sudo pacman -S jetbrains-toolbox
```
