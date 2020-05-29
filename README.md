# 项目会每天定时自动抓取 github、gitee （后续还会添加）部署的静态网页，并展示

## 技术

* Shell
  * 需要从 gitee.io、github.io 解析出绑定的所有 ip
  * 再使用 ip 反向查域名，可以得到部署在 gitee 和 github 上的静态网站域名
  * 对域名进行筛选
  * 形成展示页面 index.html
* Github Action
  * 定时运行
  * 手动触发运行
  * 使用 ssh 私钥提交同步到 github、gitee 远程仓库
* html/css
  * 垃圾代码，随便玩玩......

## 主要是为了学习 Github Action 而临时起意的 Demo，想想可以自己更新内容，感觉还不错。
