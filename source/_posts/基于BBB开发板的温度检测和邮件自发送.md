---
title: 基于BBB开发板的温度检测和邮件自发送
date: 2017-08-06 23:20:41
categories: 嵌入式
tags: 嵌入式
---


背景
===  
机房里的空调是不能关闭的，但不可避免出现各种问题。于是想通过检测室内的温度，达到某一界限时来向管理员发送通知邮件。  

所用介质
===

> 1.BeagleBoneBlack开发板  
>
> 2.温度传感器18b20  
>
> 3.qq邮箱

<!-- more -->

搭建过程
===

连接开发板
---

以数据线连接电脑USB到开发板的USB上，开机

配置BBB开发板（将温度传感器注册到开发板上）
---
此处的教程源自[One-wire DS1820 thermometer with BeagleBone Black & libmicrohttpd](http://mkaczanowski.com/one-wire-ds1820-thermometer-with-beaglebone-black-libmicrohttpd/)

1.加载驱动文件（自己理解的）
在开发板root目录下新建一个18b20的文件夹
编辑BB-W1-00A0.dts文件
          
```dtd
/dts-v1/;
/plugin/;

/ {
	compatible = "ti,beaglebone", "ti,beaglebone-black";
	part-number = "BB-W1";
	version = "00A0";

	/* state the resources this cape uses */
	exclusive-use =
    	/* the pin header uses */
    	"P9.22",
    	/* the hardware IP uses */
    	"gpio0_2";

	fragment@0 {
           		target = <&am33xx_pinmux>;
           		__overlay__ {
                	dallas_w1_pins:pinmux_dallas_w1_pins {
                    	pinctrl-single,pins = < 0x150 0x37 >;
                	};
           		};
	};

	fragment@1 {
           		target = <&ocp>;
           		__overlay__ {
           		onewire@0 {
               		compatible      = "w1-gpio";
               		pinctrl-names   = "default";
               		pinctrl-0       = <&dallas_w1_pins>;
               		status          = "okay";

               		gpios = <&gpio1 2 0>;
           		};
     		};
	};
};
```

2.编译dts文件

键入命令：

```bash
dtc -O dtb -o BB-W1-00A0.dtbo -b 0 -@ BB-W1-00A0.dts
```

3.加入到配置文件中

```bash
cp BB-W1-00A0.dtbo /lib/firmware/
echo BB-W1:00A0 > /sys/devices/bone_capemgr.9/slots
```

此时你可以验证是否写入成功

```bash
cat /sys/bus/w1/devices/DEVICE_ID/w1_slave
```

编写源代码文件
---

```python
# -*- coding:utf-8 -*-
import Adafruit_BBIO.GPIO as GPIO  # 导入相关库文件
import time
from sendMail import *

GPIO.setup("P9_14", GPIO.OUT)
flag=0
def read_temp_raw():
	f = open("/sys/bus/w1/devices/28-04146829edff/w1_slave")
    lines = f.read()
	f.close()
    return lines

def read_temp():
	lines = read_temp_raw()
    secondline = lines.split("\n")[1]
	temperaturedata = secondline.split(" ")[9]
    temperature = float(temperaturedata[2:])
    temperature = temperature / 1000
	return temperature

# 以一个死循环让程序持续运行，检测温度值，并发送警告邮件
while True:
    time.sleep(1)   # 每个一秒获得一次温度值
    print(read_temp())   
	if (read_temp() > 30) & (flag==0):   #当 温度大于30度，并且是
	    send(read_temp())
    	print "hello"
    	flag = flag+1
	    # GPIO.output("P9_14", GPIO.HIGH)
	elif (read_temp() < 30) :
	    flag= 0
```

配置邮件自动发送
---

源码如下
     
```bash
# -*- coding: UTF-8 -*-
import sys, os, re, urllib, urlparse
import smtplib
import traceback
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def sendmail(subject,msg,toaddrs,fromaddr,smtpaddr,password):
	mail_msg = MIMEMultipart()
	if not isinstance(subject,unicode):
        subject = unicode(subject, 'utf-8')
	mail_msg['Subject'] = subject
    mail_msg['From'] = 'your@qq.com'   #此处最好填入邮箱地址，否则会被拦截
    mail_msg['To'] = ','.join(toaddrs)
    mail_msg.attach(MIMEText(msg, 'html', 'utf-8'))
    try:
	    s = smtplib.SMTP()
	    s.connect(smtpaddr)  #连接smtp服务器
	    s.ehlo()
	    s.starttls()
	    s.login(fromaddr,password)  #登录邮箱
	    s.sendmail(fromaddr, toaddrs, mail_msg.as_string()) #发送邮件
	    s.quit()
    except Exception,e:
	   print "Error: unable to send email"
	   print traceback.format_exc()

def  send(read_temp):
	fromaddr = "your@qq.com"
    smtpaddr = "smtp.qq.com"
    toaddrs = ["others@qq.com"]
	subject = "老师，请注意"
 	password = "your password"
	msg = "你好，老师！当前温度已经达到"+ str(read_temp) +"度"
	sendmail(subject,msg,toaddrs,fromaddr,smtpaddr,password)
```


上述代码中的`stmp`的`starttls`方法，有参考 [python-smtplib](https://www.lylinux.org/python-smtplib%E5%92%8Cemail%E6%A8%A1%E5%9D%97.html).

到此时基本配置已经完成。

在这里的自发送代码十分简单，想要达到自己的需求还需要加以更改。


