package com.example.petadoption.controller;

import com.example.petadoption.mapper.UserDao;
import com.example.petadoption.mapper.PetDao;
import com.example.petadoption.mapper.AdoptionApplicationDao;
import com.example.petadoption.model.User;
import com.example.petadoption.model.Pet;
import com.example.petadoption.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/users")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserDao userDao;

    @Autowired
    private PetDao petDao;

    @Autowired
    private AdoptionApplicationDao adoptionApplicationDao;

    public UserController(UserDao userDao) {
        this.userDao = userDao;
    }

    @Autowired
    private UserService userService;

    @RequestMapping(value = {"/", "/tologin"})
    public String toLogin() {
        return "login";
    }

    @RequestMapping("/main")
    public String main(Model model) {
        // 获取待领养宠物数量
        int availablePets = petDao.getAvailablePetsCount();
        // 获取新申请数量
        int newApplications = adoptionApplicationDao.getNewApplicationsCount();
        
        // 获取注册用户数量
        int registeredUsers = userDao.getRegisteredUsersCount();
        // 获取成功领养数量
        int successfulAdoptions = adoptionApplicationDao.getSuccessfulAdoptionsCount();

        // 获取宠物列表数据
        List<Pet> pets = petDao.findAll();

        model.addAttribute("availablePets", availablePets);
        model.addAttribute("newApplications", newApplications);
        model.addAttribute("registeredUsers", registeredUsers);
        model.addAttribute("successfulAdoptions", successfulAdoptions);
        model.addAttribute("pets", pets);

        return "main";
    }

    // @RequestMapping("/login")
    // public String login(@RequestParam("username") String username,
    //                     @RequestParam("password") String password,
    //                     HttpServletRequest request) {
    //     User user = userDao.findByUsername(username);
    //     HttpSession session = request.getSession();
    //     if (user == null) {
    //         request.setAttribute("msg", "用户不存在！");
    //         return "login";
    //     } else if (user.getPassword().equals(password)) {
    //         session.setAttribute("loginUser", username);
    //         session.setAttribute("userId", user.getUserId());
    //         session.setAttribute("userRole", user.getRole());
    //         session.setAttribute("loginUserObj", user);
    //         return "redirect:main";
    //     } else {
    //         request.setAttribute("msg", "密码错误！");
    //         return "login";
    //     }
    // }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String handleRegister(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String email,
            @RequestParam(required = false) String phone,  // phone 可选
            @RequestParam String address,
            Model model) {

        // 1. 验证密码一致性
        if (!password.equals(confirmPassword)) {
            model.addAttribute("msg", "两次密码输入不一致！");
            return "register";
        }

        // 2. 检查用户名是否已存在
        if (userDao.findByUsername(username) != null) {
            model.addAttribute("msg", "用户名已被占用！");
            return "register";
        }

        // 3. 检查邮箱是否已存在
        if (userDao.findByEmail(email) != null) {
            model.addAttribute("msg", "该邮箱已被注册，请使用其他邮箱。");
            return "register";
        }

        // 3. 创建用户对象并保存
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // 实际应加密存储！
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole("USER");
        user.setStatus("ACTIVE");
        user.setCreatedAt(new Date());
        user.setUpdatedAt(new Date());

        try {
            userDao.register(user);
            return "redirect:/users/login?registerSuccess=true";
        } catch (Exception e) {
            model.addAttribute("msg", "注册失败，请重试！");
            return "register";
        }
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }


    @GetMapping("/list")
    public String showUserList(Model model) {
        List<User> users = userDao.findAll();
        model.addAttribute("users", users);
        return "user/userList";
    }




    // 显示新增用户页面
    @GetMapping("/add")
    public String showAddUserPage(Model model) {
        model.addAttribute("user", new User());
        return "user/addUser";
    }

    @PostMapping("/add")
    public String addUser(@ModelAttribute User user, Model model, RedirectAttributes redirectAttributes) {
        logger.info("开始添加用户: {}", user.getUsername());
        
        // 验证必填字段
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            logger.error("用户名不能为空");
            model.addAttribute("error", "用户名不能为空！");
            return "user/addUser";
        }
        
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            logger.error("密码不能为空");
            model.addAttribute("error", "密码不能为空！");
            return "user/addUser";
        }
        
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            logger.error("邮箱不能为空");
            model.addAttribute("error", "邮箱不能为空！");
            return "user/addUser";
        }
        
        try {
            // 使用UserService进行用户注册
            User registeredUser = userService.register(user);
            logger.info("用户添加成功，ID: {}", registeredUser.getUserId());
            redirectAttributes.addFlashAttribute("success", "用户添加成功！");
            return "redirect:/users/list";
        } catch (RuntimeException e) {
            logger.error("用户添加失败: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "user/addUser";
        } catch (Exception e) {
            logger.error("用户添加时发生异常: {}", e.getMessage(), e);
            model.addAttribute("error", "用户添加失败，请重试！");
            return "user/addUser";
        }
    }

    // 显示编辑用户页面
    @GetMapping("/edit/{id}")
    public String showEditUserPage(@PathVariable Long id, Model model) {
        User user = userDao.findById(id);
        model.addAttribute("user", user);
        return "user/editUser";
    }

    // 处理编辑用户请求
    @PostMapping("/edit/{id}")
    public String editUser(@PathVariable Long id, @ModelAttribute User user) {
        user.setUserId(id);

        // 设置默认角色
        if (user.getRole() == null) {
            user.setRole("USER");
        }

        userDao.update(user);
        return "redirect:/users/list";
    }

    // 处理删除用户请求
    @GetMapping("/delete/{id}")
    public String deleteUser(@PathVariable Long id) {
        userDao.delete(id);
        return "redirect:/users/list";
    }

    // 登出方法
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/users/tologin";
    }
}