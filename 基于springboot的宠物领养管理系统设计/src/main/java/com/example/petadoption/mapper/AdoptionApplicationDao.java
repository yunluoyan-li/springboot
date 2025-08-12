package com.example.petadoption.mapper;

import com.example.petadoption.model.AdoptionApplication;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdoptionApplicationDao {
    List<AdoptionApplication> getAllApplications();
    AdoptionApplication getApplicationById(Long applicationId);
    List<AdoptionApplication> getApplicationsByUserId(Long userId);
    List<AdoptionApplication> getApplicationsByPetId(Long petId);
    int insertApplication(AdoptionApplication application);
    int updateApplication(AdoptionApplication application);
    int deleteApplication(Long applicationId);
    int getPendingApplicationsCount();
    int getNewApplicationsCount();
    int getSuccessfulAdoptionsCount();
    int hasUserAppliedForPet(@Param("userId") Long userId, @Param("petId") Long petId);
    
    // 数据分析相关方法
    int getTotalApplicationsCount();
    List<Map<String, Object>> getAdoptionTrendData();

    int rejectOtherApplications(@Param("petId") Long petId, @Param("excludeApplicationId") Long excludeApplicationId);
}