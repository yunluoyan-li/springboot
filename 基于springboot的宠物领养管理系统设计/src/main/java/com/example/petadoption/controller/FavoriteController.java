package com.example.petadoption.controller;

import com.example.petadoption.model.Favorite;
import com.example.petadoption.model.Pet;
import com.example.petadoption.model.User;
import com.example.petadoption.service.FavoriteService;
import com.example.petadoption.service.PetService;
import com.example.petadoption.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/favorites")
public class FavoriteController {
    @Autowired
    private FavoriteService favoriteService;
    @Autowired
    private UserService userService;
    @Autowired
    private PetService petService;

    @GetMapping("/list")
    public String listFavorites(Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUserObj");
        String role = (String) session.getAttribute("userRole");
        List<Favorite> favorites;
        if ("ADMIN".equals(role)) {
            favorites = favoriteService.findAll();
        } else {
            favorites = favoriteService.findByUserId(loginUser.getUserId());
        }
        model.addAttribute("favorites", favorites);
        model.addAttribute("isAdmin", "ADMIN".equals(role));
        return "favorites/list";
    }

    @PostMapping("/add")
    public String addFavorite(@RequestParam Long petId, HttpSession session, RedirectAttributes redirectAttributes) {
        User loginUser = (User) session.getAttribute("loginUserObj");
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/favorites/list";
        }
        Favorite favorite = new Favorite();
        favorite.setUserId(loginUser.getUserId());
        favorite.setPetId(petId);
        favoriteService.addFavorite(favorite);
        redirectAttributes.addFlashAttribute("success", "收藏成功");
        return "redirect:/favorites/list";
    }

    @PostMapping("/delete")
    public String deleteFavorite(@RequestParam Long favoriteId, HttpSession session, RedirectAttributes redirectAttributes) {
        User loginUser = (User) session.getAttribute("loginUserObj");
        String role = (String) session.getAttribute("userRole");
        Favorite favorite = favoriteService.findById(favoriteId);
        if (favorite == null) {
            redirectAttributes.addFlashAttribute("error", "收藏不存在");
            return "redirect:/favorites/list";
        }
        if (!"ADMIN".equals(role) && !favorite.getUserId().equals(loginUser.getUserId())) {
            redirectAttributes.addFlashAttribute("error", "无权删除他人的收藏");
            return "redirect:/favorites/list";
        }
        favoriteService.deleteFavorite(favoriteId);
        redirectAttributes.addFlashAttribute("success", "删除成功");
        return "redirect:/favorites/list";
    }

    // 可选：编辑收藏（一般不需要）
    // @PostMapping("/update")
    // public String updateFavorite(...) { ... }
} 