# 宠物领养管理系统（pet-adoption-system）



## 本地快捷预览项目



第一步：运行 sql 文件夹下的`pet_adoption_db.sql`，创建`pet_adoption_db`数据库

第二步：双击 run 文件夹下的`start.cmd`，弹出的dos窗口不要关闭

第三步：浏览器访问`http://localhost:8080/users/tologin`，测试账号为admin,密码为：admin，

用户的账号：1234566，

密码为：123456

## 主要技术



SpringBoot、Mybatis、MySQL、Bootstrap等

## 主要功能



管理员模块：注册、登录、宠物管理、用户管理、领养申请、分类管理、品种管理、评论管理、标签管理、数据分析、收藏管理

读者模块：注册、登录、宠物管理、领养申请、评论管理、数据分析、收藏管理

## 主要功能截图



### 登录



登录支持两种用户角色：管理员和用户

输入正确的账号、密码后，系统会自动识别管理员或者用户，并跳转到相应主页。

![login](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\login.png)

### 展示板页面

![yibiaopan](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\yibiaopan.png)

### 管理员界面



#### 宠物管理



- 宠物列表

  ![petlist](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\petlist.png)

- 添加宠物

  ![tianjiacongwu](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\tianjiacongwu.png)

- 编辑宠物

  ![banjicongwu](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\banjicongwu.png)

- 删除宠物

  ![shanchuchongwu](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\shanchuchongwu.png)

#### 用户管理



- 用户管理的增删查改类似宠物管理，不再赘述

  ![user](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user.png)



#### 宠物领养管理

- 领养记录查询，以及领养的通过与否

  ![adoptionlist](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\adoptionlist.png)

- 领养申请详情

  ![shenqing](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\shenqing.png)

  

  

  #### 分类管理

  ![fenlei](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\fenlei.png)

  #### 品种管理

  ![pingzhong](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\pingzhong.png)

  #### 评论管理

  ![pinlun](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\pinlun.png)

  #### 标签管理

  ![biaoqian](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\biaoqian.png)

  #### 数据分析

  ![shujufenxi](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\shujufenxi.png)

  #### 收藏管理

  ![shouchang](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\shouchang.png)



### 读者界面

#### 宠物列表

![chongwu](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user\chongwu.png)

#### 领养申请

![lingyang](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user\lingyang.png)



#### 评论管理

![pinglun](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user\pinglun.png)

#### 数据分析

![shujufenxi](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user\shujufenxi.png)

#### 收藏管理

#### ![shoucang](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\user\shoucang.png)





## 代码结构



### 前端



```
frontend/
├─index.html          // 主页面
├─test-api.html       // API测试页面
├─js/                 // JavaScript文件
│  ├─app.js          // 主应用逻辑
│  └─api.js          // API接口调用
└─css/                // 样式文件
   └─style.css       // 主样式文件
```



![qianduan](D:\springboot\springboot\基于springboot的宠物领养管理系统设计\src\main\images\qianduan.png)

### 后端



maven项目结构

```
src/main/java/com/example/petadoption/
├─PetAdoptionApplication.java  // 主启动类
├─controller/                  // 控制层
├─service/                     // 业务层
├─mapper/                      // MyBatis映射层
├─repository/                  // JPA仓库层
├─entity/                      // 实体类
├─model/                       // 数据模型
├─config/                      // 配置类
└─util/                        // 工具类
└─resources	// maven资源配置
```

![houduan](https://raw.githubusercontent.com/yunluoyan-li/springboot/refs/heads/main/%E5%9F%BA%E4%BA%8Espringboot%E7%9A%84%E5%AE%A0%E7%89%A9%E9%A2%86%E5%85%BB%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F%E8%AE%BE%E8%AE%A1/src/main/images/houduan.png)



## 数据库



**使用Navicat生成ER模型图**

![E-R](https://github.com/yunluoyan-li/springboot/blob/main/%E5%9F%BA%E4%BA%8Espringboot%E7%9A%84%E5%AE%A0%E7%89%A9%E9%A2%86%E5%85%BB%E7%AE%A1%E7%90%86%E7%B3%BB%E7%BB%9F%E8%AE%BE%E8%AE%A1/src/main/images/E-R.png?raw=true)













