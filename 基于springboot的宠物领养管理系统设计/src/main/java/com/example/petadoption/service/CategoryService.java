package com.example.petadoption.service;

import com.example.petadoption.model.PetCategory;
import java.util.List;

public interface CategoryService {
    /**
     * 查询所有宠物分类
     * @return 宠物分类列表
     */
    List<PetCategory> getAllCategories();
    
    /**
     * 根据分类ID查询宠物分类
     * @param categoryId 分类ID
     * @return 宠物分类
     */
    PetCategory getCategoryById(Integer categoryId);
    
    /**
     * 根据别名查询宠物分类
     * @param slug 分类别名
     * @return 宠物分类
     */
    PetCategory getCategoryBySlug(String slug);
    
    /**
     * 添加新的宠物分类
     * @param category 宠物分类对象
     * @return 是否添加成功
     */
    boolean addCategory(PetCategory category);
    
    /**
     * 更新宠物分类信息
     * @param category 宠物分类对象
     * @return 是否更新成功
     */
    boolean updateCategory(PetCategory category);
    
    /**
     * 删除宠物分类
     * @param categoryId 分类ID
     * @return 是否删除成功
     */
    boolean deleteCategory(Integer categoryId);
    
    /**
     * 检查分类名称是否存在
     * @param name 分类名称
     * @param excludeId 排除的分类ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isNameExists(String name, Integer excludeId);
    
    /**
     * 检查分类别名是否存在
     * @param slug 分类别名
     * @param excludeId 排除的分类ID（用于更新时检查）
     * @return 是否存在
     */
    boolean isSlugExists(String slug, Integer excludeId);
    
    /**
     * 获取分类统计信息
     * @return 分类统计信息列表
     */
    List<PetCategory> getCategoryStats();
    
    /**
     * 根据显示顺序获取分类列表
     * @return 按显示顺序排序的分类列表
     */
    List<PetCategory> getCategoriesOrderByDisplayOrder();
} 