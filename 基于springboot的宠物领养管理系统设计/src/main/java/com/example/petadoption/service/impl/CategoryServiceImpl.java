package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.CategoryDao;
import com.example.petadoption.model.PetCategory;
import com.example.petadoption.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {
    
    @Autowired
    private CategoryDao categoryDao;
    
    @Override
    public List<PetCategory> getAllCategories() {
        return categoryDao.findAll();
    }
    
    @Override
    public PetCategory getCategoryById(Integer categoryId) {
        return categoryDao.findById(categoryId);
    }
    
    @Override
    public PetCategory getCategoryBySlug(String slug) {
        return categoryDao.findBySlug(slug);
    }
    
    @Override
    public boolean addCategory(PetCategory category) {
        // 检查名称和别名是否已存在
        if (isNameExists(category.getName(), null)) {
            return false;
        }
        if (isSlugExists(category.getSlug(), null)) {
            return false;
        }
        
        // 如果没有设置显示顺序，设置为最大值+1
        if (category.getDisplayOrder() == null) {
            List<PetCategory> categories = getAllCategories();
            int maxOrder = categories.stream()
                    .mapToInt(c -> c.getDisplayOrder() != null ? c.getDisplayOrder() : 0)
                    .max()
                    .orElse(0);
            category.setDisplayOrder(maxOrder + 1);
        }
        
        return categoryDao.insert(category) > 0;
    }
    
    @Override
    public boolean updateCategory(PetCategory category) {
        // 检查名称和别名是否已存在（排除当前记录）
        if (isNameExists(category.getName(), category.getCategoryId())) {
            return false;
        }
        if (isSlugExists(category.getSlug(), category.getCategoryId())) {
            return false;
        }
        
        return categoryDao.update(category) > 0;
    }
    
    @Override
    public boolean deleteCategory(Integer categoryId) {
        return categoryDao.delete(categoryId) > 0;
    }
    
    @Override
    public boolean isNameExists(String name, Integer excludeId) {
        return categoryDao.countByName(name, excludeId) > 0;
    }
    
    @Override
    public boolean isSlugExists(String slug, Integer excludeId) {
        return categoryDao.countBySlug(slug, excludeId) > 0;
    }
    
    @Override
    public List<PetCategory> getCategoryStats() {
        return categoryDao.getCategoryStats();
    }
    
    @Override
    public List<PetCategory> getCategoriesOrderByDisplayOrder() {
        return categoryDao.findAllOrderByDisplayOrder();
    }
} 