-- 数据库表结构修复脚本
-- 添加缺失的列以支持完整的数据分析功能

USE pet_adoption_db;

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

-- 7. 插入一些示例图片数据
INSERT IGNORE INTO pet_images (pet_id, image_url, is_primary, display_order) VALUES
(1, '/images/pets/cat1.jpg', TRUE, 1),
(1, '/images/pets/cat1_2.jpg', FALSE, 2),
(2, '/images/pets/dog1.jpg', TRUE, 1),
(3, '/images/pets/cat2.jpg', TRUE, 1),
(4, '/images/pets/dog2.jpg', TRUE, 1);

-- 8. 插入一些示例标签
INSERT IGNORE INTO tags (name, description) VALUES
('温顺', '性格温顺的宠物'),
('活泼', '性格活泼的宠物'),
('亲人', '特别亲人的宠物'),
('适合新手', '适合新手饲养的宠物'),
('适合家庭', '适合家庭饲养的宠物'),
('需要运动', '需要大量运动的宠物'),
('安静', '性格安静的宠物');

-- 9. 为宠物添加标签
INSERT IGNORE INTO pet_tags (pet_id, tag_id) VALUES
(1, 1), (1, 3), (1, 4), -- 小白：温顺、亲人、适合新手
(2, 1), (2, 3), (2, 5), -- 旺财：温顺、亲人、适合家庭
(3, 1), (3, 7), (3, 5), -- 咪咪：温顺、安静、适合家庭
(4, 1), (4, 3), (4, 5); -- 大黄：温顺、亲人、适合家庭

-- 10. 更新一些宠物的推荐状态
UPDATE pets SET featured = TRUE WHERE pet_id IN (1, 4);

-- 11. 更新一些宠物的浏览次数
UPDATE pets SET view_count = FLOOR(RAND() * 100) + 10;

-- 12. 显示修复结果
SELECT 'Database schema fix completed successfully!' as message;

-- 13. 验证表结构
DESCRIBE pets;
DESCRIBE adoption_applications;
DESCRIBE pet_categories;
DESCRIBE pet_images;
DESCRIBE tags;
DESCRIBE pet_tags;

-- 14. 显示数据统计
SELECT 
    (SELECT COUNT(*) FROM pets) as total_pets,
    (SELECT COUNT(*) FROM pet_images) as total_images,
    (SELECT COUNT(*) FROM tags) as total_tags,
    (SELECT COUNT(*) FROM pet_tags) as total_pet_tags; 