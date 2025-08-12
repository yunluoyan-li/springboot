package com.example.petadoption.model;

import java.util.Date;

public class PetImage {
    private Long imageId;
    private Long petId; // 外键
    private String imageUrl;
    private Boolean isPrimary;
    private Integer displayOrder;
    private Date createdAt;

    public Long getImageId() {
        return imageId;
    }

    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }

    public Long getPetId() {
        return petId;
    }

    public void setPetId(Long petId) {
        this.petId = petId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getPrimary() {
        return isPrimary;
    }

    public void setPrimary(Boolean primary) {
        isPrimary = primary;
    }

    public Integer getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "PetImage{" +
                "imageId=" + imageId +
                ", petId=" + petId +
                ", imageUrl='" + imageUrl + '\'' +
                ", isPrimary=" + isPrimary +
                ", displayOrder=" + displayOrder +
                ", createdAt=" + createdAt +
                '}';
    }
}