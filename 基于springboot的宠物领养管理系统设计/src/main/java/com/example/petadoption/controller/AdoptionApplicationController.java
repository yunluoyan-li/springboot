package com.example.petadoption.controller;

import com.example.petadoption.model.AdoptionApplication;
import com.example.petadoption.model.Pet;
import com.example.petadoption.model.User;
import com.example.petadoption.service.AdoptionApplicationService;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/adoption")
public class AdoptionApplicationController {

    private static final Logger logger = LoggerFactory.getLogger(AdoptionApplicationController.class);

    @Autowired
    private AdoptionApplicationService adoptionApplicationService;

    @Autowired
    private PetService petService;

    @Autowired
    private UserService userService;

    /**
     * 显示所有领养申请列表（管理员视图）
     */
    @GetMapping("/list")
    public String listApplications(Model model) {
        logger.info("显示所有领养申请列表");
        List<AdoptionApplication> applications = adoptionApplicationService.getAllApplications();
        model.addAttribute("applications", applications);
        return "adoption/list";
    }

    /**
     * 显示用户的领养申请列表
     */
    @GetMapping("/my-applications")
    public String myApplications(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/users/tologin";
        }
        
        logger.info("显示用户 {} 的领养申请列表", userId);
        List<AdoptionApplication> applications = adoptionApplicationService.getApplicationsByUserId(userId);
        model.addAttribute("applications", applications);
        return "adoption/myApplications";
    }

    /**
     * 显示申请领养表单
     */
    @GetMapping("/apply/{petId}")
    public String showApplyForm(@PathVariable Long petId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            logger.info("开始处理申请领养请求，宠物ID: {}", petId);
            
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                logger.warn("用户未登录，重定向到登录页面");
                return "redirect:/users/tologin";
            }
            
            logger.info("用户已登录，用户ID: {}", userId);

            // 获取宠物信息
            Pet pet = petService.getPetById(petId);
            if (pet == null) {
                logger.error("宠物不存在，宠物ID: {}", petId);
                redirectAttributes.addFlashAttribute("error", "宠物不存在");
                return "redirect:/pets/list";
            }
            
            logger.info("成功获取宠物信息: {}", pet.getName());

            // 检查用户是否已经申请过这个宠物
            try {
                if (adoptionApplicationService.hasUserAppliedForPet(userId, petId)) {
                    logger.warn("用户 {} 已经申请过宠物 {}", userId, petId);
                    redirectAttributes.addFlashAttribute("error", "该宠物已经被申请领养了");
                    return "redirect:/pets/list";
                }
            } catch (Exception e) {
                logger.error("检查用户申请状态时发生异常", e);
                // 继续执行，不阻止用户申请
            }

            model.addAttribute("pet", pet);
            model.addAttribute("application", new AdoptionApplication());
            return "adoption/apply";
            
        } catch (Exception e) {
            logger.error("处理申请领养请求时发生异常，宠物ID: {}", petId, e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试");
            return "redirect:/pets/list";
        }
    }

    /**
     * 提交领养申请
     */
    @PostMapping("/apply")
    public String submitApplication(@ModelAttribute AdoptionApplication application, 
                                  HttpSession session, 
                                  RedirectAttributes redirectAttributes) {
        try {
            logger.info("开始处理提交申请请求");
            
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                logger.warn("用户未登录，重定向到登录页面");
                return "redirect:/users/tologin";
            }

            logger.info("用户已登录，用户ID: {}", userId);
            logger.info("申请信息: petId={}, applicationText={}, homeDescription={}, experience={}", 
                       application.getPetId(), 
                       application.getApplicationText() != null ? application.getApplicationText().substring(0, Math.min(50, application.getApplicationText().length())) : "null",
                       application.getHomeDescription() != null ? application.getHomeDescription().substring(0, Math.min(50, application.getHomeDescription().length())) : "null",
                       application.getExperience());

            application.setUserId(userId);
            
            // 验证必填字段
            if (application.getPetId() == null) {
                logger.error("宠物ID为空");
                redirectAttributes.addFlashAttribute("error", "宠物信息错误");
                return "redirect:/pets/list";
            }
            
            if (application.getApplicationText() == null || application.getApplicationText().trim().isEmpty()) {
                logger.error("申请理由为空");
                redirectAttributes.addFlashAttribute("error", "请填写申请理由");
                return "redirect:/adoption/apply/" + application.getPetId();
            }
            
            if (application.getHomeDescription() == null || application.getHomeDescription().trim().isEmpty()) {
                logger.error("家庭环境描述为空");
                redirectAttributes.addFlashAttribute("error", "请填写家庭环境描述");
                return "redirect:/adoption/apply/" + application.getPetId();
            }
            
            logger.info("用户 {} 提交领养申请，宠物ID: {}", userId, application.getPetId());
            
            if (adoptionApplicationService.createApplication(application)) {
                logger.info("申请提交成功");
                redirectAttributes.addFlashAttribute("success", "申请提交成功，请等待审核");
            } else {
                logger.error("申请提交失败");
                redirectAttributes.addFlashAttribute("error", "申请提交失败，可能您已经申请过这个宠物");
            }
            
        } catch (Exception e) {
            logger.error("提交申请时发生异常", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试");
        }
        
        return "redirect:/adoption/my-applications";
    }

    /**
     * 查看申请详情
     */
    @GetMapping("/detail/{applicationId}")
    public String viewApplication(@PathVariable Long applicationId, Model model) {
        logger.info("开始查看申请详情，申请ID: {}", applicationId);
        
        try {
            AdoptionApplication application = adoptionApplicationService.getApplicationById(applicationId);
            if (application == null) {
                logger.error("申请不存在，申请ID: {}", applicationId);
                model.addAttribute("error", "申请不存在");
                return "redirect:/adoption/list";
            }
            
            logger.info("成功获取申请信息: {}", application);

            Pet pet = petService.getPetById(application.getPetId());
            if (pet == null) {
                logger.error("宠物不存在，宠物ID: {}", application.getPetId());
                model.addAttribute("error", "宠物信息不存在");
                return "redirect:/adoption/list";
            }
            
            logger.info("成功获取宠物信息: {}", pet.getName());

            User user = userService.getUserById(application.getUserId());
            if (user == null) {
                logger.error("用户不存在，用户ID: {}", application.getUserId());
                // 不返回错误，因为用户可能已被删除
            } else {
                logger.info("成功获取用户信息: {}", user.getUsername());
            }
            
            model.addAttribute("application", application);
            model.addAttribute("pet", pet);
            model.addAttribute("user", user);
            
            logger.info("准备返回详情页面");
            return "adoption/detail";
            
        } catch (Exception e) {
            logger.error("查看申请详情时发生异常，申请ID: {}", applicationId, e);
            model.addAttribute("error", "系统错误，请稍后重试");
            return "redirect:/adoption/list";
        }
    }

    /**
     * 审批申请 - 通过
     */
    @PostMapping("/approve/{applicationId}")
    public String approveApplication(@PathVariable Long applicationId, 
                                   @RequestParam String adminNotes,
                                   RedirectAttributes redirectAttributes) {
        logger.info("审批通过申请: {}", applicationId);
        
        if (adoptionApplicationService.approveApplication(applicationId, adminNotes)) {
            redirectAttributes.addFlashAttribute("success", "申请已通过");
        } else {
            redirectAttributes.addFlashAttribute("error", "审批失败");
        }
        
        return "redirect:/adoption/list";
    }

    /**
     * 审批申请 - 拒绝
     */
    @PostMapping("/reject/{applicationId}")
    public String rejectApplication(@PathVariable Long applicationId, 
                                  @RequestParam String adminNotes,
                                  RedirectAttributes redirectAttributes) {
        logger.info("拒绝申请: {}", applicationId);
        
        if (adoptionApplicationService.rejectApplication(applicationId, adminNotes)) {
            redirectAttributes.addFlashAttribute("success", "申请已拒绝");
        } else {
            redirectAttributes.addFlashAttribute("error", "操作失败");
        }
        
        return "redirect:/adoption/list";
    }

    /**
     * 删除申请
     */
    @GetMapping("/delete/{applicationId}")
    public String deleteApplication(@PathVariable Long applicationId, 
                                  RedirectAttributes redirectAttributes) {
        logger.info("删除申请: {}", applicationId);
        
        if (adoptionApplicationService.deleteApplication(applicationId)) {
            redirectAttributes.addFlashAttribute("success", "申请已删除");
        } else {
            redirectAttributes.addFlashAttribute("error", "删除失败");
        }
        
        return "redirect:/adoption/list";
    }

    /**
     * 获取统计数据（用于仪表板）
     */
    @GetMapping("/stats")
    @ResponseBody
    public Object getStats() {
        return new Object() {
            public final int pendingCount = adoptionApplicationService.getPendingApplicationsCount();
            public final int successfulCount = adoptionApplicationService.getSuccessfulAdoptionsCount();
        };
    }

    /**
     * 测试数据库插入操作
     */
    @GetMapping("/test-insert")
    @ResponseBody
    public String testInsert(HttpSession session) {
        try {
            logger.info("开始测试数据库插入操作");
            
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "用户未登录";
            }
            
            // 创建一个测试申请
            AdoptionApplication testApplication = new AdoptionApplication();
            testApplication.setPetId(1L);
            testApplication.setUserId(userId);
            testApplication.setApplicationText("测试申请理由");
            testApplication.setHomeDescription("测试家庭环境描述");
            testApplication.setExperience("测试养宠经验");
            testApplication.setStatus("PENDING");
            testApplication.setCreatedAt(new Date());
            
            logger.info("准备插入测试申请");
            boolean result = adoptionApplicationService.createApplication(testApplication);
            
            if (result) {
                return "测试插入成功";
            } else {
                return "测试插入失败";
            }
            
        } catch (Exception e) {
            logger.error("测试插入时发生异常", e);
            return "测试异常: " + e.getMessage();
        }
    }

    /**
     * 测试方法 - 用于诊断问题
     */
    @GetMapping("/test/{petId}")
    @ResponseBody
    public String testMethod(@PathVariable Long petId, HttpSession session) {
        try {
            logger.info("测试方法被调用，宠物ID: {}", petId);
            
            Long userId = (Long) session.getAttribute("userId");
            logger.info("用户ID: {}", userId);
            
            Pet pet = petService.getPetById(petId);
            if (pet == null) {
                return "宠物不存在";
            }
            
            return "宠物存在: " + pet.getName() + ", 品种: " + (pet.getBreed() != null ? pet.getBreed().getName() : "未知");
            
        } catch (Exception e) {
            logger.error("测试方法发生异常", e);
            return "错误: " + e.getMessage();
        }
    }

    /**
     * 测试查看功能
     */
    @GetMapping("/test-detail/{applicationId}")
    @ResponseBody
    public String testDetail(@PathVariable Long applicationId) {
        try {
            logger.info("测试查看功能，申请ID: {}", applicationId);
            
            AdoptionApplication application = adoptionApplicationService.getApplicationById(applicationId);
            if (application == null) {
                return "申请不存在，ID: " + applicationId;
            }
            
            StringBuilder result = new StringBuilder();
            result.append("申请信息:\n");
            result.append("ID: ").append(application.getApplicationId()).append("\n");
            result.append("宠物ID: ").append(application.getPetId()).append("\n");
            result.append("用户ID: ").append(application.getUserId()).append("\n");
            result.append("状态: ").append(application.getStatus()).append("\n");
            result.append("申请理由: ").append(application.getApplicationText()).append("\n");
            result.append("家庭描述: ").append(application.getHomeDescription()).append("\n");
            result.append("经验: ").append(application.getExperience()).append("\n");
            result.append("创建时间: ").append(application.getCreatedAt()).append("\n");
            
            Pet pet = petService.getPetById(application.getPetId());
            if (pet != null) {
                result.append("\n宠物信息:\n");
                result.append("名称: ").append(pet.getName()).append("\n");
                result.append("品种: ").append(pet.getBreed() != null ? pet.getBreed().getName() : "未知").append("\n");
            } else {
                result.append("\n宠物不存在，ID: ").append(application.getPetId()).append("\n");
            }
            
            User user = userService.getUserById(application.getUserId());
            if (user != null) {
                result.append("\n用户信息:\n");
                result.append("用户名: ").append(user.getUsername()).append("\n");
                result.append("邮箱: ").append(user.getEmail()).append("\n");
            } else {
                result.append("\n用户不存在，ID: ").append(application.getUserId()).append("\n");
            }
            
            return result.toString();
            
        } catch (Exception e) {
            logger.error("测试查看功能时发生异常", e);
            return "错误: " + e.getMessage();
        }
    }
}