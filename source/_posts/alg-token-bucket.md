---
title: 令牌桶算法浅析
date: 2019-04-09 17:01:40
categories:
- algorithm
- nginx
tags:
- algorithm
- nginx
keywords: token-bucket ratelimit
description: 令牌桶算法浅析
cover: https://i.loli.net/2020/03/04/ODnFgqjYuvVpk85.jpg
---

负责的项目中有一个爬虫调度项目。基础的模型就是利用平台提供的 `Token` 通过相关的数据 `API` 从平台获取数据。
对于每个 `Token` 均存在一个短时间内调用的上限。一旦超出限制，将在一段时间内不能进行继续获取。
之前对于这个限制的管理比较简单，当任务触发时，会直接发起数据获取请求。通过检查返回信息，判断是否超限，如果超限，设置一个等待时间之后进行重试。但发现这样没有最大化的利用到 `Token`. 因为发起请求本身就是对 `Token` 的一种消耗。
最近跟组长进行讨论相关细节时，他提到可以利用 `Nginx` 的流量限制来进行改进。研究之后发现`令牌桶算法`很合适这个需求。

## 令牌桶算法

#### 简介

令牌桶(`token bucket`)算法是 `nginx` 进行流量限制的一种常用算法。常用于控制发送到网络上的数据的数量，并允许突发数据的发送。

#### 基础流程图

当数据请求来临时，算法通过检查当前桶的令牌量，如果令牌量足以支持消耗，即会进行接下来的处理。
如果令牌不足，则会将请求抛弃(获取缓存，看相关需求)

![token-bucket.png](https://i.loli.net/2020/03/04/Z9O8tBPWe2cmgzK.png)

## 使用

在当前的需求中，对每一个 `Token` 实例添加一个容量桶。存储当前的可调用次数。当有 `worker` 发起请求时，先检查当前的可调用余量。
如果余量足够，则返回可调用状态，并设置当前的处理时间。当请求完毕时，对桶进行主动更新。如果当前余量不足以进行请求，则可以返回需要等待的时间，或者执行切换 `Token` 实例等操作。

#### 简单实现


``` python
import time


class TokenBucket:
    def __init__(self, rate=0.1, capacity=100):
        """
        此 为 单例
        初始化时 应设置 当前的容量为 总容量
        :param rate: 速率 秒为单位
        :param capacity: 总容量
        """
        self._rate = rate
        self._capacity = capacity
        self.current_amount = capacity
        self._last_consumed_at = int(time.time())

    def consume(self, need_amount=1):
        """
        进行消费
        :param need_amount:
        :return:
        """
        increments = (int(time.time()) - self._last_consumed_at) * self._rate
        self.current_amount = min(
            self.current_amount + increments, self._capacity
        )
        if need_amount > self.current_amount:
            return False
        self.current_amount = self.current_amount - need_amount
        self._last_consumed_at = int(time.time())
        return True

    def update(self, amount):
        """
        存在一个更新操作，用于 Token 余量状态主动返回
        并重新计算 最后消费时间
        :param amount: 主动发送的数量
        :return:
        """
        self.current_amount = min(amount, self._capacity)
        self._last_consumed_at = int(time.time())

```

源码可访问 [code](https://github.com/MerleLiuKun/my-python/blob/master/crawler/distributor/token_bucket.py)


## 参考资料

- [token bucket](https://en.wikipedia.org/wiki/Token_bucket)
- [令牌桶算法](https://baike.baidu.com/item/%E4%BB%A4%E7%89%8C%E6%A1%B6%E7%AE%97%E6%B3%95)
- [令牌桶实现](https://juejin.im/post/5ab10045518825557005db65)
