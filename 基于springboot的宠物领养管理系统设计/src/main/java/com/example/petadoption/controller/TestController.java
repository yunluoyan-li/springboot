package com.example.petadoption.controller;

import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed;
import com.example.petadoption.model.PetCategory;
import com.example.petadoption.model.User;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.UserService;
import com.example.petadoption.service.CategoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@Controller
@RequestMapping("/test")
public class TestController {

    private static final Logger logger = LoggerFactory.getLogger(TestController.class);

    @Autowired
    private PetService petService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private com.example.petadoption.mapper.PetDao petDao;
    
    @Autowired
    private com.example.petadoption.mapper.UserDao userDao;
    
    @Autowired
    private com.example.petadoption.mapper.AdoptionApplicationDao adoptionApplicationDao;
    
    @Autowired
    private com.example.petadoption.mapper.PetBreedDao petBreedDao;
    
    @Autowired
    private com.example.petadoption.service.PetBreedService petBreedService;

    @GetMapping("/database")
    public String testDatabase(Model model) {
        logger.info("开始测试数据库连接...");
        
        try {
            // 测试查询宠物
            List<Pet> pets = petService.findAll();
            model.addAttribute("petsCount", pets != null ? pets.size() : 0);
            model.addAttribute("pets", pets);
            
            // 测试查询品种
            List<PetBreed> breeds = petService.getAllBreeds();
            model.addAttribute("breedsCount", breeds != null ? breeds.size() : 0);
            model.addAttribute("breeds", breeds);
            
            model.addAttribute("databaseStatus", "连接正常");
            logger.info("数据库测试完成，宠物数量: {}, 品种数量: {}", 
                       model.getAttribute("petsCount"), model.getAttribute("breedsCount"));
            
        } catch (Exception e) {
            logger.error("数据库测试失败", e);
            model.addAttribute("databaseStatus", "连接失败: " + e.getMessage());
            model.addAttribute("error", e);
        }
        
        return "test/database";
    }

    @GetMapping("/test/layout")
    public String testLayout() {
        return "test-layout";
    }
    
    // 新增：测试用户查询功能
    @GetMapping("/users")
    public Map<String, Object> testUserQueries() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 测试获取所有用户
            List<User> allUsers = userService.getAllUsers();
            result.put("allUsers", allUsers);
            result.put("totalUsers", allUsers.size());
            
            // 测试搜索功能
            List<User> searchResults = userService.searchUsers("", "", "");
            result.put("searchResults", searchResults);
            
            // 测试分页功能
            List<User> paginatedUsers = userService.getUsersWithPagination(1, 5);
            result.put("paginatedUsers", paginatedUsers);
            
            // 测试统计功能
            int totalCount = userService.getTotalUserCount();
            result.put("totalCount", totalCount);
            
            result.put("success", true);
            result.put("message", "用户查询功能测试成功");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/users/search")
    public Map<String, Object> testUserSearch(@RequestParam(required = false) String keyword,
                                             @RequestParam(required = false) String role,
                                             @RequestParam(required = false) String status) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<User> users = userService.searchUsers(keyword, role, status);
            int count = userService.getFilteredUserCount(keyword, role, status);
            
