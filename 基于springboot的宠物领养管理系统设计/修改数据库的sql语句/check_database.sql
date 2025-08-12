-- 数据库状态检查脚本
-- 用于诊断数据分析功能的问题

USE pet_adoption_db;

-- 1. 检查表是否存在
SELECT 'Checking table existence...' as message;
SHOW TABLES;

-- 2. 检查各表的数据量
SELECT 'Checking data counts...' as message;
SELECT 'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'pets' as table_name, COUNT(*) as count FROM pets
UNION ALL
SELECT 'adoption_applications' as table_name, COUNT(*) as count FROM adoption_applications
UNION ALL
SELECT 'pet_categories' as table_name, COUNT(*) as count FROM pet_categories
UNION ALL
SELECT 'pet_breeds' as table_name, COUNT(*) as count FROM pet_breeds;

-- 3. 检查宠物状态分布（用于饼图）
SELECT 'Checking pet status distribution...' as message;
SELECT status, COUNT(*) as count FROM pets GROUP BY status;

-- 4. 检查宠物性别分布（用于饼图）
SELECT 'Checking pet gender distribution...' as message;
SELECT gender, COUNT(*) as count FROM pets GROUP BY gender;

-- 5. 检查用户角色分布（用于饼图）
SELECT 'Checking user role distribution...' as message;
SELECT role, COUNT(*) as count FROM users GROUP BY role;

-- 6. 检查热门宠物品种（用于柱状图）
SELECT 'Checking popular pet breeds...' as message;
SELECT 
    pb.breed_name as breed_name,
    COUNT(p.pet_id) as count
FROM pet_breeds pb
LEFT JOIN pets p ON pb.breed_id = p.breed_id
GROUP BY pb.breed_id, pb.breed_name
ORDER BY count DESC
LIMIT 5;

-- 7. 检查领养申请趋势（用于折线图）
SELECT 'Checking adoption application trend...' as message;
SELECT 
    DATE_FORMAT(application_date, '%Y-%m') as month,
    COUNT(*) as count
FROM adoption_applications 
WHERE application_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(application_date, '%Y-%m')
ORDER BY month;

-- 8. 检查分类统计（用于环形图）
SELECT 'Checking category statistics...' as message;
SELECT 
    pc.name as category_name,
    COUNT(pb.breed_id) as breed_count
FROM pet_categories pc
LEFT JOIN pet_breeds pb ON pc.category_id = pb.category_id
GROUP BY pc.category_id, pc.name
ORDER BY pc.display_order;

-- 9. 检查基础统计数据
SELECT 'Checking basic statistics...' as message;
SELECT 
    (SELECT COUNT(*) FROM pets) as total_pets,
    (SELECT COUNT(*) FROM pets WHERE status = 'AVAILABLE') as available_pets,
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM adoption_applications) as total_applications,
    (SELECT COUNT(*) FROM adoption_applications WHERE status = 'PENDING') as pending_applications,
    (SELECT COUNT(*) FROM adoption_applications WHERE status = 'APPROVED') as successful_adoptions;

-- 10. 检查是否有足够的数据用于图表显示
SELECT 'Checking if there is enough data for charts...' as message;
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM pets) > 0 THEN '✓ Pets data available'
        ELSE '✗ No pets data'
    END as pets_status,
    CASE 
        WHEN (SELECT COUNT(*) FROM users) > 0 THEN '✓ Users data available'
        ELSE '✗ No users data'
    END as users_status,
    CASE 
        WHEN (SELECT COUNT(*) FROM adoption_applications) > 0 THEN '✓ Applications data available'
        ELSE '✗ No applications data'
    END as applications_status,
    CASE 
        WHEN (SELECT COUNT(*) FROM pet_categories) > 0 THEN '✓ Categories data available'
        ELSE '✗ No categories data'
    END as categories_status; 