package com.example.petadoption.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainRedirectController {
    @RequestMapping("/main")
    public String mainRedirect() {
        return "redirect:/users/main";
    }
} 