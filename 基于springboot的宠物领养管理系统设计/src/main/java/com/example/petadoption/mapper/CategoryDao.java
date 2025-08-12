package com.example.petadoption.mapper;

import com.example.petadoption.model.PetCategory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CategoryDao {
    /**
     * 查询所有宠物分类
     * @return 宠物分类列表
     */
    List<PetCategory> findAll();
    
    /**
     * 根据分类ID查询宠物分类
     * @param categoryId 分类ID
     * @return 宠物分类
     */
    PetCategory findById(Integer categoryId);
    
    /**
     * 根据别名查询宠物分类
     * @param slug 分类别名
     * @return 宠物分类
     */
    PetCategory findBySlug(String slug);
    
    /**
     * 插入新的宠物分类
     * @param category 宠物分类对象
     * @return 插入成功的记录数
     */
    int insert(PetCategory category);
    
    /**
     * 更新宠物分类信息
     * @param category 宠物分类对象
     * @return 更新成功的记录数
     */
    int update(PetCategory category);
    
    /**
     * 根据分类ID删除宠物分类
     * @param categoryId 分类ID
     * @return 删除成功的记录数
     */
    int delete(Integer categoryId);
    
    /**
     * 根据显示顺序查询分类
     * @return 按显示顺序排序的分类列表
     */
    List<PetCategory> findAllOrderByDisplayOrder();
    
    /**
     * 检查分类名称是否存在
     * @param name 分类名称
     * @param excludeId 排除的分类ID（用于更新时检查）
     * @return 存在的记录数
     */
    int countByName(@Param("name") String name, @Param("excludeId") Integer excludeId);
    
    /**
     * 检查分类别名是否存在
     * @param slug 分类别名
     * @param excludeId 排除的分类ID（用于更新时检查）
     * @return 存在的记录数
     */
    int countBySlug(@Param("slug") String slug, @Param("excludeId") Integer excludeId);
    
    /**
     * 获取分类统计信息
     * @return 分类统计信息
     */
    List<PetCategory> getCategoryStats();
} 