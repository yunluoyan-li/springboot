package com.example.petadoption.controller.api;

import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed;
import com.example.petadoption.model.Tag;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.TagService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/pets")
@CrossOrigin(origins = "*")
public class PetApiController {

    private static final Logger logger = LoggerFactory.getLogger(PetApiController.class);

    @Autowired
    private PetService petService;

    @Autowired
    private TagService tagService;

    /**
     * 获取宠物列表（分页）
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getPets(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long breedId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String gender) {
        
        try {
            logger.info("API: 获取宠物列表 - page={}, size={}, keyword={}, breedId={}, status={}, gender={}", 
                       page, size, keyword, breedId, status, gender);
            
            List<Pet> pets;
            int totalCount;
            
            if (keyword != null || breedId != null || status != null || gender != null) {
                // 搜索模式
                pets = petService.searchPetsWithPagination(keyword, breedId, status, gender, page, size);
                totalCount = petService.getFilteredPetsCount(keyword, breedId, status, gender);
            } else {
                // 普通列表模式
                pets = petService.getPetsWithPagination(page, size);
                totalCount = petService.getTotalPetsCount();
            }
            
            // 组装每只宠物的标签信息
            if (pets != null) {
                for (Pet pet : pets) {
                    pet.setTags(tagService.getTagsByPetId(pet.getPetId().intValue()));
                }
            }
            
            int totalPages = (int) Math.ceil((double) totalCount / size);
            
            Map<String, Object> response = new HashMap<>();
            response.put("pets", pets);
            response.put("currentPage", page);
            response.put("pageSize", size);
            response.put("totalPages", totalPages);
            response.put("totalCount", totalCount);
            response.put("success", true);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取宠物列表时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取宠物列表失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 根据ID获取宠物详情
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getPetById(@PathVariable Long id) {
        try {
            logger.info("API: 获取宠物详情 - ID: {}", id);
            
            Pet pet = petService.getPetById(id);
            if (pet == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物不存在");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
            }
            
            // 获取宠物标签
            pet.setTags(tagService.getTagsByPetId(pet.getPetId().intValue()));
            
            Map<String, Object> response = new HashMap<>();
            response.put("pet", pet);
            response.put("success", true);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取宠物详情时发生异常，ID: {}", id, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取宠物详情失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 创建新宠物
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> createPet(@RequestBody Pet pet, 
                                                        @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
                                                        HttpSession session) {
        try {
            logger.info("API: 创建宠物 - 名称: {}", pet.getName());
            
            // 验证必填字段
            if (pet.getName() == null || pet.getName().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物名称不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (pet.getBreedId() == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请选择宠物品种");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (pet.getStatus() == null || pet.getStatus().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请选择宠物状态");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            Pet savedPet = petService.save(pet);
            if (savedPet != null && savedPet.getPetId() != null) {
                // 保存标签关联
                if (tagIds != null) {
                    for (Integer tagId : tagIds) {
                        tagService.addTagToPet(savedPet.getPetId().intValue(), tagId);
                    }
                }
                
                Map<String, Object> response = new HashMap<>();
                response.put("pet", savedPet);
                response.put("success", true);
                response.put("message", "宠物添加成功");
                
                return ResponseEntity.status(HttpStatus.CREATED).body(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物添加失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("创建宠物时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "创建宠物失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 更新宠物信息
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updatePet(@PathVariable Long id, 
                                                        @RequestBody Pet pet,
                                                        @RequestParam(value = "tagIds", required = false) List<Integer> tagIds) {
        try {
            logger.info("API: 更新宠物 - ID: {}, 名称: {}", id, pet.getName());
            
            pet.setPetId(id);
            
            // 验证必填字段
            if (pet.getName() == null || pet.getName().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物名称不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (pet.getBreedId() == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请选择宠物品种");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (pet.getStatus() == null || pet.getStatus().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请选择宠物状态");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            // 验证宠物是否存在
            Pet existingPet = petService.getPetById(id);
            if (existingPet == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物不存在");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
            }
            
            boolean updated = petService.updatePet(pet);
            if (updated) {
                // 先删除现有标签
                List<Tag> oldTags = tagService.getTagsByPetId(id.intValue());
                if (oldTags != null) {
                    for (Tag tag : oldTags) {
                        tagService.removeTagFromPet(id.intValue(), tag.getTagId());
                    }
                }
                // 添加新标签
                if (tagIds != null) {
                    for (Integer tagId : tagIds) {
                        tagService.addTagToPet(id.intValue(), tagId);
                    }
                }
                Map<String, Object> response = new HashMap<>();
                response.put("pet", petService.getPetById(id));
                response.put("success", true);
                response.put("message", "宠物更新成功");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物更新失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("更新宠物时发生异常，ID: {}", id, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "更新宠物失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 删除宠物
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deletePet(@PathVariable Long id) {
        try {
            logger.info("API: 删除宠物 - ID: {}", id);
            
            Pet existingPet = petService.getPetById(id);
            if (existingPet == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物不存在");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
            }
            
            petService.deletePet(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "宠物删除成功");
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("删除宠物时发生异常，ID: {}", id, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "宠物删除失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取宠物统计数据
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getPetStats() {
        try {
            logger.info("API: 获取宠物统计数据");
            
            int totalPets = petService.getTotalPetsCount();
            int availablePets = petService.getAvailablePetsCount();
            int adoptedPets = petService.getAdoptedPetsCount();
            int pendingPets = petService.getPendingPetsCount();
            
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalPets", totalPets);
            stats.put("availablePets", availablePets);
            stats.put("adoptedPets", adoptedPets);
            stats.put("pendingPets", pendingPets);
            
            Map<String, Object> response = new HashMap<>();
            response.put("stats", stats);
            response.put("success", true);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取宠物统计数据时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取统计数据失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取所有宠物品种
     */
    @GetMapping("/breeds")
    public ResponseEntity<Map<String, Object>> getAllBreeds() {
        try {
            logger.info("API: 获取所有宠物品种");
            
            List<PetBreed> breeds = petService.getAllBreeds();
            
            Map<String, Object> response = new HashMap<>();
            response.put("breeds", breeds);
            response.put("success", true);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取宠物品种时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取宠物品种失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
} 