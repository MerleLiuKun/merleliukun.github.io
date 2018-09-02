#!/usr/bin/env bash

# follow by xp-code's script. https://github.com/xp-code/blog-repo/blob/master/init_env.sh

#   function :
#        init hexo env
#    require :
#        node git
#    usage :
#            1. sh init_env.sh


npm install -g hexo-cli

# publish for git
npm install hexo-deployer-git --save


#自动为站外链接添加nofollow属性
npm install hexo-autonofollow --save

#用于生成静态站点数据，提供搜索功能的数据源。
npm install hexo-generator-json-content --save

#为文章添加文章字数统计、文章预计阅读时间
#通过以上安装后，你可以在你的模板文件加入以下相关的标签实现本插件的功能
#**字数统计:**WordCount
#**阅读时长预计:**Min2Read
#总字数统计: TotalCount
npm install hexo-wordcount --save
#RESTful JSON数据生成插件。
npm install hexo-generator-restful --save
npm install hexo-renderer-marked --save
npm install hexo-renderer-stylus --save

## rss插件
npm install hexo-generator-feed --save
## 站点sitemap生成插件
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
## 本地搜索插件集成
npm install hexo-generator-search --save
