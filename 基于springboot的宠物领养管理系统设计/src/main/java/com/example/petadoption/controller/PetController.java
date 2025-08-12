package com.example.petadoption.controller;

import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed;
import com.example.petadoption.model.Tag;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.TagService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/pets")
public class PetController {

    private static final Logger logger = LoggerFactory.getLogger(PetController.class);

    @Autowired
    private PetService petService;

    @Autowired
    private TagService tagService;

    @GetMapping("/list")
    public String listPets(@RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "12") int size,
                          Model model) {
        logger.info("开始查询宠物列表: page={}, size={}", page, size);
        
        List<Pet> pets = petService.getPetsWithPagination(page, size);
        // 组装每只宠物的标签信息
        if (pets != null) {
            for (Pet pet : pets) {
                pet.setTags(tagService.getTagsByPetId(pet.getPetId().intValue()));
            }
        }
        int totalCount = petService.getFilteredPetsCount(null, null, null, null);
        int totalPages = (int) Math.ceil((double) totalCount / size);
        
        // 获取所有品种用于下拉选择
        List<PetBreed> breeds = petService.getAllBreeds();
        
        if (pets == null) {
            logger.error("查询宠物列表失败，返回 null");
        } else {
            logger.info("查询到 {} 条宠物记录", pets.size());
        }
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        
        return "petList";
    }

    @GetMapping("/add")
    public String showAddPetForm(Model model) {
        model.addAttribute("pet", new Pet());
        List<PetBreed> breeds = petService.getAllBreeds();
        model.addAttribute("breeds", breeds);
        model.addAttribute("allTags", tagService.getAllTags());
        return "addPet";
    }

    @PostMapping("/add")
    public String addPet(@ModelAttribute Pet pet, @RequestParam(value = "tagIds", required = false) List<Integer> tagIds, RedirectAttributes redirectAttributes) {
        logger.info("开始添加宠物: {}", pet.getName());
        
        // 验证必填字段
        if (pet.getName() == null || pet.getName().trim().isEmpty()) {
            logger.error("宠物名称不能为空");
            redirectAttributes.addFlashAttribute("error", "宠物名称不能为空！");
            return "redirect:/pets/add";
        }
        
        if (pet.getBreedId() == null) {
            logger.error("宠物品种不能为空");
            redirectAttributes.addFlashAttribute("error", "请选择宠物品种！");
            return "redirect:/pets/add";
        }
        
        if (pet.getStatus() == null || pet.getStatus().trim().isEmpty()) {
            logger.error("宠物状态不能为空");
            redirectAttributes.addFlashAttribute("error", "请选择宠物状态！");
            return "redirect:/pets/add";
        }
        
        try {
            Pet savedPet = petService.save(pet);
            if (savedPet != null && savedPet.getPetId() != null) {
                logger.info("宠物添加成功，ID: {}", savedPet.getPetId());
                // 保存标签关联
                if (tagIds != null) {
                    for (Integer tagId : tagIds) {
                        tagService.addTagToPet(savedPet.getPetId().intValue(), tagId);
                    }
                }
                redirectAttributes.addFlashAttribute("success", "宠物添加成功！");
            } else {
                logger.error("宠物添加失败，返回的宠物对象为null或ID为null");
                redirectAttributes.addFlashAttribute("error", "宠物添加失败，请重试！");
            }
        } catch (Exception e) {
            logger.error("添加宠物时发生异常: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "添加宠物时发生错误：" + e.getMessage());
        }
        
        return "redirect:/pets/list";
    }

    @GetMapping("/edit/{id}")
    public String editPet(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        logger.info("开始编辑宠物，ID: {}", id);
        
        try {
            // 确保 PetService 有 getPetById 方法
            Pet pet = petService.getPetById(id);
            
            if (pet == null) {
                logger.error("宠物不存在，ID: {}", id);
                redirectAttributes.addFlashAttribute("error", "宠物不存在！");
                return "redirect:/pets/list";
            }
            
            logger.info("找到宠物: ID={}, 名称={}", pet.getPetId(), pet.getName());
            model.addAttribute("pet", pet);

            // 查询所有品种数据
            List<PetBreed> breeds = petService.getAllBreeds();
            if (breeds == null || breeds.isEmpty()) {
                logger.warn("没有找到任何宠物品种数据");
                redirectAttributes.addFlashAttribute("error", "无法加载宠物品种数据！");
                return "redirect:/pets/list";
            }
            
            model.addAttribute("breeds", breeds);
            model.addAttribute("allTags", tagService.getAllTags());
            logger.info("成功加载编辑页面，宠物ID: {}", id);
            return "editPet";
            
        } catch (Exception e) {
            logger.error("编辑宠物时发生异常，ID: {}", id, e);
            redirectAttributes.addFlashAttribute("error", "编辑宠物时发生错误：" + e.getMessage());
            return "redirect:/pets/list";
        }
    }

    @PostMapping("/update")
    public String updatePet(@ModelAttribute Pet pet, @RequestParam(value = "tagIds", required = false) List<Integer> tagIds, RedirectAttributes redirectAttributes) {
        logger.info("开始更新宠物: ID={}, 名称={}, 品种ID={}, 状态={}", 
                   pet.getPetId(), pet.getName(), pet.getBreedId(), pet.getStatus());
        
        // 验证必填字段
        if (pet.getPetId() == null) {
            logger.error("宠物ID不能为空");
            redirectAttributes.addFlashAttribute("error", "宠物ID不能为空！");
            return "redirect:/pets/list";
        }
        
        if (pet.getName() == null || pet.getName().trim().isEmpty()) {
            logger.error("宠物名称不能为空");
            redirectAttributes.addFlashAttribute("error", "宠物名称不能为空！");
            return "redirect:/pets/edit/" + pet.getPetId();
        }
        
        if (pet.getBreedId() == null) {
            logger.error("宠物品种不能为空");
            redirectAttributes.addFlashAttribute("error", "请选择宠物品种！");
            return "redirect:/pets/edit/" + pet.getPetId();
        }
        
        if (pet.getStatus() == null || pet.getStatus().trim().isEmpty()) {
            logger.error("宠物状态不能为空");
            redirectAttributes.addFlashAttribute("error", "请选择宠物状态！");
            return "redirect:/pets/edit/" + pet.getPetId();
        }
        
        // 验证宠物是否存在
        Pet existingPet = petService.getPetById(pet.getPetId());
        if (existingPet == null) {
            logger.error("要更新的宠物不存在，ID: {}", pet.getPetId());
            redirectAttributes.addFlashAttribute("error", "宠物不存在！");
            return "redirect:/pets/list";
        }
        
        logger.info("验证通过，开始更新宠物信息");
        
        try {
            // 先移除所有旧标签，再添加新标签
            List<Tag> oldTags = tagService.getTagsByPetId(pet.getPetId().intValue());
            if (oldTags != null) {
                for (Tag tag : oldTags) {
                    tagService.removeTagFromPet(pet.getPetId().intValue(), tag.getTagId());
                }
            }
            if (tagIds != null) {
                for (Integer tagId : tagIds) {
                    tagService.addTagToPet(pet.getPetId().intValue(), tagId);
                }
            }
            boolean success = petService.updatePet(pet);
            if (success) {
                logger.info("宠物更新成功，ID: {}", pet.getPetId());
                redirectAttributes.addFlashAttribute("success", "宠物信息更新成功！");
            } else {
                logger.error("宠物更新失败，ID: {}", pet.getPetId());
                redirectAttributes.addFlashAttribute("error", "宠物更新失败，请重试！");
                return "redirect:/pets/edit/" + pet.getPetId();
            }
        } catch (Exception e) {
            logger.error("更新宠物时发生异常: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "更新宠物时发生错误：" + e.getMessage());
            return "redirect:/pets/edit/" + pet.getPetId();
        }
        
        return "redirect:/pets/list";
    }

    @GetMapping("/delete/{id}")
    public String deletePet(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        logger.info("开始删除宠物: ID={}", id);
        
        try {
            petService.deletePet(id);
            logger.info("宠物删除成功，ID: {}", id);
            redirectAttributes.addFlashAttribute("success", "宠物删除成功！");
        } catch (Exception e) {
            logger.error("删除宠物时发生异常", e);
            redirectAttributes.addFlashAttribute("error", "删除宠物时发生错误：" + e.getMessage());
        }
        
        return "redirect:/pets/list";
    }

    // 新增：条件搜索宠物
    @GetMapping("/search")
    public String searchPets(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) Long breedId,
                           @RequestParam(required = false) String status,
                           @RequestParam(required = false) String gender,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "12") int size,
                           Model model) {
        logger.info("开始搜索宠物: keyword={}, breedId={}, status={}, gender={}, page={}, size={}", 
                   keyword, breedId, status, gender, page, size);
        
        // 使用分页搜索方法
        List<Pet> pets = petService.searchPetsWithPagination(keyword, breedId, status, gender, page, size);
        int totalCount = petService.getFilteredPetsCount(keyword, breedId, status, gender);
        int totalPages = (int) Math.ceil((double) totalCount / size);
        
        // 获取所有品种用于下拉选择
        List<PetBreed> breeds = petService.getAllBreeds();
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("keyword", keyword);
        model.addAttribute("breedId", breedId);
        model.addAttribute("status", status);
        model.addAttribute("gender", gender);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        
        logger.info("搜索完成，找到 {} 条宠物记录，当前页: {}, 总页数: {}", totalCount, page, totalPages);
        return "petList";
    }
    
    // 新增：分页查询宠物
    @GetMapping("/list/page")
    public String listPetsWithPagination(@RequestParam(defaultValue = "1") int page,
                                       @RequestParam(defaultValue = "12") int size,
                                       Model model) {
        logger.info("开始分页查询宠物: page={}, size={}", page, size);
        
        List<Pet> pets = petService.getPetsWithPagination(page, size);
        int totalCount = petService.getFilteredPetsCount(null, null, null, null);
        int totalPages = (int) Math.ceil((double) totalCount / size);
        
        // 获取所有品种用于下拉选择
        List<PetBreed> breeds = petService.getAllBreeds();
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        
        logger.info("分页查询完成，当前页: {}, 总页数: {}, 总记录数: {}", page, totalPages, totalCount);
        return "petList";
    }
    
    // 新增：根据品种查询宠物
    @GetMapping("/list/breed/{breedId}")
    public String getPetsByBreed(@PathVariable Long breedId, Model model) {
        logger.info("开始根据品种查询宠物: breedId={}", breedId);
        
        List<Pet> pets = petService.getPetsByBreed(breedId);
        List<PetBreed> breeds = petService.getAllBreeds();
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("selectedBreedId", breedId);
        
        logger.info("根据品种查询完成，找到 {} 条宠物记录", pets != null ? pets.size() : 0);
        return "petList";
    }
    
    // 新增：根据状态查询宠物
    @GetMapping("/list/status/{status}")
    public String getPetsByStatus(@PathVariable String status, Model model) {
        logger.info("开始根据状态查询宠物: status={}", status);
        
        List<Pet> pets = petService.getPetsByStatus(status);
        List<PetBreed> breeds = petService.getAllBreeds();
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("selectedStatus", status);
        
        logger.info("根据状态查询完成，找到 {} 条宠物记录", pets != null ? pets.size() : 0);
        return "petList";
    }
    
    // 新增：根据性别查询宠物
    @GetMapping("/list/gender/{gender}")
    public String getPetsByGender(@PathVariable String gender, Model model) {
        logger.info("开始根据性别查询宠物: gender={}", gender);
        
        List<Pet> pets = petService.getPetsByGender(gender);
        List<PetBreed> breeds = petService.getAllBreeds();
        
        model.addAttribute("pets", pets);
        model.addAttribute("breeds", breeds);
        model.addAttribute("selectedGender", gender);
        
        logger.info("根据性别查询完成，找到 {} 条宠物记录", pets != null ? pets.size() : 0);
        return "petList";
    }
}