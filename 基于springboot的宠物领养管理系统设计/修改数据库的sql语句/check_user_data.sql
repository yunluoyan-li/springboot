-- 检查用户数据
USE pet_adoption_db;

-- 检查所有用户
SELECT 
    user_id,
    username,
    email,
    role,
    status,
    created_at
FROM users
ORDER BY user_id;

-- 检查是否有用户名为123456的用户
SELECT 
    user_id,
    username,
    email,
    role,
    status,
    created_at
FROM users
WHERE username = '123456';

-- 检查管理员用户
SELECT 
    user_id,
    username,
    email,
    role,
    status,
    created_at
FROM users
WHERE role = 'ADMIN';

-- 检查用户总数
SELECT COUNT(*) as total_users FROM users;

-- 检查用户角色分布
SELECT 
    role,
    COUNT(*) as count
FROM users
GROUP BY role; 