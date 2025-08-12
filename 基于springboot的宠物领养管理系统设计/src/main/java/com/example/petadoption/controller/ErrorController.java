package com.example.petadoption.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class ErrorController implements org.springframework.boot.web.servlet.error.ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute("javax.servlet.error.status_code");
        Object message = request.getAttribute("javax.servlet.error.message");
        
        model.addAttribute("status", status);
        model.addAttribute("message", message);
        model.addAttribute("path", request.getAttribute("javax.servlet.error.request_uri"));
        
        return "error";
    }
} 