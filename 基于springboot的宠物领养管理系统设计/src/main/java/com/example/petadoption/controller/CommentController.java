package com.example.petadoption.controller;

import com.example.petadoption.model.Comment;
import com.example.petadoption.service.CommentService;
import com.example.petadoption.service.UserService;
import com.example.petadoption.service.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;
    @Autowired
    private UserService userService;
    @Autowired
    private PetService petService;

    // 评论列表（分页、筛选、搜索）
    @GetMapping("/list")
    public String listComments(@RequestParam(value = "keyword", required = false) String keyword,
                              @RequestParam(value = "status", required = false) String status,
                              @RequestParam(value = "petId", required = false) Long petId,
                              @RequestParam(value = "userId", required = false) Long userId,
                              @RequestParam(value = "page", defaultValue = "1") int page,
                              @RequestParam(value = "size", defaultValue = "15") int size,
                              Model model) {
        List<Comment> comments = commentService.getComments(keyword, status, petId, userId, page, size);
        int totalCount = commentService.getCommentCount(keyword, status, petId, userId);
        int totalPages = (int) Math.ceil((double) totalCount / size);
        model.addAttribute("comments", comments);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("petId", petId);
        model.addAttribute("userId", userId);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("commentStats", commentService.getCommentStats());
        return "comment/list";
    }

    // 评论详情
    @GetMapping("/detail/{id}")
    public String commentDetail(@PathVariable("id") Long id, Model model) {
        Comment comment = commentService.getCommentById(id);
        model.addAttribute("comment", comment);
        return "comment/detail";
    }

    // 编辑评论页面
    @GetMapping("/edit/{id}")
    public String editCommentForm(@PathVariable("id") Long id, Model model) {
        Comment comment = commentService.getCommentById(id);
        model.addAttribute("comment", comment);
        return "comment/edit";
    }

    // 处理编辑评论
    @PostMapping("/edit")
    public String editComment(@ModelAttribute Comment comment, RedirectAttributes redirectAttributes) {
        if (commentService.updateComment(comment) > 0) {
            redirectAttributes.addFlashAttribute("success", "评论更新成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "评论更新失败");
        }
        return "redirect:/comments/list";
    }

    // 删除评论
    @GetMapping("/delete/{id}")
    public String deleteComment(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        if (commentService.deleteComment(id) > 0) {
            redirectAttributes.addFlashAttribute("success", "评论删除成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "评论删除失败");
        }
        return "redirect:/comments/list";
    }

    // 审核/修改状态（单个）
    @PostMapping("/audit/{id}")
    public String auditComment(@PathVariable("id") Long id, @RequestParam("status") String status, RedirectAttributes redirectAttributes) {
        Comment comment = commentService.getCommentById(id);
        if (comment != null) {
            comment.setStatus(status);
            if (commentService.updateComment(comment) > 0) {
                redirectAttributes.addFlashAttribute("success", "评论状态已更新");
            } else {
                redirectAttributes.addFlashAttribute("error", "评论状态更新失败");
            }
        }
        return "redirect:/comments/list";
    }

    // 批量审核/修改状态
    @PostMapping("/batch-audit")
    public String batchAudit(@RequestParam("ids") String ids,
                             @RequestParam("status") String status,
                             RedirectAttributes redirectAttributes) {
        List<Long> idList = Arrays.stream(ids.split(",")).map(Long::parseLong).collect(Collectors.toList());
        int updated = commentService.batchUpdateStatus(idList, status);
        if (updated > 0) {
            redirectAttributes.addFlashAttribute("success", "批量审核成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "批量审核失败");
        }
        return "redirect:/comments/list";
    }

    // 新增评论页面（后台手动添加）
    @GetMapping("/add")
    public String addCommentForm(Model model, HttpSession session) {
        model.addAttribute("comment", new Comment());
        model.addAttribute("pets", petService.findAll());
        // 不再传递users
        return "comment/add";
    }

    // 处理新增评论
    @PostMapping("/add")
    public String addComment(@ModelAttribute Comment comment, HttpSession session, RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录后再评论");
            return "redirect:/login";
        }
        comment.setUserId(userId); // 强制用当前登录用户
        if (commentService.addComment(comment) > 0) {
            redirectAttributes.addFlashAttribute("success", "评论添加成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "评论添加失败");
        }
        return "redirect:/comments/list";
    }
} 