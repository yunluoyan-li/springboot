-- 创建宠物分类表
CREATE TABLE IF NOT EXISTS pet_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    slug VARCHAR(100) UNIQUE NOT NULL COMMENT '分类别名',
    description TEXT COMMENT '分类描述',
    display_order INT DEFAULT 0 COMMENT '显示顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物分类表';

-- 插入基础分类数据
INSERT IGNORE INTO pet_categories (category_id, name, slug, description, display_order) VALUES
(1, '猫', 'cats', '猫科动物，包括各种家猫品种', 1),
(2, '狗', 'dogs', '犬科动物，包括各种家犬品种', 2),
(3, '兔子', 'rabbits', '兔科动物，包括各种宠物兔品种', 3),
(4, '鸟类', 'birds', '鸟类动物，包括各种宠物鸟品种', 4); 