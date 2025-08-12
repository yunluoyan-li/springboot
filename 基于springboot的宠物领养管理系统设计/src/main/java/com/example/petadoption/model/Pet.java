package com.example.petadoption.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Pet {
    private Long petId;
    private Integer breedId; // 外键
    private String name;
    private Integer age;
    private String gender; // "MALE", "FEMALE", "UNKNOWN"
    private String color;
    private String size; // "SMALL", "MEDIUM", "LARGE"
    private String healthStatus; // "EXCELLENT", "GOOD"...
    private String description;
    private String story;
    private String status; // "AVAILABLE", "PENDING"...
    private String source; // "SHELTER", "RESCUE"...
    private Integer crawlerDataId;
    private Boolean featured;
    private Integer viewCount;
    private List<PetImage> images;
    private List<AdoptionApplication> applications;
    private List<Tag> tags;

    private Breed breed;

    public Breed getBreed() {
        return breed;
    }

    public void setBreed(Breed breed) {
        this.breed = breed;
    }

    public static class Breed {
        private Integer breedId;
        private String name;

        public Integer getBreedId() {
            return breedId;
        }

        public void setBreedId(Integer breedId) {
            this.breedId = breedId;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

    // 添加构造函数
    public Pet() {
        this.images = new ArrayList<>();
        this.applications = new ArrayList<>();
        this.tags = new ArrayList<>();
    }

    public Long getPetId() {
        return petId;
    }

    public void setPetId(Long petId) {
        this.petId = petId;
    }

    public Integer getBreedId() {
        return breedId;
    }

    public void setBreedId(Integer breedId) {
        this.breedId = breedId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
    }



    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStory() {
        return story;
    }

    public void setStory(String story) {
        this.story = story;
    }



    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public Integer getCrawlerDataId() {
        return crawlerDataId;
    }

    public void setCrawlerDataId(Integer crawlerDataId) {
        this.crawlerDataId = crawlerDataId;
    }

    public Boolean getFeatured() {
        return featured;
    }

    public void setFeatured(Boolean featured) {
        this.featured = featured;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }



    public List<PetImage> getImages() {
        return images;
    }

    public void setImages(List<PetImage> images) {
        this.images = images;
    }

    public List<AdoptionApplication> getApplications() {
        return applications;
    }

    public void setApplications(List<AdoptionApplication> applications) {
        this.applications = applications;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    @Override
    public String toString() {
        return "Pet{" +
                "petId=" + petId +
                ", breedId=" + breedId +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", gender='" + gender + '\'' +
                ", color='" + color + '\'' +
                ", size='" + size + '\'' +
                ", healthStatus='" + healthStatus + '\'' +
                ", description='" + description + '\'' +
                ", story='" + story + '\'' +
                ", status='" + status + '\'' +
                ", source='" + source + '\'' +
                ", crawlerDataId=" + crawlerDataId +
                ", featured=" + featured +
                ", viewCount=" + viewCount +
                ", images=" + images +
                ", applications=" + applications +
                ", tags=" + tags +
                '}';
    }
}