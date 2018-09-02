---
title: FlaskAdmin相关用法
date: 2017-08-13 23:07:37
categories: Flask
tags: flask
---

背景
===
之前项目开发的时间不是十分充裕，对项目中管理员身份用户的部分业务直接使用了FlaskAdmin插件进行开发。
由于当初没有针对FlaskAdmin做相关设计，导致后期测试时，大部分Bug出现在这一模块。于是，就加深以下对FlaskAdmin插件的一些额外的使用方法。

<!--more-->

部分用法介绍
===

基础模型
---
FlaskAdmin的的视图模型是直接与对应的数据库表同步的。与数据库模型对应关系建立十分简单。如果我们使用FlaskAdmin默认的视图模型。直接如下即可建立一个简单的页面。

``` python		
from flask import Flask
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView
from webapp.models import db, User
app = Flask(__name__)
app.config....  # app.相关配置，DB等
admin = Admin(app)
admin.add_view(ModelView(User, db.session))
```

此时生成的界面如下：

![初始界面](http://upload-images.jianshu.io/upload_images/1747527-529b5d1eb72a86b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

模型进阶
---

我们从上边的图可以看到：

1. 全是英文显示，对用户有很大困扰。
2. 所有的数据列都显示了，有的数据列可能不是我们需要的。
3. 在每列左边的操作区，可以修改，删除等操作，我们可能只需要让用户保留一部分功能。如:只能修改。

为了自定义对应模型的界面，我们可以自定义相关的信息。所以我们自定义一个类并继承ModelView，就可以实现相关的操作。
首先我们给出修改后的界面。

![基本页面.png](http://upload-images.jianshu.io/upload_images/1747527-f8182ea7d1a330f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1.首先我们中文问题，我们使用了Flask的插件`Flask-Bable`和`Flask-BabelEx`，在配置中我们可以使用如下语句：

``` python
BABEL_DEFAULT_LOCALE = 'zh_CN'
```

然后就解决了界面上大部分的中文，但是表头不是中文。所以我们还要在FlaskAdmin中进行表头的配置。

``` python
column_labels = {
	'id': u'用户ID',
	'username': u'用户名',
	'password': u'密码',
	'name': u'姓名',
	'grade': u'年级',
	'emp_no': u'工号'
}
```

这样就完成了中文的翻译。

2.介绍FlaskAdmin的一些配置:

``` python
page_size= 10       # 每页显示几条
can_create=True     # 可以创建数据  False 
can_delete=True     # 可以删除数据  False
can_edit=True       # 可以编辑数据  False
can_view_details=True  # 可以查看详情  False

column_searchable_list=['列名']  # 可以搜索的列名
form_exclude_columns=['列名']    # 不显示的列
```

高级功能
---

1.我们在对Admin进行操作时，对于某些字段我们需要进行限制，比如字段校验，进行一些特殊的限制等。

这里我们可以用自定义的校验器。我们以一个例子展示。

我们需要让用户无法修改`admin`用户的数据。

在用户表的视图下：

``` python
# 自定义的校验器
def user_validator(form, field):
	if form._obj is not None:
		user_id = form._obj.id
		# 调用user表的方法，通过用户名得到用户信息
		user = User.get_user_info(user_id=user_id)
		if user.username == 'admin':
			if field.data != 'admin':
				raise ValidationError(u"admin为最高权限用户，不允许修改")

# FlaskAdmin的属性  form_args
form_args = {
	"username":{
		'label': u'用户',
		'validators': [DataRequired(), user_validator]
	}}
```

这样，我们就完成了对用户名为'admin'的用户无法修改的限制。
在程序里，校验器的form属性中的_obj可以获取原始数据库中的数据，而不是当前form的数据。这样就避免了用户直接修改用户名。

2.对于基础的限制，我们还可以继承ModelView中的on\_model\_change()方法。

> on\_model\_change()是在一个模型创建之前或者修改更新之前进行的操作，所以也可以加一些相关的限制。
> 参数有：  
> form： 将要更新或者创建模型的Form表单  
> model： 即将被创建或者更新的模型  
> is_created： 是不是新建的模型。  True/ False

我们同样给出一个示例：

``` python
def on_model_change(self, form, model, is_created):
	if 'user' not in [role.role_name for role in model.roles]:
		raise ValidationError(u'user角色是必须的。')
```

上边一个简单的例子，完成了在创建新的用户时，必须给用户加上一个`user`的角色的功能。  
图如下：
![无user角色报错](http://upload-images.jianshu.io/upload_images/1747527-af80ba8bb350c743.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


3.同样类似的方法还有`after_model_change`、`on_model_delete`、`after_model_delete`等方法。具体的使用方法我们可以在FlaskAdmin的[API](http://flask-admin.readthedocs.io/en/latest/api/mod_contrib_sqla/)上找到相关介绍。


其他操作
---

1.修改FlaskAdmin主页面

默认的主页面是空白的，当然不好看，我们可以在初始化admin的时候自定义主页。如下：

``` python
admin = Admin(index_view=AdminIndexView(
	name==u'数据管理',
	template='MyAdmin/welcome.html',
	url='/admin',
), template_mode='bootstrap3')
```

其中template对应的html文件是我们自己写的。
可以继承来自Admin的源码中的template进行改写。

现在的首页如下：

![修改后的首页](http://upload-images.jianshu.io/upload_images/1747527-1335361c6ac8ca59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2.结合权限管理。

对于Admin的界面，我们需要对访问其的权限进行限制，我们可以结合Flask的另外一个插件`Flask-Login`进行实现。

在我们自定义的ModeView中。

定义方法`is_accessible()`

如下：

``` python
def is_accessible(self):
    if current_user.is_authenticated and current_user.username == "admin":
        return True
    return False
```

这样的话如果用户没有登录，且不属于'admin'用户的话，就不会进入到该视图模型下面。

