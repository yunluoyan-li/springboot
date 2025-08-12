package com.example.petadoption.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PetCrawler {
    private static final Logger logger = LoggerFactory.getLogger(PetCrawler.class);

    private static final String BASE_URL = "http://www.boqii.com/";
    private static final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36";

    // 数据库配置
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pet_adoption_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    // 分类映射
    private static final Map<String, Map<String, String>> CATEGORY_MAPPING = new HashMap<>();
    static {
        Map<String, String> dogMap = new HashMap<>();
        dogMap.put("type", "狗");
        dogMap.put("size", "MEDIUM");
        dogMap.put("breed_hint", "犬");
        CATEGORY_MAPPING.put("dogs", dogMap);

        Map<String, String> catMap = new HashMap<>();
        catMap.put("type", "猫");
        catMap.put("size", "SMALL");
        catMap.put("breed_hint", "猫");
        CATEGORY_MAPPING.put("cats", catMap);
    }

    public static void main(String[] args) {
        try {
            logger.info("宠物爬虫开始运行...");
            long startTime = System.currentTimeMillis();

            // 验证数据库
            validateDatabase();

            // 爬取数据
            List<Pet> allPets = new ArrayList<>();
            for (String category : CATEGORY_MAPPING.keySet()) {
                List<Pet> pets = crawlCategory(category, 1); // 只爬取1页
                allPets.addAll(pets);
                logger.info("类别 {} 爬取完成，获得 {} 条数据", category, pets.size());
            }

            // 保存数据
            if (!allPets.isEmpty()) {
                int savedCount = saveToDatabase(allPets);
                logger.info("数据保存完成，成功保存 {}/{} 条记录", savedCount, allPets.size());
            }

            long endTime = System.currentTimeMillis();
            logger.info("爬虫运行完成，总耗时 {} 秒", (endTime - startTime) / 1000);
        } catch (Exception e) {
            logger.error("爬虫运行出错", e);
        }
    }

    private static void validateDatabase() throws SQLException {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet rs = meta.getTables(null, null, "pets", new String[]{"TABLE"});
            if (!rs.next()) {
                throw new SQLException("数据库表 pets 不存在，请先执行DDL脚本");
            }
            logger.info("数据库验证通过");
        }
    }

    private static List<Pet> crawlCategory(String category, int maxPages) {
        List<Pet> pets = new ArrayList<>();
        String categoryUrl = getCategoryUrl(category);

        for (int page = 1; page <= maxPages; page++) {
            String url = page > 1 ? categoryUrl + "?p=" + page : categoryUrl;

            try {
                logger.info("正在爬取 {} 第 {} 页: {}", category, page, url);

                // 使用Jsoup获取页面
                Document doc = Jsoup.connect(url)
                        .userAgent(USER_AGENT)
                        .referrer(BASE_URL)
                        .timeout(10000)
                        .get();

                // 解析宠物信息
                Elements petElements = doc.select("div.hot_pet_cont dl");
                for (Element petElement : petElements) {
                    try {
                        Pet pet = parsePetElement(petElement, category);
                        if (pet != null) {
                            pets.add(pet);
                        }
                    } catch (Exception e) {
                        logger.warn("解析宠物元素失败", e);
                    }
                }

                // 检查是否有下一页
                if (doc.select("a:contains(下一页)").isEmpty()) {
                    break;
                }

                // 礼貌性延迟
                Thread.sleep(1000);
            } catch (Exception e) {
                logger.error("爬取 {} 第 {} 页失败", category, page, e);
            }
        }

        return pets;
    }

    private static String getCategoryUrl(String category) {
        switch (category) {
            case "dogs": return BASE_URL + "pet-all/dog/";
            case "cats": return BASE_URL + "pet-all/cat/";
            case "small_pets": return BASE_URL + "pet-all/smallpet/";
            case "aquarium": return BASE_URL + "pet-all/aquarium/";
            case "reptiles": return BASE_URL + "pet-all/reptile/";
            default: throw new IllegalArgumentException("未知的宠物类别: " + category);
        }
    }

    private static Pet parsePetElement(Element element, String category) {
        Element dt = element.selectFirst("dt");
        Element dd = element.selectFirst("dd");
        if (dt == null || dd == null) return null;

        String name = cleanText(dd.text());
        String imageUrl = dt.selectFirst("img") != null ?
                dt.selectFirst("img").absUrl("src") : null;
        String detailUrl = dt.selectFirst("a") != null ?
                dt.selectFirst("a").absUrl("href") : null;

        Map<String, String> categoryInfo = CATEGORY_MAPPING.get(category);

        Pet pet = new Pet();
        pet.setName(name);
        pet.setImageUrl(imageUrl);
        pet.setDetailUrl(detailUrl);
        pet.setType(categoryInfo.get("type"));
        pet.setSize(categoryInfo.get("size"));
        pet.setBreedHint(categoryInfo.get("breed_hint"));
        pet.setDescription(detailUrl != null ?
                "来源：" + BASE_URL + "\n原始链接：" + detailUrl : "来源网络");

        return pet;
    }

    private static String cleanText(String text) {
        if (text == null) return null;
        return text.trim().replaceAll("\\s+", " ");
    }

    private static int saveToDatabase(List<Pet> pets) {
        int savedCount = 0;

        String petSql = "INSERT INTO pets (name, description, status, source, size, " +
                "health_status, vaccination_status, created_at) " +
                "VALUES (?, ?, 'AVAILABLE', 'CRAWLER', ?, 'GOOD', 'NONE', ?)";

        String imageSql = "INSERT INTO pet_images (pet_id, image_url, is_primary, created_at) " +
                "VALUES (?, ?, 1, ?)";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            conn.setAutoCommit(false);

            try (PreparedStatement petStmt = conn.prepareStatement(petSql, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement imageStmt = conn.prepareStatement(imageSql)) {

                for (Pet pet : pets) {
                    // 插入宠物主表
                    petStmt.setString(1, pet.getName());
                    petStmt.setString(2, pet.getDescription());
                    petStmt.setString(3, pet.getSize());
                    petStmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
                    petStmt.executeUpdate();

                    // 获取生成的ID
                    ResultSet rs = petStmt.getGeneratedKeys();
                    if (rs.next()) {
                        long petId = rs.getLong(1);

                        // 插入图片表
                        if (pet.getImageUrl() != null && !pet.getImageUrl().isEmpty()) {
                            imageStmt.setLong(1, petId);
                            imageStmt.setString(2, pet.getImageUrl());
                            imageStmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                            imageStmt.addBatch();
                        }

                        savedCount++;
                    }
                }

                // 批量执行图片插入
                imageStmt.executeBatch();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            logger.error("数据库操作失败", e);
        }

        return savedCount;
    }

    static class Pet {
        private String name;
        private String imageUrl;
        private String detailUrl;
        private String type;
        private String size;
        private String breedHint;
        private String description;

        // getters and setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getImageUrl() { return imageUrl; }
        public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
        public String getDetailUrl() { return detailUrl; }
        public void setDetailUrl(String detailUrl) { this.detailUrl = detailUrl; }
        public String getType() { return type; }
        public void setType(String type) { this.type = type; }
        public String getSize() { return size; }
        public void setSize(String size) { this.size = size; }
        public String getBreedHint() { return breedHint; }
        public void setBreedHint(String breedHint) { this.breedHint = breedHint; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }
}
