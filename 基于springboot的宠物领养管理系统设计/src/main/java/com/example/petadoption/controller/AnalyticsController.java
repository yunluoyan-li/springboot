package com.example.petadoption.controller;

import com.example.petadoption.mapper.PetDao;
import com.example.petadoption.mapper.UserDao;
import com.example.petadoption.mapper.AdoptionApplicationDao;
import com.example.petadoption.mapper.PetBreedDao;
import com.example.petadoption.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AnalyticsController {

    @Autowired
    private PetDao petDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private AdoptionApplicationDao adoptionApplicationDao;

    @Autowired
    private PetBreedDao petBreedDao;

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/analytics")
    public String showAnalytics(Model model) {
        try {
            // 基础统计数据 - 逐个测试，避免某个方法出错影响整体
            Map<String, Object> basicStats = new HashMap<>();
            
            try {
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
            } catch (Exception e) {
                System.err.println("基础统计数据获取失败: " + e.getMessage());
                model.addAttribute("basicStats", new HashMap<>());
            }

            // 图表数据 - 逐个测试
            try {
                model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
            } catch (Exception e) {
                System.err.println("宠物状态分布数据获取失败: " + e.getMessage());
                model.addAttribute("petStatusData", Arrays.asList());
            }
            
            try {
                model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
            } catch (Exception e) {
                System.err.println("宠物性别分布数据获取失败: " + e.getMessage());
                model.addAttribute("petGenderData", Arrays.asList());
            }
            
            try {
                model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
            } catch (Exception e) {
                System.err.println("用户角色分布数据获取失败: " + e.getMessage());
                model.addAttribute("userRoleData", Arrays.asList());
            }
            
            try {
                model.addAttribute("petBreedData", petBreedDao.getTopPetBreeds(5));
            } catch (Exception e) {
                System.err.println("宠物品种数据获取失败: " + e.getMessage());
                model.addAttribute("petBreedData", Arrays.asList());
            }
            
            try {
                model.addAttribute("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            } catch (Exception e) {
                System.err.println("领养趋势数据获取失败: " + e.getMessage());
                model.addAttribute("adoptionTrendData", Arrays.asList());
            }
            
            try {
                model.addAttribute("categoryStats", categoryService.getCategoryStats());
            } catch (Exception e) {
                System.err.println("分类统计数据获取失败: " + e.getMessage());
                model.addAttribute("categoryStats", Arrays.asList());
            }
            
            model.addAttribute("monthlyStatsData", getMonthlyStatsData());

            return "analytics/dashboard";
            
        } catch (Exception e) {
            System.err.println("数据分析页面加载失败: " + e.getMessage());
            e.printStackTrace();
            // 返回一个简单的错误页面
            model.addAttribute("error", "数据分析页面加载失败: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/api/analytics/chart-data")
    @ResponseBody
    public Map<String, Object> getChartData() {
        Map<String, Object> chartData = new HashMap<>();
        
        try {
            chartData.put("petStatus", petDao.getPetStatusDistribution());
            chartData.put("petGender", petDao.getPetGenderDistribution());
            chartData.put("userRole", userDao.getUserRoleDistribution());
            chartData.put("petBreed", petBreedDao.getTopPetBreeds(5));
            chartData.put("adoptionTrend", adoptionApplicationDao.getAdoptionTrendData());
            chartData.put("monthlyStats", getMonthlyStatsData());
            chartData.put("categoryStats", categoryService.getCategoryStats());
        } catch (Exception e) {
            chartData.put("error", e.getMessage());
        }
        
        return chartData;
    }

    private Map<String, Object> getMonthlyStatsData() {
        Map<String, Object> monthlyStats = new HashMap<>();
        
        // 模拟月度数据，实际项目中应该从数据库查询
        monthlyStats.put("labels", Arrays.asList("1月", "2月", "3月", "4月", "5月", "6月"));
        monthlyStats.put("newPets", Arrays.asList(15, 18, 22, 25, 20, 28));
        monthlyStats.put("newUsers", Arrays.asList(10, 12, 15, 18, 16, 22));
        
        return monthlyStats;
    }
    
    @GetMapping("/analytics-simple")
    public String showSimpleAnalytics(Model model) {
        try {
            // 获取图表数据
            model.addAttribute("petStatusData", petDao.getPetStatusDistribution());
            model.addAttribute("petGenderData", petDao.getPetGenderDistribution());
            model.addAttribute("userRoleData", userDao.getUserRoleDistribution());
            model.addAttribute("petBreedData", petBreedDao.getTopPetBreeds(5));
            model.addAttribute("adoptionTrendData", adoptionApplicationDao.getAdoptionTrendData());
            
            return "analytics/simple_dashboard";
            
        } catch (Exception e) {
            System.err.println("简化数据分析页面加载失败: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "简化数据分析页面加载失败: " + e.getMessage());
            return "error";
        }
    }
    
    @GetMapping("/analytics-basic")
    public String showBasicAnalytics(Model model) {
        // 最基础的测试，完全不调用数据库
        model.addAttribute("message", "基础测试页面加载成功！");
        model.addAttribute("timestamp", new java.util.Date());
        return "analytics/basic_test";
    }
} 