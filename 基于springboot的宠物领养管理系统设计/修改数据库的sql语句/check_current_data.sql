-- 检查当前数据库中的数据量
USE pet_adoption_db;

-- 检查各表的数据量
SELECT 
    'users' as table_name,
    COUNT(*) as count
FROM users
UNION ALL
SELECT 
    'pets' as table_name,
    COUNT(*) as count
FROM pets
UNION ALL
SELECT 
    'adoption_applications' as table_name,
    COUNT(*) as count
FROM adoption_applications
UNION ALL
SELECT 
    'pet_categories' as table_name,
    COUNT(*) as count
FROM pet_categories
UNION ALL
SELECT 
    'pet_breeds' as table_name,
    COUNT(*) as count
FROM pet_breeds;

-- 检查宠物状态分布
SELECT 
    'Pet Status Distribution' as chart_type,
    status as label,
    COUNT(*) as value
FROM pets 
GROUP BY status;

-- 检查宠物性别分布
SELECT 
    'Pet Gender Distribution' as chart_type,
    gender as label,
    COUNT(*) as value
FROM pets 
GROUP BY gender;

-- 检查用户角色分布
SELECT 
    'User Role Distribution' as chart_type,
    role as label,
    COUNT(*) as value
FROM users 
GROUP BY role;

-- 检查热门宠物品种
SELECT 
    'Popular Breeds' as chart_type,
    pb.breed_name as label,
    COUNT(p.pet_id) as value
FROM pet_breeds pb
LEFT JOIN pets p ON pb.breed_id = p.breed_id
GROUP BY pb.breed_id, pb.breed_name
ORDER BY value DESC
LIMIT 5;

-- 检查领养申请状态分布
SELECT 
    'Adoption Application Status' as chart_type,
    status as label,
    COUNT(*) as value
FROM adoption_applications 
GROUP BY status; 