# API路径修复说明

## 问题描述
用户报告登录时出现404错误，请求路径为 `/users/login`，但实际API路径应该是 `/api/users/login`。

## 问题分析

### 1. 路径不匹配
- 前端API调用使用的是 `/users/login`
- 后端API控制器映射到 `/api/users/login`
- 导致404错误

### 2. 前端API配置错误
在 `frontend/js/api.js` 中，所有API调用都缺少 `/api` 前缀。

## 修复方案

### 1. 修复前端API路径
将所有API调用路径添加 `/api` 前缀：

#### 用户相关API
```javascript
// 修复前
login: async (username, password) => {
    return apiRequest('/users/login', {
        method: 'POST',
        body: JSON.stringify({ username, password })
    });
}

// 修复后
login: async (username, password) => {
    return apiRequest('/api/users/login', {
        method: 'POST',
        body: JSON.stringify({ username, password })
    });
}
```

#### 宠物相关API
```javascript
// 修复前
getPets: async (params = {}) => {
    const queryString = new URLSearchParams(params).toString();
    return apiRequest(`/pets?${queryString}`);
}

// 修复后
getPets: async (params = {}) => {
    const queryString = new URLSearchParams(params).toString();
    return apiRequest(`/api/pets?${queryString}`);
}
```

#### 领养申请相关API
```javascript
// 修复前
getAllApplications: async () => {
    return apiRequest('/adoption/applications');
}

// 修复后
getAllApplications: async () => {
    return apiRequest('/api/adoption/applications');
}
```

### 2. 创建测试工具

#### 测试页面
创建了 `test_login_api.html` 用于测试登录API：
- 简单的登录表单
- 详细的错误信息显示
- 控制台日志输出

#### 数据库脚本
创建了 `insert_test_users.sql` 用于插入测试用户：
- admin/123456 (管理员)
- 123456/123456 (普通用户)
- testuser/123456 (测试用户)

## 修复后的API路径

### 用户管理API
- `POST /api/users/login` - 用户登录
- `POST /api/users/register` - 用户注册
- `POST /api/users/logout` - 用户登出
- `GET /api/users/current` - 获取当前用户
- `GET /api/users` - 获取所有用户（管理员）
- `PUT /api/users/{id}` - 更新用户信息
- `DELETE /api/users/{id}` - 删除用户（管理员）

### 宠物管理API
- `GET /api/pets` - 获取宠物列表
- `GET /api/pets/{id}` - 获取宠物详情
- `POST /api/pets` - 创建宠物
- `PUT /api/pets/{id}` - 更新宠物
- `DELETE /api/pets/{id}` - 删除宠物
- `GET /api/pets/stats` - 获取宠物统计
- `GET /api/pets/breeds` - 获取宠物品种

### 领养申请API
- `GET /api/adoption/applications` - 获取所有申请
- `GET /api/adoption/my-applications` - 获取我的申请
- `GET /api/adoption/check-application/{petId}` - 检查是否已申请
- `POST /api/adoption/apply` - 提交申请
- `GET /api/adoption/application/{id}` - 获取申请详情
- `POST /api/adoption/approve/{id}` - 审批通过
- `POST /api/adoption/reject/{id}` - 审批拒绝
- `DELETE /api/adoption/application/{id}` - 删除申请
- `GET /api/adoption/stats` - 获取申请统计

## 测试步骤

### 1. 启动应用
```bash
mvn spring-boot:run
```

### 2. 插入测试数据
执行 `insert_test_users.sql` 脚本插入测试用户。

### 3. 测试登录
访问 `http://localhost:8080/test_login_api.html` 进行登录测试。

### 4. 测试用户
- 用户名: `admin`, 密码: `123456` (管理员)
- 用户名: `123456`, 密码: `123456` (普通用户)
- 用户名: `testuser`, 密码: `123456` (测试用户)

## 验证方法

### 1. 浏览器开发者工具
- 打开Network标签页
- 查看API请求的URL和响应
- 检查控制台日志

### 2. 后端日志
查看Spring Boot应用日志，确认：
- API请求是否正确路由
- 参数绑定是否成功
- 业务逻辑是否正常执行

### 3. 数据库验证
执行SQL查询验证用户数据：
```sql
SELECT * FROM users WHERE username IN ('admin', '123456', 'testuser');
```

## 注意事项

1. **路径一致性**：确保前端和后端的API路径完全一致
2. **CORS配置**：确保CORS配置允许API路径
3. **Session管理**：API使用session进行用户认证
4. **错误处理**：所有API都包含完整的错误处理

## 后续优化

1. **API文档**：添加Swagger文档
2. **统一配置**：使用配置文件管理API路径
3. **版本控制**：考虑API版本化
4. **监控日志**：添加API调用监控 