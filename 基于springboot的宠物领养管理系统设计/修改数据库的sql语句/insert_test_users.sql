-- 插入测试用户数据
USE pet_adoption_db;

-- 检查是否已存在测试用户
SELECT * FROM users WHERE username IN ('admin', '123456', 'testuser');

-- 插入管理员用户 (密码: 123456)
INSERT INTO users (username, password, email, role, status, created_at, updated_at) 
VALUES ('admin', MD5('123456'), 'admin@example.com', 'ADMIN', 'ACTIVE', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 插入普通用户 (密码: 123456)
INSERT INTO users (username, password, email, role, status, created_at, updated_at) 
VALUES ('123456', MD5('123456'), 'user123456@example.com', 'USER', 'ACTIVE', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 插入测试用户 (密码: 123456)
INSERT INTO users (username, password, email, role, status, created_at, updated_at) 
VALUES ('testuser', MD5('123456'), 'test@example.com', 'USER', 'ACTIVE', NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- 验证插入结果
SELECT 
    user_id,
    username,
    email,
    role,
    status,
    created_at
FROM users
WHERE username IN ('admin', '123456', 'testuser')
ORDER BY username; 