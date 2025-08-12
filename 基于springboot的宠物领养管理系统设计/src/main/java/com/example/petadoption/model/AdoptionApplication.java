package com.example.petadoption.model;

import java.util.Date;

public class AdoptionApplication {
    private Long applicationId;
    private Long petId; // 外键
    private Long userId; // 外键
    private String applicationText;
    private String homeDescription;
    private String experience;
    private String status; // "PENDING", "APPROVED"...
    private String adminNotes;
    private Date responseDate;
    private Date createdAt;

    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
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

    public String getApplicationText() {
        return applicationText;
    }

    public void setApplicationText(String applicationText) {
        this.applicationText = applicationText;
    }

    public String getHomeDescription() {
        return homeDescription;
    }

    public void setHomeDescription(String homeDescription) {
        this.homeDescription = homeDescription;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminNotes() {
        return adminNotes;
    }

    public void setAdminNotes(String adminNotes) {
        this.adminNotes = adminNotes;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "AdoptionApplication{" +
                "applicationId=" + applicationId +
                ", petId=" + petId +
                ", userId=" + userId +
                ", applicationText='" + applicationText + '\'' +
                ", homeDescription='" + homeDescription + '\'' +
                ", experience='" + experience + '\'' +
                ", status='" + status + '\'' +
                ", adminNotes='" + adminNotes + '\'' +
                ", responseDate=" + responseDate +
                ", createdAt=" + createdAt +
                '}';
    }
}