-- 测试数据库连接和表结构
USE pet_adoption_db;

-- 1. 检查表是否存在
SHOW TABLES;

-- 2. 检查 pet_categories 表结构
DESCRIBE pet_categories;

-- 3. 检查 pet_breeds 表结构
DESCRIBE pet_breeds;

-- 4. 检查现有数据
SELECT 'pet_categories' as table_name, COUNT(*) as count FROM pet_categories
UNION ALL
SELECT 'pet_breeds', COUNT(*) FROM pet_breeds
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'pets', COUNT(*) FROM pets;

-- 5. 查看 pet_breeds 表的前几条记录
SELECT * FROM pet_breeds LIMIT 5;

-- 6. 测试插入一条记录（如果表是空的）
INSERT IGNORE INTO pet_categories (category_id, name, slug, description, display_order) VALUES
(1, '猫', 'cats', '猫科动物，包括各种家猫品种', 1);

INSERT IGNORE INTO pet_breeds (breed_id, category_id, breed_name, origin, life_span, temperament, care_level, description, created_at, search_keywords) VALUES
(1, 1, '中华田园猫', '中国', '12-18年', '独立、聪明、适应性强', 'LOW', '中国本土猫种，适应性强，性格温顺，适合新手饲养', NOW(), '中华田园猫,土猫,家猫,中国猫');

-- 7. 验证插入结果
SELECT 'Test completed!' as message;
SELECT COUNT(*) as total_breeds FROM pet_breeds;

-- 检查adoption_applications表结构
DESCRIBE adoption_applications;

-- 检查是否有数据
SELECT COUNT(*) FROM adoption_applications;

-- 检查users表
SELECT COUNT(*) FROM users;

-- 检查pets表
SELECT COUNT(*) FROM pets; 