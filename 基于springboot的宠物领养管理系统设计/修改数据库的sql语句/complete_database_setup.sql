-- 完整的数据库设置脚本
-- 包括表结构修复和测试数据插入

USE pet_adoption_db;

-- ========================================
-- 第一部分：修复表结构
-- ========================================

-- 1. 修复 pets 表，添加缺失的列
ALTER TABLE pets 
ADD COLUMN IF NOT EXISTS source VARCHAR(50) DEFAULT 'SHELTER' COMMENT '来源：SHELTER, RESCUE, OWNER_SURRENDER' AFTER status,
ADD COLUMN IF NOT EXISTS crawler_data_id INT NULL COMMENT '爬虫数据ID' AFTER source,
ADD COLUMN IF NOT EXISTS featured BOOLEAN DEFAULT FALSE COMMENT '是否推荐' AFTER crawler_data_id,
ADD COLUMN IF NOT EXISTS view_count INT DEFAULT 0 COMMENT '浏览次数' AFTER featured;

-- 2. 修复 adoption_applications 表，添加缺失的列
ALTER TABLE adoption_applications 
ADD COLUMN IF NOT EXISTS application_text TEXT COMMENT '申请文本' AFTER pet_id,
ADD COLUMN IF NOT EXISTS home_description TEXT COMMENT '家庭环境描述' AFTER application_text,
ADD COLUMN IF NOT EXISTS experience TEXT COMMENT '养宠经验' AFTER home_description,
ADD COLUMN IF NOT EXISTS admin_notes TEXT COMMENT '管理员备注' AFTER experience,
ADD COLUMN IF NOT EXISTS response_date TIMESTAMP NULL COMMENT '回复日期' AFTER admin_notes,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' AFTER response_date;

-- 3. 修复 pet_categories 表，添加缺失的列
ALTER TABLE pet_categories 
ADD COLUMN IF NOT EXISTS icon_url VARCHAR(255) COMMENT '图标URL' AFTER description;

-- 4. 创建 pet_images 表（如果不存在）
CREATE TABLE IF NOT EXISTS pet_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    pet_id INT NOT NULL COMMENT '宠物ID',
    image_url VARCHAR(255) NOT NULL COMMENT '图片URL',
    is_primary BOOLEAN DEFAULT FALSE COMMENT '是否主图',
    display_order INT DEFAULT 0 COMMENT '显示顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物图片表';

-- 5. 创建 tags 表（如果不存在）
CREATE TABLE IF NOT EXISTS tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名称',
    description TEXT COMMENT '标签描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 6. 创建 pet_tags 关联表（如果不存在）
