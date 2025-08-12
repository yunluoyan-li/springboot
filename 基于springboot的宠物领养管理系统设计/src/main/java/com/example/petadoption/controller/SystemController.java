package com.example.petadoption.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/system")
public class SystemController {

    @GetMapping("/info")
    public String showSystemInfo(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        // 检查用户是否登录
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/login";
        }
        
        // 检查用户角色
        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            redirectAttributes.addFlashAttribute("error", "权限不足，只有管理员可以访问系统信息");
            return "redirect:/main";
        }
        
        // 可以在这里添加一些动态的系统信息
        Map<String, Object> systemInfo = new HashMap<>();
        systemInfo.put("version", "1.0.0");
        systemInfo.put("buildDate", "2025-01-XX");
        systemInfo.put("javaVersion", System.getProperty("java.version"));
        systemInfo.put("osName", System.getProperty("os.name"));
        systemInfo.put("osVersion", System.getProperty("os.version"));
        
        model.addAttribute("systemInfo", systemInfo);
        return "system/info";
    }
} 