package com.example.petadoption.model;

import java.util.Date;

public class Favorite {
    private Long favoriteId;
    private Long userId; // 外键
    private Long petId; // 外键
    private Date createdAt;

    // 关联对象（可选，便于页面展示）
    private User user;
    private Pet pet;

    public Long getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(Long favoriteId) {
        this.favoriteId = favoriteId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getPetId() {
        return petId;
    }

    public void setPetId(Long petId) {
        this.petId = petId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Pet getPet() {
        return pet;
    }

    public void setPet(Pet pet) {
        this.pet = pet;
    }

    @Override
    public String toString() {
        return "Favorite{" +
                "favoriteId=" + favoriteId +
                ", userId=" + userId +
                ", petId=" + petId +
                ", createdAt=" + createdAt +
                '}';
    }
}