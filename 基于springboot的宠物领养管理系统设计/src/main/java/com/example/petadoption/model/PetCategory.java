package com.example.petadoption.model;

import java.util.Date;

public class PetCategory {
    private Integer categoryId;
    private String name;
    private String slug;
    private String description;
    private String iconUrl;
    private Integer displayOrder;
    private Date createdAt;
    private Integer breedCount; // 添加品种数量字段

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
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

    public Integer getBreedCount() {
        return breedCount;
    }

    public void setBreedCount(Integer breedCount) {
        this.breedCount = breedCount;
    }

    @Override
    public String toString() {
        return "PetCategory{" +
                "categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                ", description='" + description + '\'' +
                ", iconUrl='" + iconUrl + '\'' +
                ", displayOrder=" + displayOrder +
                ", createdAt=" + createdAt +
                ", breedCount=" + breedCount +
                '}';
    }
}