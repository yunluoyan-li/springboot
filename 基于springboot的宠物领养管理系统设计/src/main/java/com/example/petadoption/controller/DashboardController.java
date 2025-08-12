package com.example.petadoption.controller;

import com.example.petadoption.mapper.PetDao;
import com.example.petadoption.mapper.UserDao;
import com.example.petadoption.mapper.AdoptionApplicationDao;
import com.example.petadoption.model.Pet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;

import java.util.List;

@Controller
public class DashboardController {

    @Autowired
    private PetDao petDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private AdoptionApplicationDao adoptionApplicationDao;

    @GetMapping("/dashboard")
    public String showDashboard(Model model, @RequestHeader(value = "X-Requested-With", required = false) String requestedWith) {
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

        // 如果是AJAX请求，返回内容模板；否则返回完整页面
        if ("XMLHttpRequest".equals(requestedWith)) {
            return "dashboard-content";
        } else {
            return "main";
        }
    }
}