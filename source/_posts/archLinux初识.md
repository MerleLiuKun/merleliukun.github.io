---
title: archLinux初识
date: 2017-08-06 22:23:31
categories: linux
tags: linux
---

##Arch-Linux 配置小记（一）

####一、Arch-Linux简介  
****
#####1.简介  
&#160;&#160;&#160;&#160;Arch Linux是朝向轻量（lightweight）以及简单（simple）的Linux发行版。其中“简单”（Simplicity）被定义为“避免不必要或复杂的修改”，也就是说，是由开发者角度定义，而非用户角度思考。  因此，受到了许多开发者的喜爱。  
&#160;&#160;&#160;&#160;作为小白的我，本着对技术的好奇心。也学习一下它的简单玩法。本文纯小白文。欢迎阅读.....
<!-- more -->

#####2.环境  
&#160;&#160;&#160;&#160;kernel：基于Arch——linux [archlinux-2016.09.03-dual.iso](http://mirrors.163.com/archlinux/iso/2016.09.03/archlinux-2016.09.03-dual.iso)  
&#160;&#160;&#160;&#160;环境：VMware Workstation12  

####二、配置过程记录
****
#####1.磁盘分区  
&#160;&#160;&#160;&#160;与其他发行版本的linux的分区不同，Arch的磁盘分区采用纯命令行的操作（包括以后的安装过程）。参阅[Arch Wiki](https://wiki.archlinux.org/index.php/Partitioning_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))里的相关内容。  
&#160;&#160;&#160;&#160;这里我们以gdisk(GPT下的fdisk)来进行磁盘分区。  
&#160;&#160;&#160;&#160;在VM里创建了虚拟机后，开启虚拟机，进入了命令行，此时可以查看当前的分区内容，命令：
  
	fdisk -l

此时，可以看到系统的主分区，一般为sda(sdx)。  

开始进行分区： 命令：
  
	gdisk /dev/sda

进入交互模式：

	Command（？ for help）:

此时输入n可以开始添加分区，逐次选择分区号，起始扇区，终止扇区和文件系统类型（hex code）。  以分区1：boot，分区2：swap，分区3：根分区，分区4：home。  
eg：boot分区  
&#160;&#160;&#160;&#160;(1).分区的分区号默认为1 （boot）  
&#160;&#160;&#160;&#160;(2).起始扇区选择默认  
&#160;&#160;&#160;&#160;(3).终止扇区设置为"+300M",表示大小为300M  
&#160;&#160;&#160;&#160;(4).hex code选默认（8300）表示为"Linux File System",如果是swaq分区时则要设置为(8200)表示为swap分区

依次设置完毕后，在交互模式下键入 p 可以查看分区的详细信息，确认后可以键入 w 将分区信息写入磁盘。  
设置完毕后 Ctrl+c 退出交互模式，回到命令行，首先我们要将boot分区的格式设置为EFI System， 可以使用命令：
  
	parted /dev/sda
	(parted) set 1 boot on 

分区完成之后，可以开始下一步

#####2.格式化并挂载磁盘  
上一步我们完成了分区，sda1~4 分别对应boot,swap,/根目录,home。首先格式化一般的存储目录。 命令：  
	
	mkfs -t ext4 /dev/sda1
	mkfs -t ext4 /dev/sda3
	mkfs -t ext4 /dev/sda4

对于交换分区使用mkswqp命令设置格式  
	
	mkswap /dev/sda2

设置完毕之后，我们将分区挂载到文件系统上，命令：
	
	mount /dev/sda3 /mnt
	mount /dev/sda1 /mnt/boot
	mount /dev/sda4 /mnt/home
	swapon /dev/sda2

其中挂载swap分区的命令有点不同，另外，在挂载之前应先创建好相关的目录，命令：
	
	cd /mnt
	mkdir boot
	mkdir home

此时挂载完毕。

#####3.在挂载点安装arch
此时我们使用pacstrap命令从网上安装基础包和基础开发包，在这一步之前，由于软件源的原因，我们要想完成的速度快，需要更改源。
	
	vi /etc/pacman.d/mirrorslist
将其他地区的源删除，保留中国地区的，建议使用阿里云或者163的源在最前面。

 好了开始安装，命令：
	
	pacstrap /mnt base base-devel

等待一段时间（30m）左右，即可安装完毕。  
此时我们要首先设置硬件启动时自动挂载分区，否则进入系统。 命令：
	
	genfstab -p /mnt >> /mnt/etc/fstab

fstab文件的作用就是，启动时自动挂载磁盘分区，并检测交换分区（swap）

#####4.安装引导bootloader
系统安装完毕之后，会需要引导来进入操作系统，常见的引导有grup和syslinux,此处我们选择Syslinux。它的相关配置可以查阅 [Syslinux Wiki](https://wiki.archlinux.org/index.php/Syslinux)

首先安装syslinux， 命令：
	
	pacstrap /mnt syslinux

自动配置syslinux， 命令:
	
	syslinux-install_update -i -a -c /mnt

安装完成后，键入命令：*****
	
	arch-chroot /mnt

进行配置语言、时区等，其中选择语言时需要修改文件 `/etc/locale.gen` 建议选择英文，避免命令行乱码。
	
	locale-gen
	echo LANG="en_US.UTF-8" > /etc/locale.conf
	ln -s /usr/share/zoneinfo/Asia/Shahai /etc/localtime


然后需要修改syslinux的配置信息，在`/boot/syslinux/syslinux.cfg`文件中有一些xxx.c32模块，需要把对应的`/usr/lib/syslinux/bios/XXX.c32`复制到`/boot/syslinux/`目录下。 主要应该有四个menu.c32、vesamenu.c32、 reboot.c32、 hdt.c32。

在运行命令：
	
	extlinux --install /boot/syslinux

此时bootloder安装完毕，此后需要增加一个启动系统的指令 即gptmbr.bin, 命令：
	
	dd conv=notrunc bs=440 count=1 if=/usr/lib/syslinux/bios/gptmbr.bin of=/dev/sda

最后，初始化磁盘环境， 命令：
	
	mkinitpio -p linux

退出chroot， 命令：`exit`。取消挂载，并重启，命令：
	
	umount -R /mnt
	swapoff /dev/sda2

重启后就可以通过syslinux引导进入arch-linux的系统了，此时的用户为root，不需要密码。当前系统只有tty(即黑窗口),并无桌面环境。

好啦，第一次先进行这么多， 下一次再对我们的arch-linux进行进一步完善。呜啦啦啦未完待续........


