package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.TagDao;
import com.example.petadoption.model.Tag;
import com.example.petadoption.service.TagService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class TagServiceImpl implements TagService {

    private static final Logger logger = LoggerFactory.getLogger(TagServiceImpl.class);

    @Autowired
    private TagDao tagDao;

    @Override
    public List<Tag> getAllTags() {
        try {
            logger.info("开始从数据库查询所有标签");
            List<Tag> tags = tagDao.findAll();
            logger.info("从数据库查询到 {} 条标签记录", tags != null ? tags.size() : 0);
            return tags;
        } catch (Exception e) {
            logger.error("查询所有标签时出现异常", e);
            return null;
        }
    }

    @Override
    public Tag getTagById(Integer tagId) {
        try {
            return tagDao.findById(tagId);
        } catch (Exception e) {
            logger.error("根据 ID 查询标签信息时出现异常，ID: {}", tagId, e);
            return null;
        }
    }

    @Override
    public Tag getTagByName(String name) {
        try {
            return tagDao.findByName(name);
        } catch (Exception e) {
            logger.error("根据名称查询标签信息时出现异常，名称: {}", name, e);
            return null;
        }
    }

    @Override
    public Tag getTagBySlug(String slug) {
        try {
            return tagDao.findBySlug(slug);
        } catch (Exception e) {
            logger.error("根据slug查询标签信息时出现异常，slug: {}", slug, e);
            return null;
        }
    }

    @Override
    public int insertTag(Tag tag) {
        try {
            logger.info("开始插入标签: {}", tag.getName());
            // 生成slug
            if (tag.getSlug() == null || tag.getSlug().trim().isEmpty()) {
                tag.setSlug(generateSlug(tag.getName()));
            }
            int result = tagDao.insert(tag);
            logger.info("插入标签结果: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("插入标签信息时出现异常", e);
            return 0;
        }
    }

    @Override
    public int updateTag(Tag tag) {
        try {
            logger.info("开始更新标签: {}", tag.getName());
            // 生成slug
            if (tag.getSlug() == null || tag.getSlug().trim().isEmpty()) {
                tag.setSlug(generateSlug(tag.getName()));
            }
            int result = tagDao.update(tag);
            logger.info("更新标签结果: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("更新标签信息时出现异常，标签 ID: {}", tag.getTagId(), e);
            return 0;
        }
    }

    @Override
    public int deleteTag(Integer tagId) {
        try {
            logger.info("开始删除标签，ID: {}", tagId);
            int result = tagDao.delete(tagId);
            logger.info("删除标签结果: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("删除标签信息时出现异常，标签 ID: {}", tagId, e);
            return 0;
        }
    }

    @Override
    public List<Tag> getTagsByPetId(Integer petId) {
        try {
            return tagDao.findByPetId(petId);
        } catch (Exception e) {
            logger.error("根据宠物ID查询标签时出现异常，宠物ID: {}", petId, e);
            return null;
        }
    }

    @Override
    public int addTagToPet(Integer petId, Integer tagId) {
        try {
            logger.info("为宠物添加标签，宠物ID: {}, 标签ID: {}", petId, tagId);
            int result = tagDao.addTagToPet(petId, tagId);
            logger.info("为宠物添加标签结果: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("为宠物添加标签时出现异常，宠物ID: {}, 标签ID: {}", petId, tagId, e);
            return 0;
        }
    }

    @Override
    public int removeTagFromPet(Integer petId, Integer tagId) {
        try {
            logger.info("为宠物移除标签，宠物ID: {}, 标签ID: {}", petId, tagId);
            int result = tagDao.removeTagFromPet(petId, tagId);
            logger.info("为宠物移除标签结果: {}", result);
            return result;
        } catch (Exception e) {
            logger.error("为宠物移除标签时出现异常，宠物ID: {}, 标签ID: {}", petId, tagId, e);
            return 0;
        }
    }

    @Override
    public List<Map<String, Object>> getTagUsageStats() {
        try {
            logger.info("开始获取标签使用统计");
            List<Map<String, Object>> stats = tagDao.getTagUsageStats();
            logger.info("获取到 {} 条标签使用统计记录", stats != null ? stats.size() : 0);
            return stats;
        } catch (Exception e) {
            logger.error("获取标签使用统计时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Tag> searchTags(String keyword) {
        try {
            logger.info("开始搜索标签，关键词: {}", keyword);
            List<Tag> tags = tagDao.searchTags(keyword);
            logger.info("搜索到 {} 条标签记录", tags != null ? tags.size() : 0);
            return tags;
        } catch (Exception e) {
            logger.error("搜索标签时出现异常，关键词: {}", keyword, e);
            return null;
        }
    }

    @Override
    public String generateSlug(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }
        
        // 转换为小写
        String slug = name.toLowerCase();
        
        // 替换中文字符为拼音（简化处理，实际项目中可以使用拼音库）
        slug = slug.replaceAll("[\\u4e00-\\u9fa5]", "");
        
        // 替换特殊字符为连字符
        slug = slug.replaceAll("[^a-z0-9\\s-]", "");
        
        // 将多个空格或连字符替换为单个连字符
        slug = slug.replaceAll("[\\s-]+", "-");
        
        // 移除首尾的连字符
        slug = slug.replaceAll("^-+|-+$", "");
        
        // 如果slug为空，使用默认值
        if (slug.isEmpty()) {
            slug = "tag-" + System.currentTimeMillis();
        }
        
        return slug;
    }
} 