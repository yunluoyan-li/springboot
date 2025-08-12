package com.example.petadoption.service;

import com.example.petadoption.model.AdoptionApplication;
import java.util.List;

public interface AdoptionApplicationService {
    
    /**
     * 获取所有领养申请
     */
    List<AdoptionApplication> getAllApplications();
    
    /**
     * 根据ID获取领养申请
     */
    AdoptionApplication getApplicationById(Long applicationId);
    
    /**
     * 根据用户ID获取领养申请
     */
    List<AdoptionApplication> getApplicationsByUserId(Long userId);
    
    /**
     * 根据宠物ID获取领养申请
     */
    List<AdoptionApplication> getApplicationsByPetId(Long petId);
    
    /**
     * 创建新的领养申请
     */
    boolean createApplication(AdoptionApplication application);
    
    /**
     * 更新领养申请
     */
    boolean updateApplication(AdoptionApplication application);
    
    /**
     * 删除领养申请
     */
    boolean deleteApplication(Long applicationId);
    
    /**
     * 审批领养申请
     */
    boolean approveApplication(Long applicationId, String adminNotes);
    
    /**
     * 拒绝领养申请
     */
    boolean rejectApplication(Long applicationId, String adminNotes);
    
    /**
     * 获取待处理的申请数量
     */
    int getPendingApplicationsCount();
    
    /**
     * 获取成功领养的数量
     */
    int getSuccessfulAdoptionsCount();
    
    /**
     * 检查用户是否已经申请过某个宠物
     */
    boolean hasUserAppliedForPet(Long userId, Long petId);
} 