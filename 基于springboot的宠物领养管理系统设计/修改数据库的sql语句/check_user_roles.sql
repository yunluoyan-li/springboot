-- 检查用户角色
USE pet_adoption_db;

-- 查看所有用户的角色
SELECT 
    user_id,
    username,
    email,
    role,
    status,
    created_at
FROM users
ORDER BY user_id;

-- 检查角色分布
SELECT 
    role,
    COUNT(*) as count
FROM users
GROUP BY role;

-- 检查特定用户的角色
SELECT 
    user_id,
    username,
    role,
    status
FROM users
WHERE username IN ('admin', '123456')
ORDER BY username;

-- 更新用户角色（如果需要）
-- 将admin用户设置为ADMIN角色
UPDATE users 
SET role = 'ADMIN' 
WHERE username = 'admin';

-- 将123456用户设置为USER角色
UPDATE users 
SET role = 'USER' 
WHERE username = '123456';

-- 验证更新结果
SELECT 
    user_id,
    username,
    role,
    status
FROM users
WHERE username IN ('admin', '123456')
ORDER BY username; 