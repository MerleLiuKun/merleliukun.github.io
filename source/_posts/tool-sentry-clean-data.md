---
title: Sentry-数据清理
date: 2020-10-09 16:31:55
categories: 
- DevOps
tags:
- DevOps
- Docker
keywords: sentry
---

之前部署了一个 [Sentry](https://sentry.io/welcome/) 的服务，经过一段时间运行后，产生了很多的数据记录需要进行清理。


步骤如下
======

标记数据删除
-----------

可以使用 sentry 提供的 cleanup 命令执行数据清除。

```
root@2f6578540024:/usr/src/sentry# sentry cleanup --help
Usage: sentry cleanup [OPTIONS]

  Delete a portion of trailing data based on creation date.

  All data that is older than `--days` will be deleted.  The default for this is 30 days.  In
  the default setting all projects will be truncated but if you have a specific project you want
  to limit this to this can be done with the `--project` flag which accepts a project ID or a
  string with the form `org/project` where both are slugs.

Options:
  --days INTEGER                  Numbers of days to truncate on.  [default: 30]
  --project TEXT                  Limit truncation to only entries from project.
  --concurrency INTEGER           The total number of concurrent worker processes to run.
                                  [default: 1]
  -q, --silent                    Run quietly. No output on success.
  -m, --model TEXT
  -r, --router TEXT               Database router
  -t, --timed                     Send the duration of this command to internal metrics.
  -l, --loglevel [DEBUG|INFO|WARNING|ERROR|CRITICAL|FATAL]
                                  Global logging level. Use wisely.
  --logformat [human|machine]     Log line format.
  --help                          Show this message and exit.
```

清除 30 天前的数据

```
sentry cleanup --days 30
```

`sentry cleanup` 脚本使用 `delete` 命令将 `PG` 数据库里的数据进行清理，实则仍然占据磁盘空间。


清理删除的数据
-------------

使用命令 `vacuumdb` 将数据进行删除。

```
vacuumdb -U postgres -d postgres -v -f --analyze
```

设为定时任务
-----------

可以使用 `crontab` 设置一个定时任务, 每月1号清理超过30天的数据

```
1 0 1 * *  docker exec -it onpremise_worker_1 sentry cleanup --days 30  && docker exec -it onpremise_postgres_1 vacuumdb -U postgres -d postgres -v -f --analyze
```


