package com.example.petadoption.controller;

import com.example.petadoption.model.PetCategory;
import com.example.petadoption.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/categories")
public class CategoryController {
    
    @Autowired
    private CategoryService categoryService;
    
    /**
     * 分类列表页面
     */
    @GetMapping("/list")
    public String listCategories(Model model, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        List<PetCategory> categories = categoryService.getCategoriesOrderByDisplayOrder();
        model.addAttribute("categories", categories);
        
        // 如果是AJAX请求，返回内容片段
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "category/list :: content";
        }
        
        return "category/list";
    }
    
    /**
     * 添加分类页面
     */
    @GetMapping("/add")
    public String addCategoryForm(Model model, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        model.addAttribute("category", new PetCategory());
        
        // 如果是AJAX请求，返回内容片段
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "category/add :: content";
        }
        
        return "category/add";
    }
    
    /**
     * 处理添加分类请求
     */
    @PostMapping("/add")
    public String addCategory(@ModelAttribute PetCategory category, 
                            RedirectAttributes redirectAttributes) {
        // 验证输入
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "分类名称不能为空");
            return "redirect:/categories/add";
        }
        
        if (category.getSlug() == null || category.getSlug().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "分类别名不能为空");
            return "redirect:/categories/add";
        }
        
        // 检查名称和别名是否已存在
        if (categoryService.isNameExists(category.getName(), null)) {
            redirectAttributes.addFlashAttribute("error", "分类名称已存在");
            return "redirect:/categories/add";
        }
        
        if (categoryService.isSlugExists(category.getSlug(), null)) {
            redirectAttributes.addFlashAttribute("error", "分类别名已存在");
            return "redirect:/categories/add";
        }
        
        // 添加分类
        if (categoryService.addCategory(category)) {
            redirectAttributes.addFlashAttribute("success", "分类添加成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "分类添加失败");
        }
        
        return "redirect:/categories/list";
    }
    
    /**
     * 编辑分类页面
     */
    @GetMapping("/edit/{id}")
    public String editCategoryForm(@PathVariable Integer id, Model model, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        PetCategory category = categoryService.getCategoryById(id);
        if (category == null) {
            return "redirect:/categories/list";
        }
        model.addAttribute("category", category);
        
        // 如果是AJAX请求，返回内容片段
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "category/edit :: content";
        }
        
        return "category/edit";
    }
    
    /**
     * 处理编辑分类请求
     */
    @PostMapping("/edit/{id}")
    public String editCategory(@PathVariable Integer id, 
                             @ModelAttribute PetCategory category,
                             RedirectAttributes redirectAttributes) {
        // 验证输入
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "分类名称不能为空");
            return "redirect:/categories/edit/" + id;
        }
        
        if (category.getSlug() == null || category.getSlug().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "分类别名不能为空");
            return "redirect:/categories/edit/" + id;
        }
        
        // 检查名称和别名是否已存在（排除当前记录）
        if (categoryService.isNameExists(category.getName(), id)) {
            redirectAttributes.addFlashAttribute("error", "分类名称已存在");
            return "redirect:/categories/edit/" + id;
        }
        
        if (categoryService.isSlugExists(category.getSlug(), id)) {
            redirectAttributes.addFlashAttribute("error", "分类别名已存在");
            return "redirect:/categories/edit/" + id;
        }
        
        // 更新分类
        if (categoryService.updateCategory(category)) {
            redirectAttributes.addFlashAttribute("success", "分类更新成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "分类更新失败");
        }
        
        return "redirect:/categories/list";
    }
    
    /**
     * 删除分类
     */
    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, 
                               RedirectAttributes redirectAttributes) {
        // 检查分类是否存在
        PetCategory category = categoryService.getCategoryById(id);
        if (category == null) {
            redirectAttributes.addFlashAttribute("error", "分类不存在");
            return "redirect:/categories/list";
        }
        
        // 删除分类
        if (categoryService.deleteCategory(id)) {
            redirectAttributes.addFlashAttribute("success", "分类删除成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "分类删除失败");
        }
        
        return "redirect:/categories/list";
    }
    
    /**
     * 分类详情页面
     */
    @GetMapping("/detail/{id}")
    public String categoryDetail(@PathVariable Integer id, Model model, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
        PetCategory category = categoryService.getCategoryById(id);
        if (category == null) {
            return "redirect:/categories/list";
        }
        model.addAttribute("category", category);
        
        // 如果是AJAX请求，返回内容片段
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "category/detail :: content";
        }
        
        return "category/detail";
    }
    
} 