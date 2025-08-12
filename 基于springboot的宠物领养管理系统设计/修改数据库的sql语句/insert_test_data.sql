-- 数据分析测试数据插入脚本
-- 请确保先运行 init_database.sql 创建数据库结构

USE pet_adoption_db;

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

-- 显示插入结果
SELECT 'Test data insertion completed successfully!' as message;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_pets FROM pets;
SELECT COUNT(*) as total_applications FROM adoption_applications;
SELECT status, COUNT(*) as count FROM pets GROUP BY status;
SELECT gender, COUNT(*) as count FROM pets GROUP BY gender;
SELECT role, COUNT(*) as count FROM users GROUP BY role; 