### 使用说明:

#### 1. 先安装docker和docker-compose

#### 2. 拉取代码

  ```
  git clone https://github.com/radiocontroller/live_crawler.git
  cd live_crawler
  ```

#### 3. 进行构建镜像并启动容器

  ```
  ./build.sh
  ```

#### 4. 数据是每2分钟抓取的（crontab配置）, 如果打开没数据请等一会

  ```
  访问地址：http://localhost:3000/
  ```

####    5. 进入容器

  ```
  ./enter.sh
  ```
