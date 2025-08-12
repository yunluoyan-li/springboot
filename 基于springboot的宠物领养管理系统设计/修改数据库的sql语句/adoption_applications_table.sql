-- 创建领养申请表
CREATE TABLE IF NOT EXISTS adoption_applications (
    application_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pet_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    application_text TEXT NOT NULL COMMENT '申请理由',
    home_description TEXT NOT NULL COMMENT '家庭环境描述',
    experience TEXT COMMENT '养宠经验',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
    admin_notes TEXT COMMENT '管理员审核意见',
    response_date TIMESTAMP NULL COMMENT '审核时间',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    
    -- 外键约束
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    
    -- 索引
    INDEX idx_pet_id (pet_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    
    -- 唯一约束：防止同一用户重复申请同一宠物
    UNIQUE KEY uk_user_pet (user_id, pet_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='领养申请表';

-- 插入一些测试数据（可选）
INSERT INTO adoption_applications (pet_id, user_id, application_text, home_description, experience, status) VALUES
(1, 1, '我非常喜欢这只小猫，家里有足够的空间和爱心来照顾它。', '我家住在小区里，有阳台和客厅，环境安静适合养猫。', '之前养过一只猫，有丰富的养猫经验。', 'PENDING'),
(2, 2, '这只小狗很可爱，我想给它一个温暖的家。', '独栋房子，有院子，非常适合养狗。', '没有养狗经验，但会认真学习相关知识。', 'PENDING'),
(3, 1, '这只兔子很温顺，适合作为家庭宠物。', '公寓式住宅，有专门的宠物区域。', '养过仓鼠，对小型宠物有经验。', 'APPROVED'); 