package com.example.petadoption.model;

import java.util.Date;

public class Comment {
    private Long commentId;
    private Long petId; // 外键
    private Long userId; // 外键
    private Long parentId; // 自关联
    private String content;
    private String status; // "PUBLISHED", "HIDDEN"...
    private Date createdAt;

    public Long getCommentId() {
        return commentId;
    }

    public void setCommentId(Long commentId) {
        this.commentId = commentId;
    }

    public Long getPetId() {
        return petId;
    }

    public void setPetId(Long petId) {
        this.petId = petId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Comment{" +
                "commentId=" + commentId +
                ", petId=" + petId +
                ", userId=" + userId +
                ", parentId=" + parentId +
                ", content='" + content + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}