---
title: ffmpeg使用笔记一
date: 2017-10-27 09:47:05
categories: other
tags: other
---

简介
===

ffmpeg是处理音频和视频的程序，可以将音频和视频装换成流，并且包含了音频/视频的解码库libavcodec，提供了一套很完整的音视频解决方案。
[了解更多](https://zh.wikipedia.org/zh-cn/FFmpeg)

相关资源
---

[ffmpeg官网地址](http://ffmpeg.org/)

[ffmpeg的Github项目地址](https://github.com/FFmpeg/FFmpeg)

<!-- more -->

常用参数介绍
===

主要参数
---

- -i 跟输入文件
- -f 设置输出格式
- -y 输出文件已存在则覆盖该文件
- -fs 超过制定的文件大小则结束转换
- -ss 制定开始时间
- -t 从-ss时间开始转换的持续时间
- -title 设置标题
- -timestamp 设置时间戳
- -vsync 增减Frame使得影音同步 

视频相关参数
---

- -b:v 设置视频流量，默认为200Kbit/s
- -r 设置帧率  默认为25
- -s 设置画面的宽和高
- -aspect 设置画面的比例
- -vn 不处理视频，于仅针对声音做处理时使用。
- -vcodec(-c:v)  设置视频编解码器，未设置时使用与输入文件相同的编解码器

音频相关参数
---

- -b:a 设置每个通道的流量
- -ar 设置采样率
- -ac 设置声音的通道数目
- -acodec 设置音频编解码器，未设置时使用与输入文件相同的编解码器
- -an 不处理声音，仅针对视频做处理时使用
- -vol 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推。）

基础命令
===

ffmpeg版本对应信息
---

1、 查看当前版本所包含的编解码器

``` shell
ffmpeg -formats
输出:
D  3dostr          3DO STR
 E 3g2             3GP2 (3GPP2 file format)
 E 3gp             3GP (3GPP file format)
D  4xm             4X Technologies
 E a64             a64 - video for Commodore 64
  ......
```

常见用法
===

视频相关操作
---

1、查看视频(音频)信息

	ffmpeg -i test1.avi
	ffmpeg -i test2.mp3

2、将一组图片序列合成视频

``` shell
ffmpeg -f image2 -i image%d.jpg output.mpg
# -i image%d.jpg  将当前目录下的image1.jpg、image2.jpg...包含
```
3、 将视频分解成图片序列

``` shell
ffmpeg -i test1.mpg image%d.jpg
```
4、将.mpg 装换成 .avi文件

``` shell
ffmpeg -i test1.mpg out.avi
```

5、 从视频中抽出声音，存为.mp3文件

``` shell
ffmpeg -i test1.avi -vn -ar 44100 -ac 2 -ab 192 -f mp3 sound.mp3
```

音频相关操作
---

1、拼接多个音频

需求： 将`test1.mp3`和`test2.mp3`两个文件连接在一起。

``` shell
ffmpeg -i "concat:123.mp3|124.mp3" -acodec copy output.mp3
# 其中 -acodec copy 表示重新编码并且复制到输出文件中。
```

2、 混合多个音频
需求： 将`test1.mp3`和`test2.mp3`混合成一个音频，以第一个文件的长度为准。

``` shell
ffmpeg -i test1.mp3 -i test2.mp3 -filter_complex amix=inputs=2:duration=first:dropout_transition=2 -f mp3 output.mp3
# --filter_complex: ffmpeg的滤镜功能
# amix 表示混合多个音频到单个音频
# inputs=2：表示输入两个音频文件，可以多个
# duration：表示输出文件的长度 有多个参数
#      - longest 最长
#      - shortest 最短
#      - first  第一个文件长度
# dropout_transition：输入流结束时（音频）容量重整化的转换时间（以秒为单位）。 默认值为2秒
```

3、 截取一个音频

需求： 截取`test1.mp3`音频文件的开始一分钟

``` shell
ffmpeg -i test1.mp3 -acodec copy -ss 00:00:00 -t 00:01:00 output.mp3
# -ss 开始截取的时间点
# -t 截取音频的时间长度
```

4、音频文件的格式转换

需求： 将`test1.ape`转换成`test1.mp3`格式

``` shell
ffmpeg -i test1.ape -ar 4410 -ac 2 -ab 16k -vol|50 -f mp3 test1.mp3
# -ar 设置音频采样频率
# -ac 设置音频通道数
# -ab 设置声音比特率
# -vol 设置音量 256为标准音量。（要设置成两倍音量时则输入512，依此类推。）
```

参考文章
===

- [维基百科FFmpeg](https://zh.wikipedia.org/wiki/FFmpeg)
- [官方文档ffmpeg](https://www.ffmpeg.org/ffmpeg.html)
- [ffmpeg音频合并](http://blog.sina.com.cn/s/blog_50e610900102vkab.html)