            result.put("users", users);
            result.put("count", count);
            result.put("keyword", keyword);
            result.put("role", role);
            result.put("status", status);
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    // 新增：测试宠物分页功能
    @GetMapping("/pets/pagination")
    public Map<String, Object> testPetPagination(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "5") int size) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Pet> pets = petService.getPetsWithPagination(page, size);
            int totalCount = petService.getFilteredPetsCount(null, null, null, null);
            int totalPages = (int) Math.ceil((double) totalCount / size);
            
            result.put("pets", pets);
            result.put("currentPage", page);
            result.put("pageSize", size);
            result.put("totalPages", totalPages);
            result.put("totalCount", totalCount);
            result.put("success", true);
            result.put("message", "宠物分页功能测试成功");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/pets/search-pagination")
    public Map<String, Object> testPetSearchPagination(@RequestParam(required = false) String keyword,
                                                      @RequestParam(required = false) Long breedId,
                                                      @RequestParam(required = false) String status,
                                                      @RequestParam(required = false) String gender,
                                                      @RequestParam(defaultValue = "1") int page,
                                                      @RequestParam(defaultValue = "5") int size) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<Pet> pets = petService.searchPetsWithPagination(keyword, breedId, status, gender, page, size);
            int totalCount = petService.getFilteredPetsCount(keyword, breedId, status, gender);
            int totalPages = (int) Math.ceil((double) totalCount / size);
            
            result.put("pets", pets);
            result.put("currentPage", page);
            result.put("pageSize", size);
            result.put("totalPages", totalPages);
            result.put("totalCount", totalCount);
            result.put("keyword", keyword);
            result.put("breedId", breedId);
            result.put("status", status);
            result.put("gender", gender);
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    // 新增：测试宠物排序
    @GetMapping("/pets/sort-test")
    public Map<String, Object> testPetSorting() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 测试基础分页排序
            List<Pet> firstPage = petService.getPetsWithPagination(1, 5);
            List<Pet> secondPage = petService.getPetsWithPagination(2, 5);
            
            result.put("firstPage", firstPage);
            result.put("secondPage", secondPage);
            result.put("firstPageIds", firstPage.stream().map(Pet::getPetId).collect(java.util.stream.Collectors.toList()));
            result.put("secondPageIds", secondPage.stream().map(Pet::getPetId).collect(java.util.stream.Collectors.toList()));
            result.put("success", true);
            result.put("message", "宠物排序测试完成");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    // 新增：测试分页导航
    @GetMapping("/pets/pagination-nav-test")
    public Map<String, Object> testPaginationNavigation() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 使用现有的方法获取宠物总数
            List<Pet> allPets = petService.findAll();
            int totalCount = allPets.size();
            int pageSize = 5;
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            result.put("totalCount", totalCount);
            result.put("pageSize", pageSize);
            result.put("totalPages", totalPages);
            result.put("navigationStructure", "最上页 | 前一页 | 当前页 | 下一页 | 最下页");
            result.put("success", true);
            result.put("message", "分页导航测试完成");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    // 新增：测试分类管理功能
    @GetMapping("/categories")
    public Map<String, Object> testCategoryManagement() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 测试获取所有分类
            List<PetCategory> allCategories = categoryService.getAllCategories();
            result.put("allCategories", allCategories);
            result.put("totalCategories", allCategories.size());
            
            // 测试按显示顺序获取分类
            List<PetCategory> orderedCategories = categoryService.getCategoriesOrderByDisplayOrder();
            result.put("orderedCategories", orderedCategories);
            
            // 测试获取分类统计
            List<PetCategory> categoryStats = categoryService.getCategoryStats();
            result.put("categoryStats", categoryStats);
            
            result.put("success", true);
            result.put("message", "分类管理功能测试成功");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/categories/search")
    public Map<String, Object> testCategorySearch(@RequestParam(required = false) String name,
                                                 @RequestParam(required = false) String slug) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            List<PetCategory> categories = categoryService.getAllCategories();
            
            // 模拟搜索功能
            if (name != null && !name.isEmpty()) {
                categories = categories.stream()
                    .filter(c -> c.getName().toLowerCase().contains(name.toLowerCase()))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            if (slug != null && !slug.isEmpty()) {
                categories = categories.stream()
                    .filter(c -> c.getSlug().toLowerCase().contains(slug.toLowerCase()))
                    .collect(java.util.stream.Collectors.toList());
            }
            
            result.put("categories", categories);
            result.put("count", categories.size());
            result.put("name", name);
            result.put("slug", slug);
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/category-style")
    public String testCategoryStyle() {
        return "test/category_test";
    }
    
    @GetMapping("/category-style-test")
    public String testCategoryStyleDetailed() {
        return "test/category_style_test";
    }
    
    @GetMapping("/category-card-test")
    public String testCategoryCard() {
        return "test/category_card_test";
    }
    
    @GetMapping("/category-final-test")
    public String testCategoryFinal() {
        return "test/category_final_test";
    }
    
    @GetMapping("/category-stats-test")
    public String testCategoryStats() {
        return "test/category_stats_test";
    }
    
    @GetMapping("/analytics-test")
    public String testAnalytics(Model model) {
        logger.info("开始测试数据分析模块...");
        
        try {
            // 基础统计数据
            Map<String, Object> basicStats = new HashMap<>();
            basicStats.put("totalPets", petDao.getTotalPetsCount());
            basicStats.put("availablePets", petDao.getAvailablePetsCount());
            basicStats.put("totalUsers", userDao.getRegisteredUsersCount());
            basicStats.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            basicStats.put("pendingApplications", adoptionApplicationDao.getPendingApplicationsCount());
            basicStats.put("successfulAdoptions", adoptionApplicationDao.getSuccessfulAdoptionsCount());
            
            // 计算领养转化率
            int totalPets = petDao.getTotalPetsCount();
            int successfulAdoptions = adoptionApplicationDao.getSuccessfulAdoptionsCount();
            double adoptionRate = totalPets > 0 ? (double) successfulAdoptions / totalPets * 100 : 0;
            basicStats.put("adoptionRate", Math.round(adoptionRate * 10.0) / 10.0);

            model.addAttribute("basicStats", basicStats);

            // 图表数据 - 逐个测试，避免某个方法出错影响整体
            try {
                model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
                logger.info("宠物状态分布数据获取成功");
            } catch (Exception e) {
                logger.error("获取宠物状态分布数据失败", e);
                model.addAttribute("petStatusData", new ArrayList<>());
            }
            
            try {
                model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
                logger.info("宠物性别分布数据获取成功");
            } catch (Exception e) {
                logger.error("获取宠物性别分布数据失败", e);
                model.addAttribute("petGenderData", new ArrayList<>());
            }
            
            try {
                model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
                logger.info("用户角色分布数据获取成功");
            } catch (Exception e) {
                logger.error("获取用户角色分布数据失败", e);
                model.addAttribute("userRoleData", new ArrayList<>());
            }
            
            try {
                model.addAttribute("petBreedData", petBreedDao.getTopPetBreeds(5));
                logger.info("宠物品种数据获取成功");
            } catch (Exception e) {
                logger.error("获取宠物品种数据失败", e);
                model.addAttribute("petBreedData", new ArrayList<>());
            }
            
            try {
                model.addAttribute("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
                logger.info("领养趋势数据获取成功");
            } catch (Exception e) {
                logger.error("获取领养趋势数据失败", e);
                model.addAttribute("adoptionTrendData", new ArrayList<>());
            }
            
            try {
                model.addAttribute("categoryStats", categoryService.getCategoryStats());
                logger.info("分类统计数据获取成功");
            } catch (Exception e) {
                logger.error("获取分类统计数据失败", e);
                model.addAttribute("categoryStats", new ArrayList<>());
            }
            
            logger.info("数据分析模块测试完成");
            return "test/analytics_test";
            
        } catch (Exception e) {
            logger.error("数据分析模块测试失败", e);
            model.addAttribute("error", e.getMessage());
            return "test/analytics_test";
        }
    }
    
    @GetMapping("/simple-analytics-test")
    public String simpleAnalyticsTest(Model model) {
        logger.info("开始简单数据分析测试...");
        
        try {
            // 基础统计数据
            Map<String, Object> basicStats = new HashMap<>();
            basicStats.put("totalPets", petDao.getTotalPetsCount());
            basicStats.put("availablePets", petDao.getAvailablePetsCount());
            basicStats.put("totalUsers", userDao.getRegisteredUsersCount());
            basicStats.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            basicStats.put("pendingApplications", adoptionApplicationDao.getPendingApplicationsCount());
            basicStats.put("successfulAdoptions", adoptionApplicationDao.getSuccessfulAdoptionsCount());
            
            // 计算领养转化率
            int totalPets = petDao.getTotalPetsCount();
            int successfulAdoptions = adoptionApplicationDao.getSuccessfulAdoptionsCount();
            double adoptionRate = totalPets > 0 ? (double) successfulAdoptions / totalPets * 100 : 0;
            basicStats.put("adoptionRate", Math.round(adoptionRate * 10.0) / 10.0);

            model.addAttribute("basicStats", basicStats);

            // 图表数据
            model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
            model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
            model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
            model.addAttribute("categoryStats", categoryService.getCategoryStats());
            
            logger.info("简单数据分析测试完成");
            return "test/simple_analytics_test";
            
        } catch (Exception e) {
            logger.error("简单数据分析测试失败", e);
            model.addAttribute("error", e.getMessage());
            return "test/simple_analytics_test";
        }
    }

    @GetMapping("/test/analytics-debug")
    public String testAnalyticsDebug(Model model) {
        Map<String, Object> debugInfo = new HashMap<>();
        
        try {
            // 测试基础统计
            debugInfo.put("totalPets", petDao.getTotalPetsCount());
            debugInfo.put("availablePets", petDao.getAvailablePetsCount());
            debugInfo.put("totalUsers", userDao.getRegisteredUsersCount());
            debugInfo.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            
            // 测试图表数据
            debugInfo.put("petStatusData", petDao.getPetStatusDistribution());
            debugInfo.put("petGenderData", petDao.getPetGenderDistribution());
            debugInfo.put("userRoleData", userDao.getUserRoleDistribution());
            debugInfo.put("petBreedData", petBreedDao.getTopPetBreeds(5));
            debugInfo.put("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            debugInfo.put("categoryStats", categoryService.getCategoryStats());
            
            debugInfo.put("status", "success");
            debugInfo.put("message", "所有数据获取成功");
            
        } catch (Exception e) {
            debugInfo.put("status", "error");
            debugInfo.put("message", "数据获取失败: " + e.getMessage());
            debugInfo.put("error", e);
        }
        
        model.addAttribute("debugInfo", debugInfo);
        return "test/analytics_debug";
    }

    @GetMapping("/api/test/analytics-data")
    @ResponseBody
    public Map<String, Object> getAnalyticsData() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 基础统计
            result.put("totalPets", petDao.getTotalPetsCount());
            result.put("availablePets", petDao.getAvailablePetsCount());
            result.put("totalUsers", userDao.getRegisteredUsersCount());
            result.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            
            // 图表数据
            result.put("petStatusData", petDao.getPetStatusDistribution());
            result.put("petGenderData", petDao.getPetGenderDistribution());
            result.put("userRoleData", userDao.getUserRoleDistribution());
            result.put("petBreedData", petBreedDao.getTopPetBreeds(5));
            result.put("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            result.put("categoryStats", categoryService.getCategoryStats());
            
            result.put("success", true);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/chart-test")
    public String showChartTest() {
        return "analytics/chart_test";
    }
    
    @GetMapping("/data-test")
    public String showDataTest(Model model) {
        try {
            // 基础统计数据
            Map<String, Object> basicStats = new HashMap<>();
            basicStats.put("totalPets", petDao.getTotalPetsCount());
            basicStats.put("availablePets", petDao.getAvailablePetsCount());
            basicStats.put("totalUsers", userDao.getRegisteredUsersCount());
            basicStats.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            basicStats.put("successfulAdoptions", adoptionApplicationDao.getSuccessfulAdoptionsCount());
            
            // 计算领养转化率
            int totalPets = petDao.getTotalPetsCount();
            int successfulAdoptions = adoptionApplicationDao.getSuccessfulAdoptionsCount();
            double adoptionRate = totalPets > 0 ? (double) successfulAdoptions / totalPets * 100 : 0;
            basicStats.put("adoptionRate", Math.round(adoptionRate * 10.0) / 10.0);
            
            model.addAttribute("basicStats", basicStats);
            
            // 图表数据
            model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
            model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
            model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
            model.addAttribute("petBreedData", petBreedDao.getTopPetBreeds(5));
            model.addAttribute("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            model.addAttribute("categoryStats", categoryService.getCategoryStats());
            
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            e.printStackTrace();
        }
        
        return "analytics/data_test";
    }
    
    @GetMapping("/debug")
    public String showDebug(Model model) {
        try {
            // 基础统计数据
            Map<String, Object> basicStats = new HashMap<>();
            basicStats.put("totalPets", petDao.getTotalPetsCount());
            basicStats.put("availablePets", petDao.getAvailablePetsCount());
            basicStats.put("totalUsers", userDao.getRegisteredUsersCount());
            basicStats.put("totalApplications", adoptionApplicationDao.getTotalApplicationsCount());
            basicStats.put("successfulAdoptions", adoptionApplicationDao.getSuccessfulAdoptionsCount());
            
            // 计算领养转化率
            int totalPets = petDao.getTotalPetsCount();
            int successfulAdoptions = adoptionApplicationDao.getSuccessfulAdoptionsCount();
            double adoptionRate = totalPets > 0 ? (double) successfulAdoptions / totalPets * 100 : 0;
            basicStats.put("adoptionRate", Math.round(adoptionRate * 10.0) / 10.0);
            
            model.addAttribute("basicStats", basicStats);
            
            // 图表数据
            model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
            model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
            model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
            model.addAttribute("petBreedData", petBreedDao.getTopPetBreeds(5));
            model.addAttribute("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            model.addAttribute("categoryStats", categoryService.getCategoryStats());
            
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            e.printStackTrace();
        }
        
        return "analytics/debug";
    }
    
    @GetMapping("/breeds")
    public Map<String, Object> testBreedManagement() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 测试获取所有品种
            List<PetBreed> allBreeds = petBreedService.getAllPetBreeds();
            result.put("allBreeds", allBreeds);
            result.put("totalBreeds", allBreeds != null ? allBreeds.size() : 0);
            
            // 测试按护理难度统计
            if (allBreeds != null) {
                long lowCare = allBreeds.stream().filter(b -> "LOW".equals(b.getCareLevel())).count();
                long mediumCare = allBreeds.stream().filter(b -> "MEDIUM".equals(b.getCareLevel())).count();
                long highCare = allBreeds.stream().filter(b -> "HIGH".equals(b.getCareLevel())).count();
                
                result.put("lowCareCount", lowCare);
                result.put("mediumCareCount", mediumCare);
                result.put("highCareCount", highCare);
            }
            
            result.put("success", true);
            result.put("message", "品种管理功能测试成功");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    @GetMapping("/breeds/test")
    public String testBreedPage(Model model) {
        try {
            List<PetBreed> breeds = petBreedService.getAllPetBreeds();
            model.addAttribute("breeds", breeds);
            model.addAttribute("success", true);
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("success", false);
        }
        return "test/breed_test_simple";
    }
    
    @GetMapping("/permissions")
    public String testPermissions() {
        logger.info("显示权限测试页面");
        return "test_permissions";
    }
} 