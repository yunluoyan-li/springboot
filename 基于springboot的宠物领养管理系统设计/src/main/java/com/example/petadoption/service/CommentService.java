package com.example.petadoption.service;

import com.example.petadoption.model.Comment;
import java.util.List;
import java.util.Map;

public interface CommentService {
    // 分页查询评论（可筛选）
    List<Comment> getComments(String keyword, String status, Long petId, Long userId, int page, int size);

    // 获取评论总数（可筛选）
    int getCommentCount(String keyword, String status, Long petId, Long userId);

    // 根据ID获取评论
    Comment getCommentById(Long commentId);

    // 新增评论
    int addComment(Comment comment);

    // 更新评论内容/状态
    int updateComment(Comment comment);

    // 删除评论
    int deleteComment(Long commentId);

    // 批量审核/修改状态
    int batchUpdateStatus(List<Long> ids, String status);

    // 查询某宠物的所有评论
    List<Comment> getCommentsByPetId(Long petId);

    // 查询某用户的所有评论
    List<Comment> getCommentsByUserId(Long userId);

    // 查询最新评论
    List<Comment> getRecentComments(int limit);

    // 评论统计
    Map<String, Object> getCommentStats();
} 