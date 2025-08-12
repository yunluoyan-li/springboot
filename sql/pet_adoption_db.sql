/*
 Navicat Premium Data Transfer

 Source Server         : 自己电脑的sql
 Source Server Type    : MySQL
 Source Server Version : 50624
 Source Host           : localhost:3306
 Source Schema         : pet_adoption_db

 Target Server Type    : MySQL
 Target Server Version : 50624
 File Encoding         : 65001

 Date: 12/08/2025 19:39:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for adoption_applications
-- ----------------------------
DROP TABLE IF EXISTS `adoption_applications`;
CREATE TABLE `adoption_applications`  (
  `application_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pet_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `application_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '申请理由',
  `home_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '家庭环境描述',
  `experience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '养宠经验',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝',
  `admin_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '管理员审核意见',
  `response_date` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`application_id`) USING BTREE,
  UNIQUE INDEX `uk_user_pet`(`user_id`, `pet_id`) USING BTREE,
  INDEX `idx_pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  CONSTRAINT `adoption_applications_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `adoption_applications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '领养申请表' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of adoption_applications
-- ----------------------------
INSERT INTO `adoption_applications` VALUES (3, 5, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-05 16:52:23', '2025-07-05 16:52:11');
INSERT INTO `adoption_applications` VALUES (4, 6, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-07 14:34:39', '2025-07-06 10:56:12');
INSERT INTO `adoption_applications` VALUES (5, 12, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-07 14:34:38', '2025-07-07 14:32:46');
INSERT INTO `adoption_applications` VALUES (6, 25, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-07 14:34:36', '2025-07-07 14:33:02');
INSERT INTO `adoption_applications` VALUES (7, 2, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-07 14:35:21', '2025-07-07 14:35:11');
INSERT INTO `adoption_applications` VALUES (8, 3, 1, '1', '1', '1', 'REJECTED', '管理员审核通过', '2025-07-07 14:55:26', '2025-07-07 14:35:49');
INSERT INTO `adoption_applications` VALUES (9, 3, 25, '111', '111', '111', 'APPROVED', '管理员审核通过', '2025-07-09 08:49:08', '2025-07-08 06:55:10');
INSERT INTO `adoption_applications` VALUES (10, 30, 1, '1', '1', '1', 'APPROVED', '管理员审核通过', '2025-07-09 08:49:04', '2025-07-09 08:48:44');
INSERT INTO `adoption_applications` VALUES (11, 10, 28, '喜欢', '较好', '有3年经验', 'PENDING', NULL, NULL, '2025-07-10 01:31:17');

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `pet_id` bigint(20) NOT NULL COMMENT '宠物ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父评论ID(用于回复)',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '评论内容',
  `status` enum('PUBLISHED','HIDDEN','DELETED') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'PUBLISHED' COMMENT '状态',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`comment_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `parent_id`(`parent_id`) USING BTREE,
  INDEX `idx_comments_pet`(`pet_id`) USING BTREE,
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`comment_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of comments
-- ----------------------------
INSERT INTO `comments` VALUES (1, 2, 1, NULL, '好可爱呀', 'PUBLISHED', '2025-07-07 20:19:02');
INSERT INTO `comments` VALUES (2, 5, 1, NULL, '6666', 'PUBLISHED', '2025-07-09 09:14:09');
INSERT INTO `comments` VALUES (3, 2, 25, NULL, '1', 'PUBLISHED', '2025-07-09 20:40:34');
INSERT INTO `comments` VALUES (4, 2, 25, NULL, '1', 'HIDDEN', '2025-07-09 20:41:10');
INSERT INTO `comments` VALUES (5, 2, 25, 2, '1', 'PUBLISHED', '2025-07-09 20:46:19');
INSERT INTO `comments` VALUES (6, 2, 25, 1, '666', 'PUBLISHED', '2025-07-09 20:46:29');

-- ----------------------------
-- Table structure for favorites
-- ----------------------------
DROP TABLE IF EXISTS `favorites`;
CREATE TABLE `favorites`  (
  `favorite_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `pet_id` bigint(20) NOT NULL COMMENT '宠物ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id`, `pet_id`) USING BTREE COMMENT '防止重复收藏',
  INDEX `pet_id`(`pet_id`) USING BTREE,
  INDEX `idx_favorites_user`(`user_id`) USING BTREE,
  CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of favorites
-- ----------------------------
INSERT INTO `favorites` VALUES (13, 1, 291, '2025-07-10 01:30:08');
INSERT INTO `favorites` VALUES (14, 1, 299, '2025-07-10 01:30:13');
INSERT INTO `favorites` VALUES (15, 1, 297, '2025-07-10 01:30:16');
INSERT INTO `favorites` VALUES (16, 1, 295, '2025-07-10 01:30:19');
INSERT INTO `favorites` VALUES (17, 1, 293, '2025-07-10 01:30:22');
INSERT INTO `favorites` VALUES (18, 1, 292, '2025-07-10 01:30:24');
INSERT INTO `favorites` VALUES (21, 1, 294, '2025-07-10 01:30:31');
INSERT INTO `favorites` VALUES (22, 1, 296, '2025-07-10 01:30:37');
INSERT INTO `favorites` VALUES (23, 25, 2, '2025-07-10 01:30:47');
INSERT INTO `favorites` VALUES (24, 25, 4, '2025-07-10 01:30:52');
INSERT INTO `favorites` VALUES (25, 25, 3, '2025-07-10 01:30:55');
INSERT INTO `favorites` VALUES (26, 28, 2, '2025-07-10 09:30:41');
INSERT INTO `favorites` VALUES (27, 25, 5, '2025-07-10 11:28:56');

-- ----------------------------
-- Table structure for pet_breeds
-- ----------------------------
DROP TABLE IF EXISTS `pet_breeds`;
CREATE TABLE `pet_breeds`  (
  `breed_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '品种ID',
  `breed_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '品种名称',
  `category_id` int(11) NOT NULL COMMENT '所属分类ID',
  `origin` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '原产地',
  `life_span` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '平均寿命',
  `temperament` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '性格特点',
  `care_level` enum('LOW','MEDIUM','HIGH') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '照顾难度',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '品种描述',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `search_keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品种搜索关键词（逗号分隔）',
  PRIMARY KEY (`breed_id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  CONSTRAINT `pet_breeds_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `pet_categories` (`category_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pet_breeds
-- ----------------------------
INSERT INTO `pet_breeds` VALUES (1, '缅因猫', 1, '欧洲', '12', '性格温顺', 'HIGH', '十分可爱', '2025-07-16 20:24:45', '1');
INSERT INTO `pet_breeds` VALUES (3, '中华田园猫', 1, '中国', '12-18年', '温顺、独立', 'HIGH', '中华田园猫是中国本土的猫种，性格温顺，适应能力强。', '2025-07-07 13:35:58', '中华田园猫,土猫,家猫');
INSERT INTO `pet_breeds` VALUES (4, '中华田园猫', 4, '中国', '5', '聪明', 'MEDIUM', '1', '2025-07-07 13:38:34', '中华田园猫');

-- ----------------------------
-- Table structure for pet_categories
-- ----------------------------
DROP TABLE IF EXISTS `pet_categories`;
CREATE TABLE `pet_categories`  (
  `category_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `slug` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'URL友好名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '分类描述',
  `icon_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类图标',
  `display_order` int(11) NULL DEFAULT 0 COMMENT '显示顺序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `crawler_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '爬虫分类标识（如dogs/cats）',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `slug`(`slug`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pet_categories
-- ----------------------------
INSERT INTO `pet_categories` VALUES (1, '缅因猫', '小猫', '猫', '1', 1, '2025-07-30 20:21:48', NULL);
INSERT INTO `pet_categories` VALUES (2, '狸花猫', '小猫咪', '猫', '2', 1, '2025-07-31 08:39:54', NULL);
INSERT INTO `pet_categories` VALUES (3, '狗狗', 'dogs', NULL, NULL, 0, '2025-07-02 17:20:26', 'dogs');
INSERT INTO `pet_categories` VALUES (4, '猫咪', 'cats', NULL, NULL, 0, '2025-07-02 17:20:26', 'cats');
INSERT INTO `pet_categories` VALUES (5, '小型宠物', 'small-pets', NULL, NULL, 0, '2025-07-02 17:20:26', 'small_pets');
INSERT INTO `pet_categories` VALUES (6, '水族', 'aquarium', NULL, NULL, 0, '2025-07-02 17:20:26', 'aquarium');
INSERT INTO `pet_categories` VALUES (7, '爬宠', 'reptiles', NULL, NULL, 0, '2025-07-02 17:20:26', 'reptiles');
INSERT INTO `pet_categories` VALUES (8, '兔子', '3', '蹦蹦跳跳', '', 2, '2025-07-06 21:38:12', NULL);
INSERT INTO `pet_categories` VALUES (9, '小兔子', '4', '1', '', 3, '2025-07-06 22:11:35', NULL);

-- ----------------------------
-- Table structure for pet_images
-- ----------------------------
DROP TABLE IF EXISTS `pet_images`;
CREATE TABLE `pet_images`  (
  `image_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `pet_id` bigint(20) NOT NULL COMMENT '宠物ID',
  `image_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '图片URL',
  `is_primary` tinyint(1) NULL DEFAULT 0 COMMENT '是否主图',
  `display_order` int(11) NULL DEFAULT 0 COMMENT '显示顺序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`image_id`) USING BTREE,
  INDEX `pet_id`(`pet_id`) USING BTREE,
  CONSTRAINT `pet_images_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 299 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pet_images
-- ----------------------------
INSERT INTO `pet_images` VALUES (1, 2, 'http://img.boqiicdn.com/Data/BK/P/imagick60561542248761.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (2, 3, 'http://img.boqiicdn.com/Data/BK/P/imagick60751542248890.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (3, 4, 'http://img.boqiicdn.com/Data/BK/P/imagick44291542249057.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (4, 5, 'http://img.boqiicdn.com/Data/BK/P/imagick53981542249264.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (5, 6, 'http://img.boqiicdn.com/Data/BK/P/imagick13791542249182.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (6, 7, 'http://img.boqiicdn.com/Data/BK/P/imagick29241542249333.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (8, 9, 'http://img.boqiicdn.com/Data/BK/P/imagick4741542249611.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (9, 10, 'http://img.boqiicdn.com/Data/BK/P/imagick95081542249498.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (10, 11, 'http://img.boqiicdn.com/Data/BK/P/imagick54971542249698.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (11, 12, 'http://img.boqiicdn.com/Data/BK/P/imagick5801542249763.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (12, 13, 'http://img.boqiicdn.com/Data/BK/P/imagick63811547195261.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (13, 14, 'http://img.boqiicdn.com/Data/BK/P/img89081406193390.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (14, 15, 'http://img.boqiicdn.com/Data/BK/P/img92251406107429.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (15, 16, 'http://img.boqiicdn.com/Data/BK/P/img99961410946559.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (16, 17, 'http://img.boqiicdn.com/Data/BK/P/img49891406109364.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (17, 18, 'http://img.boqiicdn.com/Data/BK/P/img43731405667543.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (18, 19, 'http://img.boqiicdn.com/Data/BK/P/img81471406191314.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (19, 20, 'http://img.boqiicdn.com/Data/BK/P/imagick12791473240420.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (20, 21, 'http://img.boqiicdn.com/Data/BK/P/img33571405663401.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (21, 22, 'http://img.boqiicdn.com/Data/BK/P/img21021406195580.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (22, 23, 'http://img.boqiicdn.com/Data/BK/P/img72201406106623.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (23, 24, 'http://img.boqiicdn.com/Data/BK/P/img43261406194638.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (24, 25, 'http://img.boqiicdn.com/Data/BK/P/img70661405933355.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (25, 26, 'http://img.boqiicdn.com/Data/BK/P/img81481405673729.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (26, 27, 'http://img.boqiicdn.com/Data/BK/P/img44591410944462.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (27, 28, 'http://img.boqiicdn.com/Data/BK/P/img13171406105650.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (28, 29, 'http://img.boqiicdn.com/Data/BK/P/img43941405671164.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (29, 30, 'http://img.boqiicdn.com/Data/BK/P/imagick67191497233207.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (30, 31, 'http://img.boqiicdn.com/Data/BK/P/img25631405668906.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (31, 32, 'http://img.boqiicdn.com/Data/BK/P/imagick64591541411807.png', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (32, 33, 'http://img.boqiicdn.com/Data/BK/P/imagick46441541413367.png', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (33, 34, 'http://img.boqiicdn.com/Data/BK/P/imagick67471541414025.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (34, 35, 'http://img.boqiicdn.com/Data/BK/P/imagick15371541412980.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (35, 36, 'http://img.boqiicdn.com/Data/BK/P/imagick93341541495659.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (36, 37, 'http://img.boqiicdn.com/Data/BK/P/imagick20371541414110.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (37, 38, 'http://img.boqiicdn.com/Data/BK/P/imagick83561541495798.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (38, 39, 'http://img.boqiicdn.com/Data/BK/P/imagick34901541497010.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (39, 40, 'http://img.boqiicdn.com/Data/BK/P/imagick29091541496916.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (40, 41, 'http://img.boqiicdn.com/Data/BK/P/imagick15731541496308.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (41, 42, 'http://img.boqiicdn.com/Data/BK/P/imagick27091541498387.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (42, 43, 'http://img.boqiicdn.com/Data/BK/P/imagick441541497241.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (43, 44, 'http://img.boqiicdn.com/Data/BK/P/img5701405934288.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (44, 45, 'http://img.boqiicdn.com/Data/BK/P/imagick61981541497494.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (45, 46, 'http://img.boqiicdn.com/Data/BK/P/imagick85871541497947.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (46, 47, 'http://img.boqiicdn.com/Data/BK/P/imagick3061541499071.png', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (47, 48, 'http://img.boqiicdn.com/Data/BK/P/imagick72451541500015.png', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (48, 49, 'http://img.boqiicdn.com/Data/BK/P/imagick89961541498200.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (49, 50, 'http://img.boqiicdn.com/Data/BK/P/imagick74411547023178.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (50, 51, 'http://img.boqiicdn.com/Data/BK/P/imagick80151541498264.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (51, 52, 'http://img.boqiicdn.com/Data/BK/P/imagick24861547197907.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (52, 53, 'http://img.boqiicdn.com/Data/BK/P/imagick70951541500848.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (53, 54, 'http://img.boqiicdn.com/Data/BK/P/imagick52861547197983.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (54, 55, 'http://img.boqiicdn.com/Data/BK/P/img82231406278696.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (55, 56, 'http://img.boqiicdn.com/Data/BK/P/imagick79091541499387.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (56, 57, 'http://img.boqiicdn.com/Data/BK/P/imagick64901547022959.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (57, 58, 'http://img.boqiicdn.com/Data/BK/P/img71491406281213.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (58, 59, 'http://img.boqiicdn.com/Data/BK/P/imagick98661547021225.png', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (59, 60, 'http://img.boqiicdn.com/Data/BK/P/imagick30481541501035.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (60, 61, 'http://img.boqiicdn.com/Data/BK/P/img68761406886049.jpg', 1, 0, '2025-07-02 08:54:07');
INSERT INTO `pet_images` VALUES (61, 62, 'http://img.boqiicdn.com/Data/BK/P/imagick60561542248761.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (62, 63, 'http://img.boqiicdn.com/Data/BK/P/imagick60751542248890.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (63, 64, 'http://img.boqiicdn.com/Data/BK/P/imagick44291542249057.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (64, 65, 'http://img.boqiicdn.com/Data/BK/P/imagick53981542249264.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (65, 66, 'http://img.boqiicdn.com/Data/BK/P/imagick13791542249182.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (66, 67, 'http://img.boqiicdn.com/Data/BK/P/imagick29241542249333.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (67, 68, 'http://img.boqiicdn.com/Data/BK/P/imagick43321542249438.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (68, 69, 'http://img.boqiicdn.com/Data/BK/P/imagick4741542249611.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (69, 70, 'http://img.boqiicdn.com/Data/BK/P/imagick95081542249498.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (70, 71, 'http://img.boqiicdn.com/Data/BK/P/imagick54971542249698.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (71, 72, 'http://img.boqiicdn.com/Data/BK/P/imagick5801542249763.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (72, 73, 'http://img.boqiicdn.com/Data/BK/P/imagick63811547195261.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (73, 74, 'http://img.boqiicdn.com/Data/BK/P/img89081406193390.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (74, 75, 'http://img.boqiicdn.com/Data/BK/P/img92251406107429.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (75, 76, 'http://img.boqiicdn.com/Data/BK/P/img99961410946559.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (76, 77, 'http://img.boqiicdn.com/Data/BK/P/img49891406109364.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (77, 78, 'http://img.boqiicdn.com/Data/BK/P/img43731405667543.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (78, 79, 'http://img.boqiicdn.com/Data/BK/P/img81471406191314.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (79, 80, 'http://img.boqiicdn.com/Data/BK/P/imagick12791473240420.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (80, 81, 'http://img.boqiicdn.com/Data/BK/P/img33571405663401.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (81, 82, 'http://img.boqiicdn.com/Data/BK/P/img21021406195580.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (82, 83, 'http://img.boqiicdn.com/Data/BK/P/img72201406106623.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (83, 84, 'http://img.boqiicdn.com/Data/BK/P/img43261406194638.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (84, 85, 'http://img.boqiicdn.com/Data/BK/P/img70661405933355.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (85, 86, 'http://img.boqiicdn.com/Data/BK/P/img81481405673729.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (86, 87, 'http://img.boqiicdn.com/Data/BK/P/img44591410944462.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (87, 88, 'http://img.boqiicdn.com/Data/BK/P/img13171406105650.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (88, 89, 'http://img.boqiicdn.com/Data/BK/P/img43941405671164.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (89, 90, 'http://img.boqiicdn.com/Data/BK/P/imagick67191497233207.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (90, 91, 'http://img.boqiicdn.com/Data/BK/P/img25631405668906.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (91, 92, 'http://img.boqiicdn.com/Data/BK/P/imagick64591541411807.png', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (92, 93, 'http://img.boqiicdn.com/Data/BK/P/imagick46441541413367.png', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (93, 94, 'http://img.boqiicdn.com/Data/BK/P/imagick67471541414025.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (94, 95, 'http://img.boqiicdn.com/Data/BK/P/imagick15371541412980.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (95, 96, 'http://img.boqiicdn.com/Data/BK/P/imagick93341541495659.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (96, 97, 'http://img.boqiicdn.com/Data/BK/P/imagick20371541414110.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (97, 98, 'http://img.boqiicdn.com/Data/BK/P/imagick83561541495798.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (98, 99, 'http://img.boqiicdn.com/Data/BK/P/imagick34901541497010.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (99, 100, 'http://img.boqiicdn.com/Data/BK/P/imagick29091541496916.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (100, 101, 'http://img.boqiicdn.com/Data/BK/P/imagick15731541496308.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (101, 102, 'http://img.boqiicdn.com/Data/BK/P/imagick27091541498387.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (102, 103, 'http://img.boqiicdn.com/Data/BK/P/imagick441541497241.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (103, 104, 'http://img.boqiicdn.com/Data/BK/P/img5701405934288.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (104, 105, 'http://img.boqiicdn.com/Data/BK/P/imagick61981541497494.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (105, 106, 'http://img.boqiicdn.com/Data/BK/P/imagick85871541497947.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (106, 107, 'http://img.boqiicdn.com/Data/BK/P/imagick3061541499071.png', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (107, 108, 'http://img.boqiicdn.com/Data/BK/P/imagick72451541500015.png', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (108, 109, 'http://img.boqiicdn.com/Data/BK/P/imagick89961541498200.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (109, 110, 'http://img.boqiicdn.com/Data/BK/P/imagick74411547023178.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (110, 111, 'http://img.boqiicdn.com/Data/BK/P/imagick80151541498264.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (111, 112, 'http://img.boqiicdn.com/Data/BK/P/imagick24861547197907.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (112, 113, 'http://img.boqiicdn.com/Data/BK/P/imagick70951541500848.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (113, 114, 'http://img.boqiicdn.com/Data/BK/P/imagick52861547197983.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (114, 115, 'http://img.boqiicdn.com/Data/BK/P/img82231406278696.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (115, 116, 'http://img.boqiicdn.com/Data/BK/P/imagick79091541499387.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (116, 117, 'http://img.boqiicdn.com/Data/BK/P/imagick64901547022959.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (117, 118, 'http://img.boqiicdn.com/Data/BK/P/img71491406281213.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (118, 119, 'http://img.boqiicdn.com/Data/BK/P/imagick98661547021225.png', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (119, 120, 'http://img.boqiicdn.com/Data/BK/P/imagick30481541501035.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (120, 121, 'http://img.boqiicdn.com/Data/BK/P/img68761406886049.jpg', 1, 0, '2025-07-02 08:55:29');
INSERT INTO `pet_images` VALUES (121, 122, 'http://img.boqiicdn.com/Data/BK/P/imagick60561542248761.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (122, 123, 'http://img.boqiicdn.com/Data/BK/P/imagick60751542248890.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (123, 124, 'http://img.boqiicdn.com/Data/BK/P/imagick44291542249057.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (124, 125, 'http://img.boqiicdn.com/Data/BK/P/imagick53981542249264.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (125, 126, 'http://img.boqiicdn.com/Data/BK/P/imagick13791542249182.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (126, 127, 'http://img.boqiicdn.com/Data/BK/P/imagick29241542249333.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (127, 128, 'http://img.boqiicdn.com/Data/BK/P/imagick43321542249438.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (128, 129, 'http://img.boqiicdn.com/Data/BK/P/imagick4741542249611.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (129, 130, 'http://img.boqiicdn.com/Data/BK/P/imagick95081542249498.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (130, 131, 'http://img.boqiicdn.com/Data/BK/P/imagick54971542249698.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (131, 132, 'http://img.boqiicdn.com/Data/BK/P/imagick5801542249763.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (132, 133, 'http://img.boqiicdn.com/Data/BK/P/imagick63811547195261.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (133, 134, 'http://img.boqiicdn.com/Data/BK/P/img89081406193390.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (134, 135, 'http://img.boqiicdn.com/Data/BK/P/img92251406107429.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (135, 136, 'http://img.boqiicdn.com/Data/BK/P/img99961410946559.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (136, 137, 'http://img.boqiicdn.com/Data/BK/P/img49891406109364.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (137, 138, 'http://img.boqiicdn.com/Data/BK/P/img43731405667543.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (138, 139, 'http://img.boqiicdn.com/Data/BK/P/img81471406191314.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (139, 140, 'http://img.boqiicdn.com/Data/BK/P/imagick12791473240420.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (140, 141, 'http://img.boqiicdn.com/Data/BK/P/img33571405663401.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (141, 142, 'http://img.boqiicdn.com/Data/BK/P/img21021406195580.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (142, 143, 'http://img.boqiicdn.com/Data/BK/P/img72201406106623.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (143, 144, 'http://img.boqiicdn.com/Data/BK/P/img43261406194638.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (144, 145, 'http://img.boqiicdn.com/Data/BK/P/img70661405933355.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (145, 146, 'http://img.boqiicdn.com/Data/BK/P/img81481405673729.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (146, 147, 'http://img.boqiicdn.com/Data/BK/P/img44591410944462.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (147, 148, 'http://img.boqiicdn.com/Data/BK/P/img13171406105650.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (148, 149, 'http://img.boqiicdn.com/Data/BK/P/img43941405671164.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (149, 150, 'http://img.boqiicdn.com/Data/BK/P/imagick67191497233207.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (150, 151, 'http://img.boqiicdn.com/Data/BK/P/img25631405668906.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (151, 152, 'http://img.boqiicdn.com/Data/BK/P/imagick64591541411807.png', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (152, 153, 'http://img.boqiicdn.com/Data/BK/P/imagick46441541413367.png', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (153, 154, 'http://img.boqiicdn.com/Data/BK/P/imagick67471541414025.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (154, 155, 'http://img.boqiicdn.com/Data/BK/P/imagick15371541412980.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (155, 156, 'http://img.boqiicdn.com/Data/BK/P/imagick93341541495659.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (156, 157, 'http://img.boqiicdn.com/Data/BK/P/imagick20371541414110.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (157, 158, 'http://img.boqiicdn.com/Data/BK/P/imagick83561541495798.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (158, 159, 'http://img.boqiicdn.com/Data/BK/P/imagick34901541497010.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (159, 160, 'http://img.boqiicdn.com/Data/BK/P/imagick29091541496916.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (160, 161, 'http://img.boqiicdn.com/Data/BK/P/imagick15731541496308.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (161, 162, 'http://img.boqiicdn.com/Data/BK/P/imagick27091541498387.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (162, 163, 'http://img.boqiicdn.com/Data/BK/P/imagick441541497241.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (163, 164, 'http://img.boqiicdn.com/Data/BK/P/img5701405934288.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (164, 165, 'http://img.boqiicdn.com/Data/BK/P/imagick61981541497494.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (165, 166, 'http://img.boqiicdn.com/Data/BK/P/imagick85871541497947.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (166, 167, 'http://img.boqiicdn.com/Data/BK/P/imagick3061541499071.png', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (167, 168, 'http://img.boqiicdn.com/Data/BK/P/imagick72451541500015.png', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (168, 169, 'http://img.boqiicdn.com/Data/BK/P/imagick89961541498200.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (169, 170, 'http://img.boqiicdn.com/Data/BK/P/imagick74411547023178.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (170, 171, 'http://img.boqiicdn.com/Data/BK/P/imagick80151541498264.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (171, 172, 'http://img.boqiicdn.com/Data/BK/P/imagick24861547197907.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (172, 173, 'http://img.boqiicdn.com/Data/BK/P/imagick70951541500848.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (173, 174, 'http://img.boqiicdn.com/Data/BK/P/imagick52861547197983.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (174, 175, 'http://img.boqiicdn.com/Data/BK/P/img82231406278696.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (175, 176, 'http://img.boqiicdn.com/Data/BK/P/imagick79091541499387.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (176, 177, 'http://img.boqiicdn.com/Data/BK/P/imagick64901547022959.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (177, 178, 'http://img.boqiicdn.com/Data/BK/P/img71491406281213.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (178, 179, 'http://img.boqiicdn.com/Data/BK/P/imagick98661547021225.png', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (179, 180, 'http://img.boqiicdn.com/Data/BK/P/imagick30481541501035.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (180, 181, 'http://img.boqiicdn.com/Data/BK/P/img68761406886049.jpg', 1, 0, '2025-07-02 08:56:21');
INSERT INTO `pet_images` VALUES (181, 182, 'http://img.boqiicdn.com/Data/BK/P/imagick60561542248761.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (182, 183, 'http://img.boqiicdn.com/Data/BK/P/imagick60751542248890.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (183, 184, 'http://img.boqiicdn.com/Data/BK/P/imagick44291542249057.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (184, 185, 'http://img.boqiicdn.com/Data/BK/P/imagick53981542249264.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (185, 186, 'http://img.boqiicdn.com/Data/BK/P/imagick13791542249182.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (186, 187, 'http://img.boqiicdn.com/Data/BK/P/imagick29241542249333.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (187, 188, 'http://img.boqiicdn.com/Data/BK/P/imagick43321542249438.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (188, 189, 'http://img.boqiicdn.com/Data/BK/P/imagick4741542249611.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (189, 190, 'http://img.boqiicdn.com/Data/BK/P/imagick95081542249498.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (190, 191, 'http://img.boqiicdn.com/Data/BK/P/imagick54971542249698.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (191, 192, 'http://img.boqiicdn.com/Data/BK/P/imagick5801542249763.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (192, 193, 'http://img.boqiicdn.com/Data/BK/P/imagick63811547195261.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (193, 194, 'http://img.boqiicdn.com/Data/BK/P/img89081406193390.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (194, 195, 'http://img.boqiicdn.com/Data/BK/P/img92251406107429.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (195, 196, 'http://img.boqiicdn.com/Data/BK/P/img99961410946559.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (196, 197, 'http://img.boqiicdn.com/Data/BK/P/img49891406109364.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (197, 198, 'http://img.boqiicdn.com/Data/BK/P/img43731405667543.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (198, 199, 'http://img.boqiicdn.com/Data/BK/P/img81471406191314.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (199, 200, 'http://img.boqiicdn.com/Data/BK/P/imagick12791473240420.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (200, 201, 'http://img.boqiicdn.com/Data/BK/P/img33571405663401.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (201, 202, 'http://img.boqiicdn.com/Data/BK/P/img21021406195580.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (202, 203, 'http://img.boqiicdn.com/Data/BK/P/img72201406106623.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (203, 204, 'http://img.boqiicdn.com/Data/BK/P/img43261406194638.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (204, 205, 'http://img.boqiicdn.com/Data/BK/P/img70661405933355.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (205, 206, 'http://img.boqiicdn.com/Data/BK/P/img81481405673729.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (206, 207, 'http://img.boqiicdn.com/Data/BK/P/img44591410944462.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (207, 208, 'http://img.boqiicdn.com/Data/BK/P/img13171406105650.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (208, 209, 'http://img.boqiicdn.com/Data/BK/P/img43941405671164.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (209, 210, 'http://img.boqiicdn.com/Data/BK/P/imagick67191497233207.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (210, 211, 'http://img.boqiicdn.com/Data/BK/P/img25631405668906.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (211, 212, 'http://img.boqiicdn.com/Data/BK/P/imagick64591541411807.png', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (212, 213, 'http://img.boqiicdn.com/Data/BK/P/imagick46441541413367.png', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (213, 214, 'http://img.boqiicdn.com/Data/BK/P/imagick67471541414025.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (214, 215, 'http://img.boqiicdn.com/Data/BK/P/imagick15371541412980.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (215, 216, 'http://img.boqiicdn.com/Data/BK/P/imagick93341541495659.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (216, 217, 'http://img.boqiicdn.com/Data/BK/P/imagick20371541414110.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (217, 218, 'http://img.boqiicdn.com/Data/BK/P/imagick83561541495798.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (218, 219, 'http://img.boqiicdn.com/Data/BK/P/imagick34901541497010.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (219, 220, 'http://img.boqiicdn.com/Data/BK/P/imagick29091541496916.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (220, 221, 'http://img.boqiicdn.com/Data/BK/P/imagick15731541496308.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (221, 222, 'http://img.boqiicdn.com/Data/BK/P/imagick27091541498387.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (222, 223, 'http://img.boqiicdn.com/Data/BK/P/imagick441541497241.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (223, 224, 'http://img.boqiicdn.com/Data/BK/P/img5701405934288.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (224, 225, 'http://img.boqiicdn.com/Data/BK/P/imagick61981541497494.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (225, 226, 'http://img.boqiicdn.com/Data/BK/P/imagick85871541497947.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (226, 227, 'http://img.boqiicdn.com/Data/BK/P/imagick3061541499071.png', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (227, 228, 'http://img.boqiicdn.com/Data/BK/P/imagick72451541500015.png', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (228, 229, 'http://img.boqiicdn.com/Data/BK/P/imagick89961541498200.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (229, 230, 'http://img.boqiicdn.com/Data/BK/P/imagick74411547023178.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (230, 231, 'http://img.boqiicdn.com/Data/BK/P/imagick80151541498264.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (231, 232, 'http://img.boqiicdn.com/Data/BK/P/imagick24861547197907.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (232, 233, 'http://img.boqiicdn.com/Data/BK/P/imagick70951541500848.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (233, 234, 'http://img.boqiicdn.com/Data/BK/P/imagick52861547197983.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (234, 235, 'http://img.boqiicdn.com/Data/BK/P/img82231406278696.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (235, 236, 'http://img.boqiicdn.com/Data/BK/P/imagick79091541499387.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (236, 237, 'http://img.boqiicdn.com/Data/BK/P/imagick64901547022959.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (237, 238, 'http://img.boqiicdn.com/Data/BK/P/img71491406281213.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (238, 239, 'http://img.boqiicdn.com/Data/BK/P/imagick98661547021225.png', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (239, 240, 'http://img.boqiicdn.com/Data/BK/P/imagick30481541501035.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (240, 241, 'http://img.boqiicdn.com/Data/BK/P/img68761406886049.jpg', 1, 0, '2025-07-02 08:59:11');
INSERT INTO `pet_images` VALUES (241, 242, 'http://img.boqiicdn.com/Data/BK/P/imagick60561542248761.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (242, 243, 'http://img.boqiicdn.com/Data/BK/P/imagick60751542248890.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (243, 244, 'http://img.boqiicdn.com/Data/BK/P/imagick44291542249057.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (244, 245, 'http://img.boqiicdn.com/Data/BK/P/imagick53981542249264.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (245, 246, 'http://img.boqiicdn.com/Data/BK/P/imagick13791542249182.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (246, 247, 'http://img.boqiicdn.com/Data/BK/P/imagick29241542249333.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (247, 248, 'http://img.boqiicdn.com/Data/BK/P/imagick43321542249438.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (248, 249, 'http://img.boqiicdn.com/Data/BK/P/imagick4741542249611.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (249, 250, 'http://img.boqiicdn.com/Data/BK/P/imagick95081542249498.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (250, 251, 'http://img.boqiicdn.com/Data/BK/P/imagick54971542249698.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (251, 252, 'http://img.boqiicdn.com/Data/BK/P/imagick5801542249763.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (252, 253, 'http://img.boqiicdn.com/Data/BK/P/imagick63811547195261.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (253, 254, 'http://img.boqiicdn.com/Data/BK/P/img89081406193390.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (254, 255, 'http://img.boqiicdn.com/Data/BK/P/img92251406107429.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (255, 256, 'http://img.boqiicdn.com/Data/BK/P/img99961410946559.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (256, 257, 'http://img.boqiicdn.com/Data/BK/P/img49891406109364.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (257, 258, 'http://img.boqiicdn.com/Data/BK/P/img43731405667543.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (258, 259, 'http://img.boqiicdn.com/Data/BK/P/img81471406191314.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (259, 260, 'http://img.boqiicdn.com/Data/BK/P/imagick12791473240420.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (260, 261, 'http://img.boqiicdn.com/Data/BK/P/img33571405663401.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (261, 262, 'http://img.boqiicdn.com/Data/BK/P/img21021406195580.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (262, 263, 'http://img.boqiicdn.com/Data/BK/P/img72201406106623.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (263, 264, 'http://img.boqiicdn.com/Data/BK/P/img43261406194638.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (264, 265, 'http://img.boqiicdn.com/Data/BK/P/img70661405933355.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (265, 266, 'http://img.boqiicdn.com/Data/BK/P/img81481405673729.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (266, 267, 'http://img.boqiicdn.com/Data/BK/P/img44591410944462.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (267, 268, 'http://img.boqiicdn.com/Data/BK/P/img13171406105650.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (268, 269, 'http://img.boqiicdn.com/Data/BK/P/img43941405671164.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (269, 270, 'http://img.boqiicdn.com/Data/BK/P/imagick67191497233207.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (270, 271, 'http://img.boqiicdn.com/Data/BK/P/img25631405668906.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (271, 272, 'http://img.boqiicdn.com/Data/BK/P/imagick64591541411807.png', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (272, 273, 'http://img.boqiicdn.com/Data/BK/P/imagick46441541413367.png', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (273, 274, 'http://img.boqiicdn.com/Data/BK/P/imagick67471541414025.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (274, 275, 'http://img.boqiicdn.com/Data/BK/P/imagick15371541412980.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (275, 276, 'http://img.boqiicdn.com/Data/BK/P/imagick93341541495659.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (276, 277, 'http://img.boqiicdn.com/Data/BK/P/imagick20371541414110.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (277, 278, 'http://img.boqiicdn.com/Data/BK/P/imagick83561541495798.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (278, 279, 'http://img.boqiicdn.com/Data/BK/P/imagick34901541497010.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (279, 280, 'http://img.boqiicdn.com/Data/BK/P/imagick29091541496916.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (280, 281, 'http://img.boqiicdn.com/Data/BK/P/imagick15731541496308.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (281, 282, 'http://img.boqiicdn.com/Data/BK/P/imagick27091541498387.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (282, 283, 'http://img.boqiicdn.com/Data/BK/P/imagick441541497241.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (283, 284, 'http://img.boqiicdn.com/Data/BK/P/img5701405934288.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (284, 285, 'http://img.boqiicdn.com/Data/BK/P/imagick61981541497494.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (285, 286, 'http://img.boqiicdn.com/Data/BK/P/imagick85871541497947.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (286, 287, 'http://img.boqiicdn.com/Data/BK/P/imagick3061541499071.png', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (287, 288, 'http://img.boqiicdn.com/Data/BK/P/imagick72451541500015.png', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (288, 289, 'http://img.boqiicdn.com/Data/BK/P/imagick89961541498200.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (289, 290, 'http://img.boqiicdn.com/Data/BK/P/imagick74411547023178.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (290, 291, 'http://img.boqiicdn.com/Data/BK/P/imagick80151541498264.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (291, 292, 'http://img.boqiicdn.com/Data/BK/P/imagick24861547197907.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (292, 293, 'http://img.boqiicdn.com/Data/BK/P/imagick70951541500848.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (293, 294, 'http://img.boqiicdn.com/Data/BK/P/imagick52861547197983.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (294, 295, 'http://img.boqiicdn.com/Data/BK/P/img82231406278696.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (295, 296, 'http://img.boqiicdn.com/Data/BK/P/imagick79091541499387.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (296, 297, 'http://img.boqiicdn.com/Data/BK/P/imagick64901547022959.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (297, 298, 'http://img.boqiicdn.com/Data/BK/P/img71491406281213.jpg', 1, 0, '2025-07-02 12:59:51');
INSERT INTO `pet_images` VALUES (298, 299, 'http://img.boqiicdn.com/Data/BK/P/imagick98661547021225.png', 1, 0, '2025-07-02 12:59:51');

-- ----------------------------
-- Table structure for pet_tags
-- ----------------------------
DROP TABLE IF EXISTS `pet_tags`;
CREATE TABLE `pet_tags`  (
  `pet_id` bigint(20) NOT NULL COMMENT '宠物ID',
  `tag_id` int(11) NOT NULL COMMENT '标签ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`pet_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id`) USING BTREE,
  CONSTRAINT `pet_tags_ibfk_1` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`pet_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `pet_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pet_tags
-- ----------------------------
INSERT INTO `pet_tags` VALUES (303, 5, '2025-07-08 13:58:04');

-- ----------------------------
-- Table structure for pets
-- ----------------------------
DROP TABLE IF EXISTS `pets`;
CREATE TABLE `pets`  (
  `pet_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '宠物ID',
  `breed_id` int(11) NULL DEFAULT NULL COMMENT '品种ID',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '宠物名字',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄(月)',
  `gender` enum('MALE','FEMALE','UNKNOWN') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `color` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '颜色',
  `size` enum('SMALL','MEDIUM','LARGE') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '体型',
  `health_status` enum('EXCELLENT','GOOD','FAIR','POOR') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '健康状况',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '详细描述',
  `story` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '背景故事',
  `status` enum('AVAILABLE','PENDING','ADOPTED','UNAVAILABLE') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'AVAILABLE' COMMENT '领养状态',
  `source` enum('SHELTER','RESCUE','OWNER','CRAWLER') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源',
  `crawler_data_id` int(11) NULL DEFAULT NULL COMMENT '爬虫数据ID(关联爬取的数据)',
  `featured` tinyint(1) NULL DEFAULT 0 COMMENT '是否推荐',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览次数',
  PRIMARY KEY (`pet_id`) USING BTREE,
  INDEX `idx_pets_status`(`status`) USING BTREE,
  INDEX `idx_pets_breed`(`breed_id`) USING BTREE,
  CONSTRAINT `pets_ibfk_1` FOREIGN KEY (`breed_id`) REFERENCES `pet_breeds` (`breed_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 304 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pets
-- ----------------------------
INSERT INTO `pets` VALUES (2, 1, '布偶猫', NULL, 'MALE', '白色', 'SMALL', 'GOOD', '来源：http://www.boqii.com/\r\n原始链接：http://www.boqii.com/entry/detail/330.html', '', 'ADOPTED', NULL, NULL, NULL, NULL);
INSERT INTO `pets` VALUES (3, 1, '英国短毛猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/458.html', NULL, 'ADOPTED', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (4, 1, '中国狸花猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/461.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (5, 1, '美国短毛猫', NULL, 'FEMALE', '', 'SMALL', 'GOOD', '来源：http://www.boqii.com/\r\n原始链接：http://www.boqii.com/entry/detail/1390.html', '', 'AVAILABLE', NULL, NULL, NULL, NULL);
INSERT INTO `pets` VALUES (6, 1, '异国短毛猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/353.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (7, 1, '波斯猫', NULL, 'FEMALE', NULL, NULL, NULL, NULL, NULL, 'PENDING', NULL, NULL, NULL, NULL);
INSERT INTO `pets` VALUES (9, 1, '苏格兰折耳猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/343.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (10, 1, '加拿大无毛猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/423.html', NULL, 'PENDING', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (11, 1, '斯芬克斯猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/389.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (12, NULL, '俄罗斯蓝猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/416.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (13, NULL, '金吉拉', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/419.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (14, NULL, '西伯利亚森林猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/431.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (15, NULL, '山东狮子猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/412.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (16, NULL, '埃及猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/336.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (17, NULL, '卡尔特猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/422.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (18, NULL, '伯曼猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/356.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (19, NULL, '喜马拉雅猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/430.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (20, NULL, '中华田园猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2504.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (21, NULL, '阿比西尼亚猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/339.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (22, NULL, '土耳其梵猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/442.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (23, NULL, '塞尔凯克卷毛猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/409.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (24, NULL, '土耳其安哥拉猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/438.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (25, NULL, '日本短尾猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/376.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (26, NULL, '德文卷毛猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/370.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (27, NULL, '新加坡猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/349.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (28, NULL, '沙特尔猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/407.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (29, NULL, '波米拉猫', NULL, 'FEMALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/367.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (30, NULL, '孟加拉豹猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2513.html', NULL, 'ADOPTED', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (31, NULL, '巴厘猫', NULL, 'MALE', NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/361.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (32, NULL, '金毛', NULL, 'FEMALE', NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/332.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (33, NULL, '哈士奇', NULL, 'MALE', NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/357.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (34, NULL, '博美犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/347.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (35, NULL, '罗威纳犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/678.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (36, NULL, '比熊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/368.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (37, NULL, '阿拉斯加雪橇犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/609.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (38, NULL, '拉布拉多猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/677.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (39, NULL, '边境牧羊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/350.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (40, NULL, '柴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/613.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (41, NULL, '贵宾', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/340.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (42, NULL, '巴哥犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/634.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (43, NULL, '泰迪犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/425.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (44, NULL, '法老王猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/377.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (45, NULL, '杜宾犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/404.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (46, NULL, '法国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/383.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (47, NULL, '柯基犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/449.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (48, NULL, '秋田犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/485.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (49, NULL, '萨摩耶', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/426.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (50, NULL, '约克夏', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/337.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (51, NULL, '京巴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/630.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (52, NULL, '松狮', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/427.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (53, NULL, '吉娃娃', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/455.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (54, NULL, '藏獒', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/684.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (55, NULL, '蝴蝶犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/450.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (56, NULL, '惠比特犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/452.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (57, NULL, '比格犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/626.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (58, NULL, '杰克罗素梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/460.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (59, NULL, '英国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/439.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (60, NULL, '阿富汗猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/649.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (61, NULL, '迷你牛头梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/552.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (62, NULL, '布偶猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/330.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (63, NULL, '英国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/458.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (64, NULL, '中国狸花猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/461.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (65, NULL, '美国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/1390.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (66, NULL, '异国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/353.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (67, NULL, '波斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/364.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (68, NULL, '暹罗猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/359.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (69, NULL, '苏格兰折耳猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/343.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (70, NULL, '加拿大无毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/423.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (71, NULL, '斯芬克斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/389.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (72, NULL, '俄罗斯蓝猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/416.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (73, NULL, '金吉拉', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/419.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (74, NULL, '西伯利亚森林猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/431.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (75, NULL, '山东狮子猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/412.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (76, NULL, '埃及猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/336.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (77, NULL, '卡尔特猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/422.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (78, NULL, '伯曼猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/356.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (79, NULL, '喜马拉雅猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/430.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (80, NULL, '中华田园猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2504.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (81, NULL, '阿比西尼亚猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/339.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (82, NULL, '土耳其梵猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/442.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (83, NULL, '塞尔凯克卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/409.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (84, NULL, '土耳其安哥拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/438.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (85, NULL, '日本短尾猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/376.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (86, NULL, '德文卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/370.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (87, NULL, '新加坡猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/349.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (88, NULL, '沙特尔猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/407.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (89, NULL, '波米拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/367.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (90, NULL, '孟加拉豹猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2513.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (91, NULL, '巴厘猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/361.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (92, NULL, '金毛', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/332.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (93, NULL, '哈士奇', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/357.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (94, NULL, '博美犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/347.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (95, NULL, '罗威纳犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/678.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (96, NULL, '比熊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/368.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (97, NULL, '阿拉斯加雪橇犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/609.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (98, NULL, '拉布拉多猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/677.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (99, NULL, '边境牧羊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/350.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (100, NULL, '柴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/613.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (101, NULL, '贵宾', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/340.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (102, NULL, '巴哥犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/634.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (103, NULL, '泰迪犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/425.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (104, NULL, '法老王猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/377.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (105, NULL, '杜宾犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/404.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (106, NULL, '法国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/383.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (107, NULL, '柯基犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/449.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (108, NULL, '秋田犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/485.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (109, NULL, '萨摩耶', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/426.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (110, NULL, '约克夏', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/337.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (111, NULL, '京巴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/630.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (112, NULL, '松狮', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/427.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (113, NULL, '吉娃娃', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/455.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (114, NULL, '藏獒', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/684.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (115, NULL, '蝴蝶犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/450.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (116, NULL, '惠比特犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/452.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (117, NULL, '比格犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/626.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (118, NULL, '杰克罗素梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/460.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (119, NULL, '英国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/439.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (120, NULL, '阿富汗猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/649.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (121, NULL, '迷你牛头梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/552.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (122, NULL, '布偶猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/330.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (123, NULL, '英国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/458.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (124, NULL, '中国狸花猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/461.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (125, NULL, '美国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/1390.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (126, NULL, '异国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/353.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (127, NULL, '波斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/364.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (128, NULL, '暹罗猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/359.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (129, NULL, '苏格兰折耳猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/343.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (130, NULL, '加拿大无毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/423.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (131, NULL, '斯芬克斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/389.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (132, NULL, '俄罗斯蓝猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/416.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (133, NULL, '金吉拉', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/419.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (134, NULL, '西伯利亚森林猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/431.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (135, NULL, '山东狮子猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/412.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (136, NULL, '埃及猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/336.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (137, NULL, '卡尔特猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/422.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (138, NULL, '伯曼猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/356.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (139, NULL, '喜马拉雅猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/430.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (140, NULL, '中华田园猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2504.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (141, NULL, '阿比西尼亚猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/339.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (142, NULL, '土耳其梵猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/442.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (143, NULL, '塞尔凯克卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/409.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (144, NULL, '土耳其安哥拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/438.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (145, NULL, '日本短尾猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/376.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (146, NULL, '德文卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/370.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (147, NULL, '新加坡猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/349.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (148, NULL, '沙特尔猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/407.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (149, NULL, '波米拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/367.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (150, NULL, '孟加拉豹猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2513.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (151, NULL, '巴厘猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/361.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (152, NULL, '金毛', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/332.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (153, NULL, '哈士奇', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/357.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (154, NULL, '博美犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/347.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (155, NULL, '罗威纳犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/678.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (156, NULL, '比熊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/368.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (157, NULL, '阿拉斯加雪橇犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/609.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (158, NULL, '拉布拉多猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/677.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (159, NULL, '边境牧羊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/350.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (160, NULL, '柴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/613.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (161, NULL, '贵宾', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/340.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (162, NULL, '巴哥犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/634.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (163, NULL, '泰迪犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/425.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (164, NULL, '法老王猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/377.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (165, NULL, '杜宾犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/404.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (166, NULL, '法国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/383.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (167, NULL, '柯基犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/449.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (168, NULL, '秋田犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/485.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (169, NULL, '萨摩耶', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/426.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (170, NULL, '约克夏', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/337.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (171, NULL, '京巴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/630.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (172, NULL, '松狮', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/427.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (173, NULL, '吉娃娃', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/455.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (174, NULL, '藏獒', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/684.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (175, NULL, '蝴蝶犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/450.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (176, NULL, '惠比特犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/452.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (177, NULL, '比格犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/626.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (178, NULL, '杰克罗素梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/460.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (179, NULL, '英国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/439.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (180, NULL, '阿富汗猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/649.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (181, NULL, '迷你牛头梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/552.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (182, NULL, '布偶猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/330.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (183, NULL, '英国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/458.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (184, NULL, '中国狸花猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/461.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (185, NULL, '美国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/1390.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (186, NULL, '异国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/353.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (187, NULL, '波斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/364.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (188, NULL, '暹罗猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/359.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (189, NULL, '苏格兰折耳猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/343.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (190, NULL, '加拿大无毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/423.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (191, NULL, '斯芬克斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/389.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (192, NULL, '俄罗斯蓝猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/416.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (193, NULL, '金吉拉', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/419.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (194, NULL, '西伯利亚森林猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/431.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (195, NULL, '山东狮子猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/412.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (196, NULL, '埃及猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/336.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (197, NULL, '卡尔特猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/422.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (198, NULL, '伯曼猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/356.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (199, NULL, '喜马拉雅猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/430.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (200, NULL, '中华田园猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2504.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (201, NULL, '阿比西尼亚猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/339.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (202, NULL, '土耳其梵猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/442.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (203, NULL, '塞尔凯克卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/409.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (204, NULL, '土耳其安哥拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/438.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (205, NULL, '日本短尾猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/376.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (206, NULL, '德文卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/370.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (207, NULL, '新加坡猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/349.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (208, NULL, '沙特尔猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/407.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (209, NULL, '波米拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/367.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (210, NULL, '孟加拉豹猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2513.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (211, NULL, '巴厘猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/361.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (212, NULL, '金毛', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/332.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (213, NULL, '哈士奇', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/357.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (214, NULL, '博美犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/347.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (215, NULL, '罗威纳犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/678.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (216, NULL, '比熊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/368.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (217, NULL, '阿拉斯加雪橇犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/609.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (218, NULL, '拉布拉多猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/677.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (219, NULL, '边境牧羊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/350.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (220, NULL, '柴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/613.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (221, NULL, '贵宾', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/340.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (222, NULL, '巴哥犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/634.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (223, NULL, '泰迪犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/425.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (224, NULL, '法老王猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/377.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (225, NULL, '杜宾犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/404.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (226, NULL, '法国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/383.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (227, NULL, '柯基犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/449.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (228, NULL, '秋田犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/485.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (229, NULL, '萨摩耶', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/426.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (230, NULL, '约克夏', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/337.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (231, NULL, '京巴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/630.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (232, NULL, '松狮', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/427.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (233, NULL, '吉娃娃', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/455.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (234, NULL, '藏獒', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/684.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (235, NULL, '蝴蝶犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/450.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (236, NULL, '惠比特犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/452.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (237, NULL, '比格犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/626.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (238, NULL, '杰克罗素梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/460.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (239, NULL, '英国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/439.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (240, NULL, '阿富汗猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/649.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (241, NULL, '迷你牛头梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/552.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (242, NULL, '布偶猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/330.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (243, NULL, '英国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/458.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (244, NULL, '中国狸花猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/461.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (245, NULL, '美国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/1390.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (246, NULL, '异国短毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/353.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (247, NULL, '波斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/364.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (248, NULL, '暹罗猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/359.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (249, NULL, '苏格兰折耳猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/343.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (250, NULL, '加拿大无毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/423.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (251, NULL, '斯芬克斯猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/389.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (252, NULL, '俄罗斯蓝猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/416.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (253, NULL, '金吉拉', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/419.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (254, NULL, '西伯利亚森林猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/431.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (255, NULL, '山东狮子猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/412.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (256, NULL, '埃及猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/336.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (257, NULL, '卡尔特猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/422.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (258, NULL, '伯曼猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/356.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (259, NULL, '喜马拉雅猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/430.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (260, NULL, '中华田园猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2504.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (261, NULL, '阿比西尼亚猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/339.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (262, NULL, '土耳其梵猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/442.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (263, NULL, '塞尔凯克卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/409.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (264, NULL, '土耳其安哥拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/438.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (265, NULL, '日本短尾猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/376.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (266, NULL, '德文卷毛猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/370.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (267, NULL, '新加坡猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/349.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (268, NULL, '沙特尔猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/407.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (269, NULL, '波米拉猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/367.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (270, NULL, '孟加拉豹猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/2513.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (271, NULL, '巴厘猫', NULL, NULL, NULL, 'SMALL', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/361.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (272, NULL, '金毛', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/332.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (273, NULL, '哈士奇', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/357.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (274, NULL, '博美犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/347.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (275, NULL, '罗威纳犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/678.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (276, NULL, '比熊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/368.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (277, NULL, '阿拉斯加雪橇犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/609.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (278, NULL, '拉布拉多猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/677.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (279, NULL, '边境牧羊犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/350.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (280, NULL, '柴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/613.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (281, NULL, '贵宾', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/340.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (282, NULL, '巴哥犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/634.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (283, NULL, '泰迪犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/425.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (284, NULL, '法老王猎犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/377.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (285, NULL, '杜宾犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/404.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (286, NULL, '法国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/383.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (287, NULL, '柯基犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/449.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (288, NULL, '秋田犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/485.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (289, NULL, '萨摩耶', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/426.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (290, NULL, '约克夏', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/337.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (291, NULL, '京巴犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/630.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (292, NULL, '松狮', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/427.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (293, NULL, '吉娃娃', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/455.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (294, NULL, '藏獒', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/684.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (295, NULL, '蝴蝶犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/450.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (296, NULL, '惠比特犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/452.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (297, NULL, '比格犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/626.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (298, NULL, '杰克罗素梗', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/460.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (299, NULL, '英国斗牛犬', NULL, NULL, NULL, 'MEDIUM', 'GOOD', '来源：http://www.boqii.com/\n原始链接：http://www.boqii.com/entry/detail/439.html', NULL, 'AVAILABLE', 'CRAWLER', NULL, 0, 0);
INSERT INTO `pets` VALUES (301, 1, '大熊猫', 1, 'FEMALE', '白色', 'SMALL', 'EXCELLENT', '大熊猫', '大熊猫', 'PENDING', NULL, NULL, 0, 0);
INSERT INTO `pets` VALUES (302, 1, '布偶猫1', 1, 'MALE', '白色', 'SMALL', 'GOOD', '1', '1', 'AVAILABLE', NULL, NULL, 0, 0);
INSERT INTO `pets` VALUES (303, 3, '小王', NULL, 'FEMALE', '黄色', 'MEDIUM', 'EXCELLENT', '1', '1', 'AVAILABLE', NULL, NULL, 0, 0);

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags`  (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `slug` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'URL友好名称',
  `color` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签颜色',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE INDEX `slug`(`slug`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tags
-- ----------------------------
INSERT INTO `tags` VALUES (1, '小兔子', '兔子', '#000000', '2025-07-07 14:25:17');
INSERT INTO `tags` VALUES (3, '暴躁的', '5', '#ffc107', '2025-07-07 20:20:00');
INSERT INTO `tags` VALUES (5, '温柔', '6', '#dc3545', '2025-07-07 20:49:57');
INSERT INTO `tags` VALUES (6, '聪明', '2', '#780d0d', '2025-07-07 20:51:12');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '加密密码',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `role` enum('ADMIN','STAFF','USER') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'USER' COMMENT '角色',
  `status` enum('ACTIVE','INACTIVE','BANNED') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '123456', '123456', '123456@qq.com', '123456', '12345611', 'ADMIN', 'ACTIVE', '2025-06-30 10:35:27', '2025-07-05 23:34:16');
INSERT INTO `users` VALUES (14, 'daddawd1', '123456', '12323da1@qq.com', '1234323', '123234', 'USER', 'ACTIVE', '2025-06-27 19:59:53', '2025-07-02 21:09:27');
INSERT INTO `users` VALUES (18, '1234566', '123456', '1234567@qq.com', '21', '3', 'USER', 'ACTIVE', '2025-07-01 13:09:56', '2025-07-01 13:09:56');
INSERT INTO `users` VALUES (25, '1234561', '1234561', '12345617@qq.com', '15994539954', '3', 'USER', 'ACTIVE', '2025-07-01 13:15:43', '2025-07-01 13:15:43');
INSERT INTO `users` VALUES (26, '12345611111', '', '1234567@qq.com1', '159945399541', '3', 'USER', 'INACTIVE', '2025-07-02 17:52:35', '2025-07-09 08:49:06');
INSERT INTO `users` VALUES (27, '1234523111232123', '', '27744678771@qq.com', '15994539954', '12323', 'USER', 'ACTIVE', '2025-07-02 20:17:12', '2025-07-06 00:22:35');
INSERT INTO `users` VALUES (28, 'admin', 'admin', 'admin@qq.com', '15994539954', '3', 'ADMIN', 'ACTIVE', '2025-07-03 13:24:36', '2025-07-08 14:18:13');
INSERT INTO `users` VALUES (29, '1234561111', '123456', 'adm1n1@qq.com', '1599453919541', '311', 'USER', 'ACTIVE', '2025-07-05 23:29:28', '2025-07-05 23:29:28');
INSERT INTO `users` VALUES (30, '1', '1', '1@qq.com', '1', '1', 'USER', 'ACTIVE', '2025-07-08 15:15:35', '2025-07-08 15:15:35');
INSERT INTO `users` VALUES (31, '2', '2', '2@qq.com', '2', '2', 'USER', 'ACTIVE', '2025-07-08 15:26:45', '2025-07-08 15:26:45');
INSERT INTO `users` VALUES (32, '3', '12', '3@qq.com', '23', '23', 'USER', 'ACTIVE', '2025-07-08 15:27:18', '2025-07-08 15:27:18');
INSERT INTO `users` VALUES (33, '4', '4', '4@qq.com', '23', '23', 'USER', 'ACTIVE', '2025-07-08 15:27:38', '2025-07-08 15:27:38');
INSERT INTO `users` VALUES (34, '5', '5', '5@qq.com', '5', '5', 'USER', 'ACTIVE', '2025-07-08 15:31:05', '2025-07-08 15:31:05');
INSERT INTO `users` VALUES (35, '7', '7', '7@qq.com', '7', '7', 'USER', 'ACTIVE', '2025-07-08 15:35:30', '2025-07-08 15:35:30');
INSERT INTO `users` VALUES (36, '11', '11', '11@qq.com', '11', '1', 'USER', 'ACTIVE', '2025-07-08 15:46:59', '2025-07-08 15:46:59');
INSERT INTO `users` VALUES (37, '11211', '1', '1123@qq.com', '11', '1', 'USER', 'ACTIVE', '2025-07-08 17:00:44', '2025-07-08 17:00:44');
INSERT INTO `users` VALUES (38, '112112', '1', '11223@qq.com', '11', '1', 'USER', 'ACTIVE', '2025-07-08 19:29:08', '2025-07-08 19:29:08');

-- ----------------------------
-- Triggers structure for table users
-- ----------------------------
DROP TRIGGER IF EXISTS `update_users_timestamp`;
delimiter ;;
CREATE TRIGGER `update_users_timestamp` BEFORE UPDATE ON `users` FOR EACH ROW SET NEW.updated_at = NOW()
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