CREATE TABLE IF NOT EXISTS pet_tags (
    pet_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (pet_id, tag_id),
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物标签关联表';

-- ========================================
-- 第二部分：插入测试数据
-- ========================================

-- 插入更多测试用户
INSERT IGNORE INTO users (username, password, email, real_name, role, status) VALUES
('user1', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'user1@example.com', '张三', 'USER', 'ACTIVE'),
('user2', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'user2@example.com', '李四', 'USER', 'ACTIVE'),
('user3', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'user3@example.com', '王五', 'USER', 'ACTIVE'),
('staff1', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'staff1@example.com', '员工1', 'USER', 'ACTIVE'),
('staff2', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'staff2@example.com', '员工2', 'USER', 'ACTIVE');

-- 插入更多测试宠物
INSERT IGNORE INTO pets (name, breed_id, age, gender, color, size, health_status, status, description, story) VALUES
-- 猫类
('小花', 1, 8, 'FEMALE', '三花', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '活泼可爱的三花猫，特别喜欢玩逗猫棒', '小花是救助站收留的流浪猫，现在已经完全康复'),
('大橘', 1, 24, 'MALE', '橘色', 'LARGE', 'GOOD', 'AVAILABLE', '胖乎乎的大橘猫，性格温顺', '大橘原本是小区里的流浪猫，经过喂养后变得非常亲人'),
('小黑', 2, 12, 'MALE', '黑色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '优雅的英短黑猫，性格安静', '小黑是纯种英短，主人因过敏无法继续饲养'),
('雪球', 4, 6, 'FEMALE', '白色', 'MEDIUM', 'GOOD', 'AVAILABLE', '美丽的波斯猫，需要定期梳理', '雪球是纯种波斯猫，性格安静优雅'),
('咪咪', 5, 18, 'FEMALE', '重点色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '活泼的暹罗猫，喜欢与人互动', '咪咪是纯种暹罗猫，声音独特，非常聪明'),

-- 狗类
('大黄', 6, 36, 'MALE', '黄色', 'MEDIUM', 'GOOD', 'AVAILABLE', '忠诚的中华田园犬，适合看家护院', '大黄原本是农村的看家犬，主人搬家后无法带走'),
('小白', 7, 18, 'FEMALE', '白色', 'LARGE', 'EXCELLENT', 'AVAILABLE', '温顺的金毛，特别喜欢孩子', '小白是训练有素的导盲犬，因年龄原因退役'),
('小黑', 8, 12, 'MALE', '黑色', 'LARGE', 'GOOD', 'AVAILABLE', '活泼的拉布拉多，适合家庭饲养', '小黑是纯种拉布拉多，性格友好，适合有孩子的家庭'),
('二哈', 9, 24, 'MALE', '灰白色', 'LARGE', 'GOOD', 'AVAILABLE', '活泼的哈士奇，需要大量运动', '二哈是纯种哈士奇，性格活泼，适合有经验的饲养者'),
('小短腿', 10, 18, 'FEMALE', '黄白色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '可爱的柯基，性格活泼', '小短腿是纯种柯基，短腿长身，非常可爱'),

-- 兔子
('小灰', 11, 12, 'MALE', '灰色', 'SMALL', 'GOOD', 'AVAILABLE', '温顺的荷兰垂耳兔，耳朵下垂', '小灰是纯种荷兰垂耳兔，性格温顺，适合新手'),
('小白兔', 12, 8, 'FEMALE', '白色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '美丽的安哥拉兔，需要定期梳理', '小白兔是纯种安哥拉兔，长毛需要定期护理'),
('小不点', 13, 6, 'MALE', '棕色', 'SMALL', 'GOOD', 'AVAILABLE', '迷你荷兰侏儒兔，体型极小', '小不点是世界上最小的兔子品种，非常可爱'),

-- 鸟类
('小黄', 14, 12, 'MALE', '黄色', 'SMALL', 'EXCELLENT', 'AVAILABLE', '活泼的虎皮鹦鹉，可以学会说话', '小黄是纯种虎皮鹦鹉，颜色丰富，适合初学者'),
('小灰', 15, 24, 'FEMALE', '灰色', 'MEDIUM', 'GOOD', 'AVAILABLE', '温顺的玄凤鹦鹉，可以学会说话', '小灰是纯种玄凤鹦鹉，性格温顺，适合家庭饲养'),
('小彩', 16, 18, 'MALE', '彩色', 'SMALL', 'EXCELLENT', 'AVAILABLE', '艳丽的牡丹鹦鹉，性格活泼', '小彩是纯种牡丹鹦鹉，颜色艳丽，性格活泼');

-- 插入一些已领养的宠物
INSERT IGNORE INTO pets (name, breed_id, age, gender, color, size, health_status, status, description, story) VALUES
('已领养1', 1, 12, 'MALE', '白色', 'MEDIUM', 'GOOD', 'ADOPTED', '已成功领养的宠物', '这是一个已成功领养的宠物'),
('已领养2', 7, 18, 'FEMALE', '金色', 'LARGE', 'EXCELLENT', 'ADOPTED', '已成功领养的宠物', '这是一个已成功领养的宠物'),
('已领养3', 2, 8, 'MALE', '蓝灰色', 'MEDIUM', 'GOOD', 'ADOPTED', '已成功领养的宠物', '这是一个已成功领养的宠物');

-- 插入一些待审核的宠物
INSERT IGNORE INTO pets (name, breed_id, age, gender, color, size, health_status, status, description, story) VALUES
('待审核1', 6, 24, 'MALE', '黄色', 'MEDIUM', 'GOOD', 'PENDING', '待审核的宠物', '这是一个待审核的宠物'),
('待审核2', 3, 10, 'FEMALE', '虎斑', 'MEDIUM', 'EXCELLENT', 'PENDING', '待审核的宠物', '这是一个待审核的宠物');

-- 插入一些领养申请
INSERT IGNORE INTO adoption_applications (user_id, pet_id, status, reason, experience, living_condition, family_members, work_schedule, financial_ability, other_pets, contact_phone, contact_address) VALUES
(2, 1, 'PENDING', '我很喜欢猫，想要一个陪伴', '之前养过猫，有经验', '80平米公寓，有阳台', '我和妻子两人', '朝九晚五，周末休息', '月收入8000，可以承担宠物费用', '没有其他宠物', '13800138001', '北京市朝阳区'),
(2, 2, 'APPROVED', '想要一个忠诚的狗狗陪伴', '之前养过狗，有经验', '120平米房子，有院子', '我和妻子，还有一个5岁孩子', '朝九晚五，周末休息', '月收入12000，可以承担宠物费用', '没有其他宠物', '13800138002', '北京市海淀区'),
(3, 3, 'REJECTED', '想要一个安静的猫咪', '没有养宠经验', '60平米公寓', '我一个人住', '经常出差', '月收入6000', '没有其他宠物', '13800138003', '北京市西城区'),
(4, 4, 'PENDING', '喜欢波斯猫的优雅', '之前养过猫，有经验', '100平米房子', '我和丈夫两人', '朝九晚五', '月收入10000', '有一只金鱼', '13800138004', '北京市东城区'),
(5, 5, 'APPROVED', '想要一个活泼的猫咪', '之前养过暹罗猫', '90平米公寓', '我和女朋友', '朝九晚五', '月收入9000', '没有其他宠物', '13800138005', '北京市丰台区');

-- 插入一些示例图片数据
INSERT IGNORE INTO pet_images (pet_id, image_url, is_primary, display_order) VALUES
(1, '/images/pets/cat1.jpg', TRUE, 1),
(1, '/images/pets/cat1_2.jpg', FALSE, 2),
(2, '/images/pets/dog1.jpg', TRUE, 1),
(3, '/images/pets/cat2.jpg', TRUE, 1),
(4, '/images/pets/dog2.jpg', TRUE, 1),
(5, '/images/pets/cat3.jpg', TRUE, 1),
(6, '/images/pets/dog3.jpg', TRUE, 1),
(7, '/images/pets/dog4.jpg', TRUE, 1),
(8, '/images/pets/dog5.jpg', TRUE, 1),
(9, '/images/pets/dog6.jpg', TRUE, 1),
(10, '/images/pets/dog7.jpg', TRUE, 1);

-- 插入一些示例标签
INSERT IGNORE INTO tags (name, description) VALUES
('温顺', '性格温顺的宠物'),
('活泼', '性格活泼的宠物'),
('亲人', '特别亲人的宠物'),
('适合新手', '适合新手饲养的宠物'),
('适合家庭', '适合家庭饲养的宠物'),
('需要运动', '需要大量运动的宠物'),
('安静', '性格安静的宠物'),
('聪明', '特别聪明的宠物'),
('忠诚', '特别忠诚的宠物');

-- 为宠物添加标签
INSERT IGNORE INTO pet_tags (pet_id, tag_id) VALUES
(1, 1), (1, 3), (1, 4), -- 小白：温顺、亲人、适合新手
(2, 1), (2, 3), (2, 5), -- 旺财：温顺、亲人、适合家庭
(3, 1), (3, 7), (3, 5), -- 咪咪：温顺、安静、适合家庭
(4, 1), (4, 3), (4, 5), -- 大黄：温顺、亲人、适合家庭
(5, 2), (5, 3), (5, 8), -- 小花：活泼、亲人、聪明
(6, 1), (6, 9), (6, 5), -- 大橘：温顺、忠诚、适合家庭
(7, 1), (7, 3), (7, 5), -- 小黑：温顺、亲人、适合家庭
(8, 1), (8, 3), (8, 5), -- 雪球：温顺、亲人、适合家庭
(9, 2), (9, 3), (9, 8), -- 咪咪：活泼、亲人、聪明
(10, 1), (10, 9), (10, 5), -- 大黄：温顺、忠诚、适合家庭
(11, 1), (11, 3), (11, 5), -- 小白：温顺、亲人、适合家庭
(12, 1), (12, 3), (12, 5), -- 小黑：温顺、亲人、适合家庭
(13, 2), (13, 6), (13, 8), -- 二哈：活泼、需要运动、聪明
(14, 2), (14, 3), (14, 5); -- 小短腿：活泼、亲人、适合家庭

-- 更新一些宠物的推荐状态
UPDATE pets SET featured = TRUE WHERE pet_id IN (1, 4, 7, 10);

-- 更新一些宠物的浏览次数
UPDATE pets SET view_count = FLOOR(RAND() * 100) + 10;

-- ========================================
-- 第三部分：验证设置
-- ========================================

-- 显示设置结果
SELECT 'Complete database setup completed successfully!' as message;

-- 显示数据统计
SELECT 
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM pets) as total_pets,
    (SELECT COUNT(*) FROM adoption_applications) as total_applications,
    (SELECT COUNT(*) FROM pet_images) as total_images,
    (SELECT COUNT(*) FROM tags) as total_tags,
    (SELECT COUNT(*) FROM pet_tags) as total_pet_tags;

-- 显示宠物状态分布
SELECT status, COUNT(*) as count FROM pets GROUP BY status;

-- 显示宠物性别分布
SELECT gender, COUNT(*) as count FROM pets GROUP BY gender;

-- 显示用户角色分布
SELECT role, COUNT(*) as count FROM users GROUP BY role;

-- 显示热门宠物品种
SELECT 
    pb.breed_name as breed_name,
    COUNT(p.pet_id) as count
FROM pet_breeds pb
LEFT JOIN pets p ON pb.breed_id = p.breed_id
GROUP BY pb.breed_id, pb.breed_name
ORDER BY count DESC
LIMIT 5; 