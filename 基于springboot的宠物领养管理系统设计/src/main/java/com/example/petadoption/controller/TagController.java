package com.example.petadoption.controller;

import com.example.petadoption.model.Tag;
import com.example.petadoption.service.TagService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/tags")
public class TagController {
    
    private static final Logger logger = LoggerFactory.getLogger(TagController.class);
    
    @Autowired
    private TagService tagService;
    
    /**
     * 标签列表页面
     */
    @GetMapping("/list")
    public String listTags(Model model) {
        List<Tag> tags = tagService.getAllTags();
        model.addAttribute("tags", tags);
        return "tag/list";
    }
    
    /**
     * 添加标签页面
     */
    @GetMapping("/add")
    public String addTagForm(Model model) {
        model.addAttribute("tag", new Tag());
        return "tag/add";
    }
    
    /**
     * 处理添加标签请求
     */
    @PostMapping("/add")
    public String addTag(@ModelAttribute Tag tag, 
                        RedirectAttributes redirectAttributes) {
        logger.info("开始处理添加标签请求: {}", tag);
        
        // 验证输入
        if (tag.getName() == null || tag.getName().trim().isEmpty()) {
            logger.warn("标签名称为空");
            redirectAttributes.addFlashAttribute("error", "标签名称不能为空");
            return "redirect:/tags/add";
        }
        
        // 检查标签名称是否已存在
        Tag existingTag = tagService.getTagByName(tag.getName().trim());
        if (existingTag != null) {
            logger.warn("标签名称已存在: {}", tag.getName());
            redirectAttributes.addFlashAttribute("error", "标签名称已存在");
            return "redirect:/tags/add";
        }
        
        logger.info("验证通过，开始插入标签: name={}", tag.getName());
        
        // 添加标签
        int result = tagService.insertTag(tag);
        logger.info("插入标签结果: {}", result);
        
        if (result > 0) {
            logger.info("标签添加成功: {}", tag.getName());
            redirectAttributes.addFlashAttribute("success", "标签添加成功");
        } else {
            logger.error("标签添加失败: {}", tag.getName());
            redirectAttributes.addFlashAttribute("error", "标签添加失败，请检查输入数据");
        }
        
        return "redirect:/tags/list";
    }
    
    /**
     * 编辑标签页面
     */
    @GetMapping("/edit/{id}")
    public String editTagForm(@PathVariable Integer id, Model model) {
        Tag tag = tagService.getTagById(id);
        if (tag == null) {
            return "redirect:/tags/list";
        }
        
        model.addAttribute("tag", tag);
        return "tag/edit";
    }
    
    /**
     * 处理编辑标签请求
     */
    @PostMapping("/edit")
    public String editTag(@ModelAttribute Tag tag,
                         RedirectAttributes redirectAttributes) {
        // 验证输入
        if (tag.getName() == null || tag.getName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "标签名称不能为空");
            return "redirect:/tags/edit/" + tag.getTagId();
        }
        
        // 检查标签名称是否已存在（排除当前标签）
        Tag existingTag = tagService.getTagByName(tag.getName().trim());
        if (existingTag != null && !existingTag.getTagId().equals(tag.getTagId())) {
            redirectAttributes.addFlashAttribute("error", "标签名称已存在");
            return "redirect:/tags/edit/" + tag.getTagId();
        }
        
        // 更新标签
        if (tagService.updateTag(tag) > 0) {
            redirectAttributes.addFlashAttribute("success", "标签更新成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "标签更新失败");
        }
        
        return "redirect:/tags/list";
    }
    
    /**
     * 删除标签
     */
    @GetMapping("/delete/{id}")
    public String deleteTag(@PathVariable Integer id, 
                           RedirectAttributes redirectAttributes) {
        // 检查标签是否存在
        Tag tag = tagService.getTagById(id);
        if (tag == null) {
            redirectAttributes.addFlashAttribute("error", "标签不存在");
            return "redirect:/tags/list";
        }
        
        // 删除标签
        if (tagService.deleteTag(id) > 0) {
            redirectAttributes.addFlashAttribute("success", "标签删除成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "标签删除失败");
        }
        
        return "redirect:/tags/list";
    }
    
    /**
     * 标签详情页面
     */
    @GetMapping("/detail/{id}")
    public String tagDetail(@PathVariable Integer id, Model model) {
        Tag tag = tagService.getTagById(id);
        if (tag == null) {
            return "redirect:/tags/list";
        }
        
        model.addAttribute("tag", tag);
        return "tag/detail";
    }
    
    /**
     * 标签统计页面
     */
    @GetMapping("/stats")
    public String tagStats(Model model) {
        List<Map<String, Object>> tagStats = tagService.getTagUsageStats();
        model.addAttribute("tagStats", tagStats);
        return "tag/stats";
    }
    
    /**
     * 搜索标签
     */
    @GetMapping("/search")
    public String searchTags(@RequestParam String keyword, Model model) {
        List<Tag> tags = tagService.searchTags(keyword);
        model.addAttribute("tags", tags);
        model.addAttribute("keyword", keyword);
        return "tag/search";
    }
    
    /**
     * AJAX API: 获取所有标签（用于下拉选择）
     */
    @GetMapping("/api/all")
    @ResponseBody
    public List<Tag> getAllTagsApi() {
        return tagService.getAllTags();
    }
    
    /**
     * AJAX API: 根据宠物ID获取标签
     */
    @GetMapping("/api/pet/{petId}")
    @ResponseBody
    public List<Tag> getTagsByPetIdApi(@PathVariable Integer petId) {
        return tagService.getTagsByPetId(petId);
    }
    
    /**
     * AJAX API: 为宠物添加标签
     */
    @PostMapping("/api/pet/{petId}/add/{tagId}")
    @ResponseBody
    public Map<String, Object> addTagToPetApi(@PathVariable Integer petId, 
                                              @PathVariable Integer tagId) {
        int result = tagService.addTagToPet(petId, tagId);
        Map<String, Object> response = new java.util.HashMap<>();
        response.put("success", result > 0);
        response.put("message", result > 0 ? "标签添加成功" : "标签添加失败");
        return response;
    }
    
    /**
     * AJAX API: 为宠物移除标签
     */
    @DeleteMapping("/api/pet/{petId}/remove/{tagId}")
    @ResponseBody
    public Map<String, Object> removeTagFromPetApi(@PathVariable Integer petId, 
                                                   @PathVariable Integer tagId) {
        int result = tagService.removeTagFromPet(petId, tagId);
        Map<String, Object> response = new java.util.HashMap<>();
        response.put("success", result > 0);
        response.put("message", result > 0 ? "标签移除成功" : "标签移除失败");
        return response;
    }
} 