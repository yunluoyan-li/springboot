package com.example.petadoption.controller;

import com.example.petadoption.model.PetBreed;
import com.example.petadoption.model.PetCategory;
import com.example.petadoption.service.PetBreedService;
import com.example.petadoption.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/breeds")
public class BreedController {
    
    private static final Logger logger = LoggerFactory.getLogger(BreedController.class);
    
    @Autowired
    private PetBreedService petBreedService;
    
    @Autowired
    private CategoryService categoryService;
    
    /**
     * 品种列表页面
     */
    @GetMapping("/list")
    public String listBreeds(Model model) {
        List<PetBreed> breeds = petBreedService.getAllPetBreeds();
        model.addAttribute("breeds", breeds);
        return "breed/list";
    }
    
    /**
     * 添加品种页面
     */
    @GetMapping("/add")
    public String addBreedForm(Model model) {
        List<PetCategory> categories = categoryService.getAllCategories();
        model.addAttribute("breed", new PetBreed());
        model.addAttribute("categories", categories);
        return "breed/add";
    }
    
    /**
     * 处理添加品种请求
     */
    @PostMapping("/add")
    public String addBreed(@ModelAttribute PetBreed breed, 
                          RedirectAttributes redirectAttributes) {
        logger.info("开始处理添加品种请求: {}", breed);
        
        // 验证输入
        if (breed.getBreedName() == null || breed.getBreedName().trim().isEmpty()) {
            logger.warn("品种名称为空");
            redirectAttributes.addFlashAttribute("error", "品种名称不能为空");
            return "redirect:/breeds/add";
        }
        
        if (breed.getCategoryId() == null) {
            logger.warn("分类ID为空");
            redirectAttributes.addFlashAttribute("error", "请选择所属分类");
            return "redirect:/breeds/add";
        }
        
        logger.info("验证通过，开始插入品种: breedName={}, categoryId={}", 
                   breed.getBreedName(), breed.getCategoryId());
        
        // 添加品种
        int result = petBreedService.insertPetBreed(breed);
        logger.info("插入品种结果: {}", result);
        
        if (result > 0) {
            logger.info("品种添加成功: {}", breed.getBreedName());
            redirectAttributes.addFlashAttribute("success", "品种添加成功");
        } else {
            logger.error("品种添加失败: {}", breed.getBreedName());
            redirectAttributes.addFlashAttribute("error", "品种添加失败，请检查输入数据");
        }
        
        return "redirect:/breeds/list";
    }
    
    /**
     * 编辑品种页面
     */
    @GetMapping("/edit/{id}")
    public String editBreedForm(@PathVariable Integer id, Model model) {
        PetBreed breed = petBreedService.getPetBreedById(id);
        if (breed == null) {
            return "redirect:/breeds/list";
        }
        
        List<PetCategory> categories = categoryService.getAllCategories();
        model.addAttribute("breed", breed);
        model.addAttribute("categories", categories);
        
        return "breed/edit";
    }
    
    /**
     * 处理编辑品种请求
     */
    @PostMapping("/edit")
    public String editBreed(@ModelAttribute PetBreed breed,
                           RedirectAttributes redirectAttributes) {
        // 验证输入
        if (breed.getBreedName() == null || breed.getBreedName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "品种名称不能为空");
            return "redirect:/breeds/edit/" + breed.getBreedId();
        }
        
        if (breed.getCategoryId() == null) {
            redirectAttributes.addFlashAttribute("error", "请选择所属分类");
            return "redirect:/breeds/edit/" + breed.getBreedId();
        }
        
        // 更新品种
        if (petBreedService.updatePetBreed(breed) > 0) {
            redirectAttributes.addFlashAttribute("success", "品种更新成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "品种更新失败");
        }
        
        return "redirect:/breeds/list";
    }
    
    /**
     * 删除品种
     */
    @GetMapping("/delete/{id}")
    public String deleteBreed(@PathVariable Integer id, 
                             RedirectAttributes redirectAttributes) {
        // 检查品种是否存在
        PetBreed breed = petBreedService.getPetBreedById(id);
        if (breed == null) {
            redirectAttributes.addFlashAttribute("error", "品种不存在");
            return "redirect:/breeds/list";
        }
        
        // 删除品种
        if (petBreedService.deletePetBreed(id) > 0) {
            redirectAttributes.addFlashAttribute("success", "品种删除成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "品种删除失败");
        }
        
        return "redirect:/breeds/list";
    }
    
    /**
     * 品种详情页面
     */
    @GetMapping("/detail/{id}")
    public String breedDetail(@PathVariable Integer id, Model model) {
        PetBreed breed = petBreedService.getPetBreedById(id);
        if (breed == null) {
            return "redirect:/breeds/list";
        }
        
        // 获取所属分类信息
        PetCategory category = categoryService.getCategoryById(breed.getCategoryId());
        model.addAttribute("breed", breed);
        model.addAttribute("category", category);
        
        return "breed/detail";
    }
    
    /**
     * 品种统计页面
     */
    @GetMapping("/stats")
    public String breedStats(Model model) {
        List<PetBreed> breeds = petBreedService.getAllPetBreeds();
        
        // 计算统计数据
        int totalBreeds = breeds.size();
        int lowCareBreeds = (int) breeds.stream().filter(b -> "LOW".equals(b.getCareLevel())).count();
        int mediumCareBreeds = (int) breeds.stream().filter(b -> "MEDIUM".equals(b.getCareLevel())).count();
        int highCareBreeds = (int) breeds.stream().filter(b -> "HIGH".equals(b.getCareLevel())).count();
        int unsetCareBreeds = totalBreeds - lowCareBreeds - mediumCareBreeds - highCareBreeds;
        
        model.addAttribute("breeds", breeds);
        model.addAttribute("totalBreeds", totalBreeds);
        model.addAttribute("lowCareBreeds", lowCareBreeds);
        model.addAttribute("mediumCareBreeds", mediumCareBreeds);
        model.addAttribute("highCareBreeds", highCareBreeds);
        model.addAttribute("unsetCareBreeds", unsetCareBreeds);
        
        return "breed/stats";
    }
} 