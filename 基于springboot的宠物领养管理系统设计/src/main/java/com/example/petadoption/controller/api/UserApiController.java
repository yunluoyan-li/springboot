package com.example.petadoption.controller.api;

import com.example.petadoption.model.User;
import com.example.petadoption.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@Order(1)
public class UserApiController {

    private static final Logger logger = LoggerFactory.getLogger(UserApiController.class);

    @Autowired
    private UserService userService;

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest, 
                                                    HttpSession session) {
        try {
            String username = loginRequest.get("username");
            String password = loginRequest.get("password");
            
            logger.info("API: 用户登录 - 用户名: {}", username);
            
            if (username == null || password == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户名和密码不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            User user = userService.login(username, password);
            if (user != null) {
                // 设置session
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("loginUser", user.getUsername()); // 新增，供欢迎语显示
                session.setAttribute("loginUserObj", user); // 新增，供收藏管理等功能使用
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "登录成功");
                response.put("user", user);
                
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户名或密码错误");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("用户登录时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "登录失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody User user) {
        try {
            logger.info("API: 用户注册 - 用户名: {}", user.getUsername());
            
            // 验证必填字段
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户名不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "密码不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "邮箱不能为空");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            // 检查用户名是否已存在
            User existingUser = userService.getUserByUsername(user.getUsername());
            if (existingUser != null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户名已存在");
                return ResponseEntity.badRequest().body(errorResponse);
            }
            
            // 设置默认角色
            if (user.getRole() == null) {
                user.setRole("USER");
            }
            
            User savedUser = userService.register(user);
            if (savedUser != null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "注册成功");
                response.put("user", savedUser);
                
                return ResponseEntity.status(HttpStatus.CREATED).body(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "注册失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("用户注册时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "注册失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 用户登出
     */
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        try {
            logger.info("API: 用户登出");
            
            session.invalidate();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "登出成功");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("用户登出时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "登出失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/current")
    public ResponseEntity<Map<String, Object>> getCurrentUser(HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            User user = userService.getUserById(userId);
            if (user == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户不存在");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse);
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("user", user);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取当前用户信息时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取用户信息失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 获取所有用户（管理员功能）
     */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllUsers(HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");
            
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            List<User> users = userService.getAllUsers();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("users", users);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取所有用户时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取用户列表失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateUser(@PathVariable Long id, 
                                                         @RequestBody User user,
                                                         HttpSession session) {
        try {
            Long currentUserId = (Long) session.getAttribute("userId");
            String userRole = (String) session.getAttribute("userRole");
            
            if (currentUserId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            // 只能更新自己的信息，或者管理员可以更新任何用户
            if (!currentUserId.equals(id) && !"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            user.setUserId(id);
            boolean updated = userService.updateUser(user);
            
            if (updated) {
                // 获取更新后的用户信息
                User updatedUser = userService.getUserById(id);
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "用户信息更新成功");
                response.put("user", updatedUser);
                
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户信息更新失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("更新用户信息时发生异常，ID: {}", id, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "更新用户信息失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * 删除用户（管理员功能）
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteUser(@PathVariable Long id, HttpSession session) {
        try {
            String userRole = (String) session.getAttribute("userRole");
            
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            boolean deleted = userService.deleteUser(id);
            if (deleted) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "用户删除成功");
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户删除失败");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
            
        } catch (Exception e) {
            logger.error("删除用户时发生异常，ID: {}", id, e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "删除用户失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
} 