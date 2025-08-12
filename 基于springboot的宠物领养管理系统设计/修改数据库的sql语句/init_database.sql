-- 宠物领养系统数据库初始化脚本
-- 请先创建数据库：CREATE DATABASE pet_adoption_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE pet_adoption_db;

-- 1. 创建宠物分类表
CREATE TABLE IF NOT EXISTS pet_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    slug VARCHAR(100) UNIQUE NOT NULL COMMENT '分类别名',
    description TEXT COMMENT '分类描述',
    display_order INT DEFAULT 0 COMMENT '显示顺序',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物分类表';

-- 2. 创建宠物品种表
CREATE TABLE IF NOT EXISTS pet_breeds (
    breed_id INT PRIMARY KEY AUTO_INCREMENT,
    breed_name VARCHAR(100) NOT NULL COMMENT '品种名称',
    category_id INT NOT NULL COMMENT '分类ID',
    name VARCHAR(100) NOT NULL COMMENT '品种显示名称',
    origin VARCHAR(100) COMMENT '原产地',
    life_span VARCHAR(50) COMMENT '寿命',
    temperament VARCHAR(200) COMMENT '性格特点',
    care_level ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'MEDIUM' COMMENT '护理难度',
    description TEXT COMMENT '品种描述',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    search_keywords TEXT COMMENT '搜索关键词',
    FOREIGN KEY (category_id) REFERENCES pet_categories(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物品种表';

-- 3. 创建用户表
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '电话',
    real_name VARCHAR(50) COMMENT '真实姓名',
    address TEXT COMMENT '地址',
    role ENUM('USER', 'ADMIN') DEFAULT 'USER' COMMENT '用户角色',
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE' COMMENT '用户状态',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 4. 创建宠物表
CREATE TABLE IF NOT EXISTS pets (
    pet_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '宠物名称',
    breed_id INT COMMENT '品种ID',
    age INT COMMENT '年龄（月）',
    gender ENUM('MALE', 'FEMALE', 'UNKNOWN') COMMENT '性别',
    color VARCHAR(50) COMMENT '颜色',
    size ENUM('SMALL', 'MEDIUM', 'LARGE') COMMENT '体型',
    health_status ENUM('EXCELLENT', 'GOOD', 'FAIR', 'POOR') DEFAULT 'GOOD' COMMENT '健康状况',
    status ENUM('AVAILABLE', 'PENDING', 'ADOPTED', 'UNAVAILABLE') DEFAULT 'AVAILABLE' COMMENT '状态',
    description TEXT COMMENT '描述',
    story TEXT COMMENT '背景故事',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (breed_id) REFERENCES pet_breeds(breed_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物表';

-- 5. 创建领养申请表
CREATE TABLE IF NOT EXISTS adoption_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '申请人ID',
    pet_id INT NOT NULL COMMENT '宠物ID',
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '申请日期',
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') DEFAULT 'PENDING' COMMENT '申请状态',
    reason TEXT COMMENT '申请理由',
    experience TEXT COMMENT '养宠经验',
    living_condition TEXT COMMENT '居住条件',
    family_members TEXT COMMENT '家庭成员',
    work_schedule TEXT COMMENT '工作时间',
    financial_ability TEXT COMMENT '经济能力',
    other_pets TEXT COMMENT '其他宠物',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    contact_address TEXT COMMENT '联系地址',
    admin_notes TEXT COMMENT '管理员备注',
    processed_date TIMESTAMP NULL COMMENT '处理日期',
    processed_by INT COMMENT '处理人ID',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领养申请表';

-- 6. 插入基础数据

-- 插入宠物分类
INSERT IGNORE INTO pet_categories (category_id, name, slug, description, display_order) VALUES
(1, '猫', 'cats', '猫科动物，包括各种家猫品种', 1),
(2, '狗', 'dogs', '犬科动物，包括各种家犬品种', 2),
(3, '兔子', 'rabbits', '兔科动物，包括各种宠物兔品种', 3),
(4, '鸟类', 'birds', '鸟类动物，包括各种宠物鸟品种', 4);

-- 插入宠物品种
INSERT IGNORE INTO pet_breeds (breed_id, breed_name, category_id, name, origin, life_span, temperament, care_level, description, created_at, search_keywords) VALUES
-- 猫的品种
(1, '中华田园猫', 1, '中华田园猫', '中国', '12-18年', '独立、聪明、适应性强', 'LOW', '中国本土猫种，适应性强，性格温顺，适合新手饲养', NOW(), '中华田园猫,土猫,家猫,中国猫'),
(2, '英国短毛猫', 1, '英国短毛猫', '英国', '12-20年', '温顺、安静、亲人', 'LOW', '体型圆胖，性格温和，适合家庭饲养，特别适合有孩子的家庭', NOW(), '英国短毛猫,英短,蓝猫,银渐层'),
(3, '美国短毛猫', 1, '美国短毛猫', '美国', '15-20年', '友好、活泼、聪明', 'LOW', '体型健壮，性格友好，适合有孩子的家庭，是优秀的家庭猫', NOW(), '美国短毛猫,美短,虎斑猫'),
(4, '波斯猫', 1, '波斯猫', '波斯', '12-16年', '安静、优雅、亲人', 'HIGH', '长毛猫，需要定期梳理，性格安静优雅，适合安静的家庭', NOW(), '波斯猫,长毛猫,金吉拉'),
(5, '暹罗猫', 1, '暹罗猫', '泰国', '15-20年', '聪明、活泼、爱叫', 'MEDIUM', '体型修长，性格活泼，喜欢与人互动，声音独特', NOW(), '暹罗猫,泰国猫,重点色猫'),

-- 狗的品种
(6, '中华田园犬', 2, '中华田园犬', '中国', '12-15年', '忠诚、勇敢、适应性强', 'LOW', '中国本土犬种，适应性强，忠诚勇敢，适合看家护院', NOW(), '中华田园犬,土狗,家狗,中国狗'),
(7, '金毛寻回犬', 2, '金毛寻回犬', '英国', '10-12年', '友好、聪明、温顺', 'MEDIUM', '性格温和，适合家庭饲养，特别适合有孩子的家庭，是优秀的导盲犬', NOW(), '金毛,金毛寻回犬,黄金猎犬'),
(8, '拉布拉多', 2, '拉布拉多', '加拿大', '10-12年', '友好、活泼、聪明', 'MEDIUM', '体型健壮，性格友好，是优秀的家庭犬和工作犬', NOW(), '拉布拉多,拉布拉多寻回犬,拉布'),
(9, '哈士奇', 2, '哈士奇', '西伯利亚', '12-15年', '活泼、独立、友善', 'HIGH', '需要大量运动，性格活泼，适合有经验的饲养者，不适合新手', NOW(), '哈士奇,西伯利亚雪橇犬,二哈'),
(10, '柯基', 2, '柯基', '英国', '12-14年', '活泼、聪明、忠诚', 'MEDIUM', '短腿长身，性格活泼，适合家庭饲养，是英国女王的爱犬', NOW(), '柯基,威尔士柯基,短腿狗'),

-- 兔子的品种
(11, '荷兰垂耳兔', 3, '荷兰垂耳兔', '荷兰', '7-10年', '温顺、安静、亲人', 'MEDIUM', '体型小巧，耳朵下垂，性格温顺，适合新手饲养', NOW(), '荷兰垂耳兔,垂耳兔,荷兰兔'),
(12, '安哥拉兔', 3, '安哥拉兔', '土耳其', '7-12年', '温顺、安静', 'HIGH', '长毛兔，需要定期梳理，性格温顺，适合有经验的饲养者', NOW(), '安哥拉兔,长毛兔,安哥拉'),
(13, '荷兰侏儒兔', 3, '荷兰侏儒兔', '荷兰', '7-10年', '活泼、好奇、亲人', 'LOW', '体型极小，性格活泼，适合新手饲养，是世界上最小的兔子品种', NOW(), '荷兰侏儒兔,侏儒兔,迷你兔'),

-- 鸟的品种
(14, '虎皮鹦鹉', 4, '虎皮鹦鹉', '澳大利亚', '5-8年', '活泼、聪明、好动', 'LOW', '体型小巧，颜色丰富，适合初学者，可以学会说话', NOW(), '虎皮鹦鹉,虎皮,鹦鹉,小鸟'),
(15, '玄凤鹦鹉', 4, '玄凤鹦鹉', '澳大利亚', '15-20年', '温顺、聪明、亲人', 'MEDIUM', '体型中等，性格温顺，可以学会说话，适合家庭饲养', NOW(), '玄凤鹦鹉,玄凤,鸡尾鹦鹉'),
(16, '牡丹鹦鹉', 4, '牡丹鹦鹉', '非洲', '10-15年', '活泼、聪明、好动', 'MEDIUM', '体型小巧，颜色艳丽，性格活泼，适合有经验的饲养者', NOW(), '牡丹鹦鹉,牡丹,情侣鹦鹉');

-- 插入管理员用户（密码：admin123）
INSERT IGNORE INTO users (user_id, username, password, email, real_name, role, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'admin@example.com', '系统管理员', 'ADMIN', 'ACTIVE');

-- 插入测试用户（密码：user123）
INSERT IGNORE INTO users (user_id, username, password, email, real_name, role, status) VALUES
(2, 'user', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'user@example.com', '测试用户', 'USER', 'ACTIVE');

-- 插入示例宠物
INSERT IGNORE INTO pets (pet_id, name, breed_id, age, gender, color, size, health_status, status, description, story) VALUES
(1, '小白', 1, 12, 'MALE', '白色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '一只温顺的中华田园猫，非常亲人', '小白是在小区里被发现的流浪猫，经过救助后变得非常温顺'),
(2, '旺财', 6, 18, 'MALE', '黄色', 'MEDIUM', 'GOOD', 'AVAILABLE', '忠诚的中华田园犬，适合看家护院', '旺财原本是农村的看家犬，主人搬家后无法带走，现在寻找新家'),
(3, '咪咪', 2, 8, 'FEMALE', '蓝灰色', 'MEDIUM', 'EXCELLENT', 'AVAILABLE', '优雅的英国短毛猫，性格安静', '咪咪是纯种英短，主人因工作调动无法继续饲养'),
(4, '大黄', 7, 24, 'MALE', '金黄色', 'LARGE', 'GOOD', 'AVAILABLE', '友好的金毛，特别喜欢孩子', '大黄是训练有素的导盲犬，因年龄原因退役，现在寻找养老家庭');

-- 显示创建结果
SELECT 'Database initialization completed successfully!' as message;
SELECT COUNT(*) as pet_categories_count FROM pet_categories;
SELECT COUNT(*) as pet_breeds_count FROM pet_breeds;
SELECT COUNT(*) as users_count FROM users;
SELECT COUNT(*) as pets_count FROM pets; 