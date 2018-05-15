docker分支是docker版本, master分支是非docker版本

### 使用说明:
1. 拉取代码

  ```
  git clone https://github.com/radiocontroller/crawler_with_sinatra.git
  ```

2. 安装gem

  ```
  bundle install
  ```

3. 配置爬虫定时任务, 文件是config/schedule.rb, 现在每分钟执行

  ```
  whenever --update-crontab
  ```

4. 启动服务, rerun可以在你修改之后重新加载文件而不用重启

  ```
  rerun 'thin start -e production'
  ```

5. 本地访问, 第一次运行如果没数据请等一会, 数据还在爬取

  ```
  http://localhost:3000
  ```
