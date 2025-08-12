package com.example.petadoption.controller;

import com.example.petadoption.mapper.UserDao;
import com.example.petadoption.model.User;
import com.example.petadoption.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/userManagement")
public class UserManagementController {

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public String listUsers(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "userList";
    }
    
    // 新增：条件搜索用户
    @GetMapping("/search")
    public String searchUsers(@RequestParam(required = false) String keyword,
                            @RequestParam(required = false) String role,
                            @RequestParam(required = false) String status,
                            Model model) {
        List<User> users = userService.searchUsers(keyword, role, status);
        int totalCount = userService.getFilteredUserCount(keyword, role, status);
        
        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        model.addAttribute("role", role);
        model.addAttribute("status", status);
        model.addAttribute("totalCount", totalCount);
        
        return "userList";
    }
    
    // 新增：分页查询用户
    @GetMapping("/list/page")
    public String listUsersWithPagination(@RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "10") int size,
                                        Model model) {
        List<User> users = userService.getUsersWithPagination(page, size);
        int totalCount = userService.getTotalUserCount();
        int totalPages = (int) Math.ceil((double) totalCount / size);
        
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        
        return "userList";
    }
    
    // 新增：根据角色查询用户
    @GetMapping("/list/role/{role}")
    public String getUsersByRole(@PathVariable String role, Model model) {
        List<User> users = userService.getUsersByRole(role);
        model.addAttribute("users", users);
        model.addAttribute("selectedRole", role);
        return "userList";
    }
    
    // 新增：根据状态查询用户
    @GetMapping("/list/status/{status}")
    public String getUsersByStatus(@PathVariable String status, Model model) {
        List<User> users = userService.getUsersByStatus(status);
        model.addAttribute("users", users);
        model.addAttribute("selectedStatus", status);
        return "userList";
    }

    @GetMapping("/edit/{id}")
    public String editUser(@PathVariable("id") Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "editUser";
    }

    @PostMapping("/update")
    public String updateUser(@ModelAttribute User user) {
        userService.updateUser(user);
        return "redirect:/userManagement/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id);
        return "redirect:/userManagement/list";
    }
}