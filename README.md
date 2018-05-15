docker分支是docker版本, master分支是非docker版本

### 使用说明:
1. 先安装docker和docker-compose

2. 拉取代码

  ```
  git clone git@github.com:radiocontroller/crawler_with_sinatra.git
  ```

3. 进行构建镜像并运行镜像

  ```
  ./build.sh
  ```

4. 输入主机外网IP + 82端口号进行访问, 数据是每分钟抓取的, 如果打开没数据请等一会
  
  ```
  http://123.206.177.20:82/
  ```
