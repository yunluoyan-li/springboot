package com.example.petadoption.controller.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/system")
@CrossOrigin(origins = "*")
public class SystemApiController {

    private static final Logger logger = LoggerFactory.getLogger(SystemApiController.class);

    /**
     * 获取系统信息（管理员功能）
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> getSystemInfo(HttpSession session) {
        try {
            // 检查用户是否登录
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "用户未登录");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorResponse);
            }
            
            // 检查用户角色
            String userRole = (String) session.getAttribute("userRole");
            if (!"ADMIN".equals(userRole)) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "权限不足，只有管理员可以访问系统信息");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorResponse);
            }
            
            // 构建系统信息
            Map<String, Object> systemInfo = new HashMap<>();
            systemInfo.put("version", "1.0.0");
            systemInfo.put("buildDate", "2025-01-XX");
            systemInfo.put("javaVersion", System.getProperty("java.version"));
            systemInfo.put("osName", System.getProperty("os.name"));
            systemInfo.put("osVersion", System.getProperty("os.version"));
            systemInfo.put("osArch", System.getProperty("os.arch"));
            systemInfo.put("userHome", System.getProperty("user.home"));
            systemInfo.put("userDir", System.getProperty("user.dir"));
            systemInfo.put("javaHome", System.getProperty("java.home"));
            systemInfo.put("fileEncoding", System.getProperty("file.encoding"));
            systemInfo.put("timeZone", System.getProperty("user.timezone"));
            
            // 内存信息
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();
            long usedMemory = totalMemory - freeMemory;
            long maxMemory = runtime.maxMemory();
            
            Map<String, Object> memoryInfo = new HashMap<>();
            memoryInfo.put("totalMemory", formatBytes(totalMemory));
            memoryInfo.put("freeMemory", formatBytes(freeMemory));
            memoryInfo.put("usedMemory", formatBytes(usedMemory));
            memoryInfo.put("maxMemory", formatBytes(maxMemory));
            memoryInfo.put("memoryUsage", Math.round((double) usedMemory / totalMemory * 100));
            
            systemInfo.put("memoryInfo", memoryInfo);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("systemInfo", systemInfo);
            
            logger.info("管理员 {} 获取系统信息", userId);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            logger.error("获取系统信息时发生异常", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "获取系统信息失败：" + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
    
    /**
     * 格式化字节数
     */
    private String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        int exp = (int) (Math.log(bytes) / Math.log(1024));
        String pre = "KMGTPE".charAt(exp-1) + "";
        return String.format("%.1f %sB", bytes / Math.pow(1024, exp), pre);
    }
} 