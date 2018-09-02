---
title: Python的虚拟环境
date: 2017-07-28 20:54:20
categories: Python
tags: python
---
**简述：**
===

**&#160;&#160;&#160;&#160;问题：**  
&#160;&#160;&#160;&#160;我们知道Python的魅力更在于它庞大的第三方库。所以在实际的开发环境中，可能会同时进行多个项目，也许就会出现一个项目是基于python2.x，而另一个项目是基于python3.x的尴尬情况，以及其他很多不方便的情况，比如无法自动生成requirements文件etc。。。。。
**&#160;&#160;&#160;&#160;Methods：**  
&#160;&#160;&#160;&#160;于是就有virtualenv这个插件很好的解决了这个问题。下面讲解它的基础使用。以及更为方便的一个插件virtualenvwrapper。

<!-- more -->

**使用virtualenv**
==

**&#160;&#160;&#160;&#160;安装**
---
  
&#160;&#160;&#160;&#160;virtualenv的安装十分简单，使用pip就能很方便的安装：
> sudo pip install virtualenv

**&#160;&#160;&#160;&#160;基础操作**
---
  
&#160;&#160;&#160;&#160;**1.创建虚拟环境**  
&#160;&#160;&#160;&#160;使用如下命令即可在**当前目录**下创建一个名为env1的虚拟环境
> virtualenv env1

&#160;&#160;&#160;&#160;还可以创建指定解释器版本的虚拟环境
> virtualenv -p python2.7 env2.7   #该环境下解释器为python2.7
> virtualenv -p python3.5 env3.5   #该环境下解释器为python3.5

&#160;&#160;&#160;&#160;如果你的系统里的python已经安装第三方库，你想直接继承过来使用，使用如下命令
> virtualenv --system-site-packages env

&#160;&#160;&#160;&#160;默认的是不加继承的，或者使用以下命令
> virtualenv --no-site-packages env

&#160;&#160;&#160;&#160;**2.启动和退出虚拟环境**  
&#160;&#160;&#160;&#160;启动，要想启动创建好的虚拟环境，需要到其安装目录(即当前目录下)，输入如下命令：
> source env1/bin/activate

当命令行头出现**(env1)**时就表示虚拟环境已经启动。此时我们再次使用pip、setools、easy_install等安装的插件就只会在此虚拟环境之下，不会影响系统内的默认环境、或者其他的虚拟环境。

&#160;&#160;&#160;&#160;退出，要想从当前虚拟环境之下退出，只需执行如下命令即可：
> deactivate

**使用virtualenvwrapper**
==

**&#160;&#160;&#160;&#160;virtualenv的出现使得项目间的环境使用更加方便和简洁，而virtualenvwrapper是一个基于virtualenv之上的一个工具，它提供了更加方便的虚拟环境管理方式。即统一管理。**

**&#160;&#160;&#160;&#160;安装**  
---

&#160;&#160;&#160;&#160;安装操作仍然十分简单，使用如下命令即可安装此工具：
>sudo pip install virtualenvwrapper

&#160;&#160;&#160;&#160;windows下安装
> pip install virtualenvwrapper-win

&#160;&#160;&#160;&#160;`virtualenvwrapper`默认将所有的虚拟环境放在`~/.virtualenvs`目录下管理，但是也可以修改环境变量`WORKON_HOME`来指定虚拟环境的保存目录。

**&#160;&#160;&#160;&#160;基本操作**
---

**&#160;&#160;&#160;&#160;1.启动**  
&#160;&#160;&#160;&#160;使用前需要在shell里执行：
> source /usr/local/bin/virtualenvwrapper.sh

为了方便使用这个命令，我们可以把如下命令加到shell的配置文件中：
> sudo vim ~/.profile
>   
> export `WORKON_HOME`=$HOME/.virtualenvs
> export `PROJECT_HOME`=$HOME/Devel
> source /usr/local/bin/virtualenvwrapper.sh

**&#160;&#160;&#160;&#160;2.相关命令**  
&#160;&#160;&#160;&#160;列出已有的虚拟环境，命令如下：
> workon

&#160;&#160;&#160;&#160;创建新的虚拟环境，创建完毕之后会自动切换到当前环境，命令如下：
> mkvirtualenv env1

&#160;&#160;&#160;&#160;列出当前环境下中所安装的包，命令如下：
> lssitepackages

&#160;&#160;&#160;&#160;切换虚拟环境，命令如下：
> workon env2

&#160;&#160;&#160;&#160;退出当前环境，命令如下：
> deactivate

&#160;&#160;&#160;&#160;删除虚拟环境，如果该环境正在使用，那么必须先退出该环境，命令如下：
> rmvirtualenv env1

&#160;&#160;&#160;&#160;显示指定环境的详情，命令如下：
> showvirtualenv env1

&#160;&#160;&#160;&#160;把指定的目录加入当前使用的环境path中，命令如下：
> add2virtualenv dir dir

&#160;&#160;&#160;&#160;复制一份虚拟环境
> cpvirtualenv source dest

&#160;&#160;&#160;&#160;还可以在上面我们配置过的目录`PROJECT_HOME`下创建一个新项目。
> mkproject project_name

OK，以上就是关于virtualenv和增强工具virtualenvwrapper的简单使用介绍。另外说一点，在windows上使用时会出现一些命令使用的问题，好好搜索哦，本文是基于linux上使用的....呼呼，欢迎大家指正哦。
