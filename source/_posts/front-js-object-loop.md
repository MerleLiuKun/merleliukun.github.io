---
title: JavaScript 遍历对象的方法
date: 2017-07-26 23:48:57
categories:
- JavaScript
tags:
- JavaScript
- object
keywords: JavaScript
description: JavaScript 遍历对象的方法
copyright: false
---

有关对象遍历的几个方法
====================

所有继承到`Object`的对象都会继承到`hasOwnProerty()`方法，此方法用来检测一个对象是否包含特定的自身属性，其与`in`运算符不同之处在于，`hasOwnProperty`方法会忽略掉那些从原型链上继承到的属性。

1.一个简单的例子： 检测对象obj是否含有自身属性'prop'.

``` js
obj = new Object();
obj.prop = 'exists';

function changeO(){  // 将prop属性删除。
    obj.newprop = obj.prop;
    delete obj.prop;
}

alert(obj.hasOwnProperty('prop'));  // True
changeO();
alert(obj.hasOwnProperty('prop'));  // False
```

对于从原型链上继承的属性，`hasOwnProperty`方法会将其忽略。而`in`操作符则是将原型链上的属性也涵盖。

``` js
alert(obj.hasOwnProperty('toString'));  // False
alert('toString' in obj);   // True
```

2.遍历一个对象所有的自身属性。忽略掉继承属性。

``` js
var buz = {
    fog: 'stack',
    name: 'hello'
};

for (var name in buz) {
    if (buz.hasOwnProperty(name)) {
        alert("this is fog (" + name + ") for sure. Value: " + buz[name]);
    }
    else {
        alert(name); // toString or something else
    }
}
```

注意： 此例子中`for...in`循环只会遍历可枚举的属性。

3.处理json对象转为字符串。

我们需要遍历一个json对象

``` js
var s = '{"data":[{"d1": "c1", "d2": "c2"}]}';

var parsedData = JSON.parse(s);

for(var i in parserd_data){
    for(var j in parserd_data[i]){
        alert(parserd_data[i][j]);
        console.log(parserd_data[i][j]);
        for (var k in parserd_data[i][j]){
            alert(parserd_data[i][j][k]);
        }
    }
}
```

这种方法有些费劲，所以可以定义一个函数进行遍历,虽然函数很长，但是对基本的情况也进行了校验，没有使用那么多的嵌套循环。

``` js 
function JsonToStr(data){
    var resultStr = "";
    
    for (var i in data){
        if (data.hasOwnProperty(i)){
            if (typeof(data[i]) === "object"){
                JsonToStr(data[i]);
            }
            else{
                if(resultStr === ""){
                    resultStr = i + "," + data[i];
                }
                else{
                    resultStr = resultStr + "," + i + "," + data[i];
                }
            }
        }
    }
    return resultStr;	
}
```	

参考资料
=======

- [MDN web docs](https://developer.mozilla.org/zh-CN/)
