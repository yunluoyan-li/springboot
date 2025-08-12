package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.CommentDao;
import com.example.petadoption.model.Comment;
import com.example.petadoption.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentDao commentDao;

    @Override
    public List<Comment> getComments(String keyword, String status, Long petId, Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return commentDao.findAll(keyword, status, petId, userId, offset, size);
    }

    @Override
    public int getCommentCount(String keyword, String status, Long petId, Long userId) {
        return commentDao.getCount(keyword, status, petId, userId);
    }

    @Override
    public Comment getCommentById(Long commentId) {
        return commentDao.findById(commentId);
    }

    @Override
    public int addComment(Comment comment) {
        // 默认状态 PUBLISHED
        if (comment.getStatus() == null) {
            comment.setStatus("PUBLISHED");
        }
        return commentDao.insert(comment);
    }

    @Override
    public int updateComment(Comment comment) {
        return commentDao.update(comment);
    }

    @Override
    public int deleteComment(Long commentId) {
        return commentDao.delete(commentId);
    }

    @Override
    public int batchUpdateStatus(List<Long> ids, String status) {
        if (ids == null || ids.isEmpty() || status == null) return 0;
        return commentDao.updateStatusBatch(ids, status);
    }

    @Override
    public List<Comment> getCommentsByPetId(Long petId) {
        return commentDao.findByPetId(petId);
    }

    @Override
    public List<Comment> getCommentsByUserId(Long userId) {
        return commentDao.findByUserId(userId);
    }

    @Override
    public List<Comment> getRecentComments(int limit) {
        return commentDao.findRecent(limit);
    }

    @Override
    public Map<String, Object> getCommentStats() {
        return commentDao.getCommentStats();
    }
} 