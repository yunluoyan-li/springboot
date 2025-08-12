-- 测试品种插入功能
USE pet_adoption_db;

-- 检查表结构
DESCRIBE pet_breeds;

-- 检查现有数据
SELECT * FROM pet_breeds;

-- 测试插入一个品种
INSERT INTO pet_breeds (category_id, breed_name, origin, life_span, temperament, care_level, description, search_keywords)
VALUES (1, '中华田园猫', '中国', '12-18年', '温顺、独立', 'LOW', '中华田园猫是中国本土的猫种，性格温顺，适应能力强。', '中华田园猫,土猫,家猫');

-- 检查插入结果
SELECT * FROM pet_breeds WHERE breed_name = '中华田园猫'; 