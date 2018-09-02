---
title: ffmpeg-concat-video-and-mix-audio.md
date: 2018-01-06 18:42:27
categories: other
tags: other
---

需求
===

将N个片段视频文件连接，并合并额外的音频文件

解决方案：
===

在`ffmpeg`中，官网给出两种连接媒体文件(音频、视频、etc..)的解决方案。
- the concat "demuxer"
- the concat "protocol"

对比而言， `demuxer`更加灵活一些，需要媒体文件是属于相同的编解码器，但是可以属于不同的容器格式(mp3,wav, mp4, mov, etc..).
而`protocol`只适用于少数集中容器格式。

<!-- more -->
使用`concat demuxer`连接视频文件
---
`demuxer`从一个文本文件中读取文件或者其他指令的列表，然后注意的对他们进行解复用。就像把他们的数据包混合到一起。

步骤：

1.创建一个文件`mylist.txt`，包含你想要连接的所有文件，格式如下：

    file 'path/to/file1'
    file 'path/to/file2'
    file 'path/to/file3'

其中的文件路径可以是相对路径或者是绝对路径。

2.ffmpeg命令

``` shell
ffmpeg -f concat -safe 0 -i mylist.txt -c copy output
```
如果对应的路径为相对路径 参数`-safe 0`就不是必须的。

3.自动生成输入文本文件的

可以使用如下shell脚本生成。
``` shell
# with bash or zsh for loop
for f in *.mp4; do echo "file '$f'" >> mylist.txt; done
# or with printf
printf "file '%s'\n" *.mp4 > mylist.txt
```

使用`Concat protocol` 连接视频文件
---

`demuxer` 是在文件流级别工作，而`cancat protocol`则是在文件级别操作。
可以将使用MPEG-2传输流的文件连接在一起。类似于在类unix系统上使用`cat`，或在windows系统上使用`copy`.

1.下面的命令连接了三个`MPEG-2 TS`文件，并将它们连接在一起，但不进行重编码

```shell
ffmpeg -i "concat:input1.ts|input2.ts|input3.ts" -c copy output.ts
```

2.使用中间文件
```shell
ffmpeg -i input1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts intermediate1.ts
ffmpeg -i input2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts intermediate2.ts
ffmpeg -i "concat:intermediate1.ts|intermediate2.ts" -c copy -bsf:a aac_adtstoasc output.mp4
```

3.使用命名管道避免中间文件
```shell
mkfifo temp1 temp2
ffmpeg -i input1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp1 2> /dev/null & \
ffmpeg -i input2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp2 2> /dev/null & \
ffmpeg -f mpegts -i "concat:temp1|temp2" -c copy -bsf:a aac_adtstoasc output.mp4
```
所有MPEG格式(`MPEG-4 Part 10 / AVC`, `MPEG-4 Part 2`, `MPEG-2 Video`, `MPEG-1 Audio Layer II`, 
`MPEG-2 Audio Layer III (MP3)`, `MPEG-4 Part III (AAC)`).都可以转换成`MPEG-TS`.但是其中的一些参数需要改变，比如`-bsf`比特流过滤器需要改变

合并音频和视频
---

默认情况下，`ffmpeg`只会处理一个音频流和一个视频流，

先给命令：

```shell
ffmpeg -i input.mp4 -i input.mp3 -c copy -map 0:v:0 -map 1:a:0 output.mp4
```

相关解释：

- map 参数制指定了从哪一个输入流中映射到输出中。
- `0:v:0` 从第一个输出文件中取第一个视频流，`1:a:0`从第二个文件中取第一个音频流。 `v/a`参数不是必需的。
但是如果输入文件中包含多个流，这样有助于消除歧义。
- 如果你的音频流时长超过视频流，或者相反，你可以使用`-shortest`参数，使`ffmpeg`参数在处理到两个输入短的结束时结束。
- `-c copy` 复制音频流和视频流，这意味着进程会处理的更快，并且质量也与之前一样。但是在添加一个`wav`音频到视频中时，最好先
压缩一下音频。例如：
`ffmpeg -i input.mp4 -i input.wav -c:v copy -map 0:v:0 -map 1:a:0 -c:a aac -b:a 192k output.mp4`
命令中，我们复制了视频流，但是使用`ffmpeg`内置的`AAC`编码器重编码了音频，设置为了`192kBit/s`.

- 如果你的输出并不支持特定的编解码器， 例如(添加WAV到MP4，或者AAC到AVI中)重编码也是需要的。

我的解决方案
---

由于需要合并片段文件和相应的音频文件，首先会拆离视频文件中的音频文件， 并与另外的音频文件混合。可以使用`sox`或者`ffmpeg`。

然后在执行连接命令。

命令如下：

```shell
ffmpeg -hide_banner -f concat -i list.txt -i if.mp3 -c:v copy -c:a aac -strict -2 -map 0:v:0 -map 1:a:0  test.mp4
```


参考资料
===

- [Concatenating media files](https://trac.ffmpeg.org/wiki/Concatenate)
- [add-audio-to-video-using-ffmpeg](https://superuser.com/questions/590201/add-audio-to-video-using-ffmpeg)

