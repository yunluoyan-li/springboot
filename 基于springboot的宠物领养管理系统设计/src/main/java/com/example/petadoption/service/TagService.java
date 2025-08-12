package com.example.petadoption.service;

import com.example.petadoption.model.Tag;
import java.util.List;
import java.util.Map;

public interface TagService {
    /**
     * 获取所有标签
     * @return 标签列表
     */
    List<Tag> getAllTags();

    /**
     * 根据ID获取标签
     * @param tagId 标签ID
     * @return 标签
     */
    Tag getTagById(Integer tagId);

    /**
     * 根据名称获取标签
     * @param name 标签名称
     * @return 标签
     */
    Tag getTagByName(String name);

    /**
     * 根据slug获取标签
     * @param slug 标签slug
     * @return 标签
     */
    Tag getTagBySlug(String slug);

    /**
     * 插入标签
     * @param tag 标签对象
     * @return 插入成功的记录数
     */
    int insertTag(Tag tag);

    /**
     * 更新标签
     * @param tag 标签对象
     * @return 更新成功的记录数
     */
    int updateTag(Tag tag);

    /**
     * 删除标签
     * @param tagId 标签ID
     * @return 删除成功的记录数
     */
    int deleteTag(Integer tagId);

    /**
     * 根据宠物ID获取标签
     * @param petId 宠物ID
     * @return 标签列表
     */
    List<Tag> getTagsByPetId(Integer petId);

    /**
     * 为宠物添加标签
     * @param petId 宠物ID
     * @param tagId 标签ID
     * @return 添加成功的记录数
     */
    int addTagToPet(Integer petId, Integer tagId);

    /**
     * 为宠物移除标签
     * @param petId 宠物ID
     * @param tagId 标签ID
     * @return 移除成功的记录数
     */
    int removeTagFromPet(Integer petId, Integer tagId);

    /**
     * 获取标签使用统计
     * @return 标签使用统计列表
     */
    List<Map<String, Object>> getTagUsageStats();

    /**
     * 搜索标签
     * @param keyword 搜索关键词
     * @return 标签列表
     */
    List<Tag> searchTags(String keyword);

    /**
     * 生成标签slug
     * @param name 标签名称
     * @return slug
     */
    String generateSlug(String name);
} 