package com.example.petadoption.model;

import java.util.Date;

public class PetBreed {
    private Integer breedId;
    private Integer categoryId; // 外键
    private String breedName;
    private String origin;
    private String lifeSpan;
    private String temperament;
    private String careLevel; // "LOW", "MEDIUM", "HIGH"
    private String description;
    private Date createdAt;
    private String searchKeywords;

    // 无参构造方法
    public PetBreed() {
    }

    // 有参构造方法
    public PetBreed(Integer breedId, Integer categoryId, String breedName, String origin, String lifeSpan, String temperament, String careLevel, String description, Date createdAt, String searchKeywords) {
        this.breedId = breedId;
        this.categoryId = categoryId;
        this.breedName = breedName;
        this.origin = origin;
        this.lifeSpan = lifeSpan;
        this.temperament = temperament;
        this.careLevel = careLevel;
        this.description = description;
        this.createdAt = createdAt;
        this.searchKeywords = searchKeywords;
    }

    public Integer getBreedId() {
        return breedId;
    }

    public void setBreedId(Integer breedId) {
        this.breedId = breedId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getBreedName() {
        return breedName;
    }

    public void setBreedName(String breedName) {
        this.breedName = breedName;
    }



    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getLifeSpan() {
        return lifeSpan;
    }

    public void setLifeSpan(String lifeSpan) {
        this.lifeSpan = lifeSpan;
    }

    public String getTemperament() {
        return temperament;
    }

    public void setTemperament(String temperament) {
        this.temperament = temperament;
    }

    public String getCareLevel() {
        return careLevel;
    }

    public void setCareLevel(String careLevel) {
        this.careLevel = careLevel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getSearchKeywords() {
        return searchKeywords;
    }

    public void setSearchKeywords(String searchKeywords) {
        this.searchKeywords = searchKeywords;
    }

    @Override
    public String toString() {
        return "PetBreed{" +
                "breedId=" + breedId +
                ", categoryId=" + categoryId +
                ", breedName='" + breedName + '\'' +
                ", origin='" + origin + '\'' +
                ", lifeSpan='" + lifeSpan + '\'' +
                ", temperament='" + temperament + '\'' +
                ", careLevel='" + careLevel + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", searchKeywords='" + searchKeywords + '\'' +
                '}';
    }
}