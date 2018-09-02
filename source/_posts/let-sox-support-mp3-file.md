---
title: let-sox-support-mp3-file
date: 2017-11-08 14:25:29
categories: linux
tags: linux
---

## 问题
直接通过`brew install sox`安装的sox出现如下:

```shell
SoX was compiled with neither MP2 nor MP3 encoding support
```
原因就是当前的sox并没有用于`mp2`或者`mp3`文件的编解码器。
对于sox支持mp3文件，需要依赖一些包。

<!--more -->

## 方法

### 安装对应依赖

可以通过先使用如下命令将对应的依赖包都安装。

``` shell
brew install sox
brew uninstall sox
```

或者直接安装对应的依赖包，如下：

``` shell
brew install opencore-amr libao flac two-lame libtool mad libid3tag libmagic
libvorbis libpng libsndfile wavpack lame
```

### 源码编译 

官方的包对于macOS系统支持会有问题。所以可以下载如下仓库的包。

``` shell
git clone https://github.com/mansr/sox
```

进行编译

``` shell
cd sox

autoreconf -i
./configure
make -s && make install 
```


## 参考资料

- [官方仓库](https://sourceforge.net/projects/sox/)
- [Homebrew-sox](http://formulae.brew.sh/formula/sox)
- [How-to-compile-SoX](https://audiodigitale.eu/?p=25)
