package com.example.petadoption.controller.api;

import com.example.petadoption.model.AdoptionApplication;
import com.example.petadoption.model.Pet;
import com.example.petadoption.model.User;
import com.example.petadoption.service.AdoptionApplicationService;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.UserService;
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
@RequestMapping("/api/adoption")
@CrossOrigin(origins = "*")
public class AdoptionApiController {

    private static final Logger logger = LoggerFactory.getLogger(AdoptionApiController.class);

    @Autowired
    private AdoptionApplicationService adoptionApplicationService;

    @Autowired
    private PetService petService;

    @Autowired
    private UserService userService;

    /**
     * 获取所有领养申请（管理员功能）
     */
    @GetMapping("/applications")
    public ResponseEntity<Map<String, Object>> getAllApplications(HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            List<AdoptionApplication> applications = adoptionApplicationService.getAllApplications();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("applications", applications);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取所有领养申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取申请列表失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取用户的领养申请
     */
    @GetMapping("/my-applications")
    public ResponseEntity<Map<String, Object>> getMyApplications(HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            List<AdoptionApplication> applications = adoptionApplicationService.getApplicationsByUserId(userId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("applications", applications);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取用户领养申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取申请列表失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 检查用户是否已申请某个宠物
     */
    @GetMapping("/check-application/{petId}")
    public ResponseEntity<Map<String, Object>> checkApplication(@PathVariable Long petId, HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            boolean hasApplied = adoptionApplicationService.hasUserAppliedForPet(userId, petId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("hasApplied", hasApplied);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("检查申请状态时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "检查申请状态失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 提交领养申请
     */
    @PostMapping("/apply")
    public ResponseEntity<Map<String, Object>> submitApplication(@RequestBody AdoptionApplication application, 
                                                                HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            application.setUserId(userId);
            
            // 验证必填字段
            if (application.getPetId() == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "宠物信息错误");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (application.getApplicationText() == null || application.getApplicationText().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请填写申请理由");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (application.getHomeDescription() == null || application.getHomeDescription().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "请填写家庭环境描述");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            // 检查是否已经申请过
            if (adoptionApplicationService.hasUserAppliedForPet(userId, application.getPetId())) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "您已经申请过这个宠物了");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            boolean success = adoptionApplicationService.createApplication(application);
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "申请提交成功，请等待审核");
                return ResponseEntity.status(HttpStatus.CREATED).body(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "申请提交失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("提交申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "提交申请失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取申请详情
     */
    @GetMapping("/application/{applicationId}")
    public ResponseEntity<Map<String, Object>> getApplicationDetail(@PathVariable Long applicationId, 
                                                                  HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");
            
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            AdoptionApplication application = adoptionApplicationService.getApplicationById(applicationId);
            if (application == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "申请不存在");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
            }
            
            // 检查权限：只能查看自己的申请或管理员可以查看所有
            if (!userId.equals(application.getUserId()) && !"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            // 获取相关数据
            Pet pet = petService.getPetById(application.getPetId());
            User user = userService.getUserById(application.getUserId());
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("application", application);
            response.put("pet", pet);
            response.put("user", user);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取申请详情时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取申请详情失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 审批申请 - 通过（管理员功能）
     */
    @PostMapping("/approve/{applicationId}")
    public ResponseEntity<Map<String, Object>> approveApplication(@PathVariable Long applicationId,
                                                                @RequestBody Map<String, String> request,
                                                                HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            String adminNotes = request.get("adminNotes");
            
            boolean success = adoptionApplicationService.approveApplication(applicationId, adminNotes);
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "申请已通过");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "审批失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("审批申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "审批失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 审批申请 - 拒绝（管理员功能）
     */
    @PostMapping("/reject/{applicationId}")
    public ResponseEntity<Map<String, Object>> rejectApplication(@PathVariable Long applicationId,
                                                               @RequestBody Map<String, String> request,
                                                               HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            String adminNotes = request.get("adminNotes");
            if (adminNotes == null || adminNotes.trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "拒绝原因不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            boolean success = adoptionApplicationService.rejectApplication(applicationId, adminNotes);
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "申请已拒绝");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "操作失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("拒绝申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "操作失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 删除申请（管理员功能）
     */
    @DeleteMapping("/application/{applicationId}")
    public ResponseEntity<Map<String, Object>> deleteApplication(@PathVariable Long applicationId, 
                                                                HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            boolean success = adoptionApplicationService.deleteApplication(applicationId);
            if (success) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "申请删除成功");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "删除失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("删除申请时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "删除失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取申请统计数据
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getAdoptionStats(HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            int pendingCount = adoptionApplicationService.getPendingApplicationsCount();
            int successfulCount = adoptionApplicationService.getSuccessfulAdoptionsCount();
            
            Map<String, Object> stats = new HashMap<>();
            stats.put("pendingCount", pendingCount);
            stats.put("successfulCount", successfulCount);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("stats", stats);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取申请统计数据时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取统计数据失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
} 