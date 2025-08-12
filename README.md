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

![8f24579b38384acc7ae8ab04844e5b13](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\8f24579b38384acc7ae8ab04844e5b13.png)

### 展示板页面

![551496e0bcccb6cc8c71773034ac1cb4](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\551496e0bcccb6cc8c71773034ac1cb4.png)

### 管理员界面



#### 宠物管理



- 宠物列表

  ![5a4e9ab7944ae2d31fed20da2814c5df](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\5a4e9ab7944ae2d31fed20da2814c5df.png)

- 添加宠物

  ![363555b32db0f43ea885793628dba5d3](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\363555b32db0f43ea885793628dba5d3.png)

- 编辑图书

  ![bb3d787dbe015bd55b90dfa875a0bfd4](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\bb3d787dbe015bd55b90dfa875a0bfd4.png)

- 删除图书

  ![43d1a2d6b44a336162d41e7d5252ae84](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\43d1a2d6b44a336162d41e7d5252ae84.png)

#### 用户管理



- 用户管理的增删查改类似宠物管理，不再赘述

  ![f067f731c6276eed9b942ec6604d0eb0](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\f067f731c6276eed9b942ec6604d0eb0.png)



#### 宠物领养管理

- 领养记录查询，以及领养的通过与否

  ![82ec2f37f02728d93a12b1deee576258](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\82ec2f37f02728d93a12b1deee576258.png)

- 领养申请详情

  ![4be18b52b82d13581ec7b0979f68d55a](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\4be18b52b82d13581ec7b0979f68d55a.png)

  

  

  #### 分类管理

  ![ed43ac2deb78351253bdfa5e14f4580e](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\ed43ac2deb78351253bdfa5e14f4580e.png)

  #### 品种管理

  ![ea222e410323a91e68e467d01338b0cb](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\ea222e410323a91e68e467d01338b0cb.png)

  #### 评论管理

  ![cba1746486fdfd7a78255bba4b7d40df](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\cba1746486fdfd7a78255bba4b7d40df.png)

  #### 标签管理

  ![b9f472f133b326299142d6ae78826a10](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\b9f472f133b326299142d6ae78826a10.png)

  #### 数据分析

  ![f23b88ed1d366ed19d1d4ed3c35a3121](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\f23b88ed1d366ed19d1d4ed3c35a3121.png)

  #### 收藏管理

  ![eb04032b2cf4052c07191a0a691290b7](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\eb04032b2cf4052c07191a0a691290b7.png)



### 读者界面

#### 宠物列表

![c0c5191c5abb73e1c793a30d9ec9f175](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\c0c5191c5abb73e1c793a30d9ec9f175.png)

#### 领养申请

![6f960a8d9118582602cc24ec21c4569d](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\6f960a8d9118582602cc24ec21c4569d.png)



#### 评论管理

![281427ccae41ca6074f2453b58600827](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\281427ccae41ca6074f2453b58600827.png)

#### 数据分析

![55090a9569f82921d44782c393bc47c0](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\55090a9569f82921d44782c393bc47c0.png)

#### 收藏管理

#### ![image-20250812212705780](C:\Users\lh168\AppData\Roaming\Typora\typora-user-images\image-20250812212705780.png)





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



![f725276b072362c75a93e70e5bf484fa](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\f725276b072362c75a93e70e5bf484fa.png)

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

![a40fb71a239b7245450ea6ce0e050b70](C:\Users\lh168\Documents\Tencent Files\2774467877\nt_qq\nt_data\Pic\2025-08\Ori\a40fb71a239b7245450ea6ce0e050b70.png)



## 数据库



**使用Navicat生成ER模型图**

![QQ_1755005508477](C:\Users\lh168\AppData\Local\Temp\QQ_1755005508477.png)
