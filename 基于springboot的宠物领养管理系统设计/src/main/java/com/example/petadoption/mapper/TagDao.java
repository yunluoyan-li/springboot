package com.example.petadoption.mapper;

import com.example.petadoption.model.Tag;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface TagDao {
    /**
     * 查询所有标签
     * @return 标签列表
     */
    List<Tag> findAll();

    /**
     * 根据标签ID查询标签
     * @param tagId 标签ID
     * @return 标签
     */
    Tag findById(Integer tagId);

    /**
     * 根据标签名称查询标签
     * @param name 标签名称
     * @return 标签
     */
    Tag findByName(String name);

    /**
     * 根据slug查询标签
     * @param slug 标签slug
     * @return 标签
     */
    Tag findBySlug(String slug);

    /**
     * 插入新标签
     * @param tag 标签对象
     * @return 插入成功的记录数
     */
    int insert(Tag tag);

    /**
     * 更新标签信息
     * @param tag 标签对象
     * @return 更新成功的记录数
     */
    int update(Tag tag);

    /**
     * 根据标签ID删除标签
     * @param tagId 标签ID
     * @return 删除成功的记录数
     */
    int delete(Integer tagId);

    /**
     * 根据宠物ID查询标签
     * @param petId 宠物ID
     * @return 标签列表
     */
    List<Tag> findByPetId(Integer petId);

    /**
     * 为宠物添加标签
     * @param petId 宠物ID
     * @param tagId 标签ID
     * @return 插入成功的记录数
     */
    int addTagToPet(@Param("petId") Integer petId, @Param("tagId") Integer tagId);

    /**
     * 为宠物移除标签
     * @param petId 宠物ID
     * @param tagId 标签ID
     * @return 删除成功的记录数
     */
    int removeTagFromPet(@Param("petId") Integer petId, @Param("tagId") Integer tagId);

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
    List<Tag> searchTags(@Param("keyword") String keyword);
} 