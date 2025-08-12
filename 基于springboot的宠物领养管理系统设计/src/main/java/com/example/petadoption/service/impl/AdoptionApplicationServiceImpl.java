package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.AdoptionApplicationDao;
import com.example.petadoption.model.AdoptionApplication;
import com.example.petadoption.model.Pet;
import com.example.petadoption.service.AdoptionApplicationService;
import com.example.petadoption.service.PetService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AdoptionApplicationServiceImpl implements AdoptionApplicationService {

    private static final Logger logger = LoggerFactory.getLogger(AdoptionApplicationServiceImpl.class);

    @Autowired
    private AdoptionApplicationDao adoptionApplicationDao;

    @Autowired
    private PetService petService;

    @Override
    public List<AdoptionApplication> getAllApplications() {
        logger.info("获取所有领养申请");
        return adoptionApplicationDao.getAllApplications();
    }

    @Override
    public AdoptionApplication getApplicationById(Long applicationId) {
        logger.info("根据ID获取领养申请: {}", applicationId);
        return adoptionApplicationDao.getApplicationById(applicationId);
    }

    @Override
    public List<AdoptionApplication> getApplicationsByUserId(Long userId) {
        logger.info("根据用户ID获取领养申请: {}", userId);
        return adoptionApplicationDao.getApplicationsByUserId(userId);
    }

    @Override
    public List<AdoptionApplication> getApplicationsByPetId(Long petId) {
        logger.info("根据宠物ID获取领养申请: {}", petId);
        return adoptionApplicationDao.getApplicationsByPetId(petId);
    }

    @Override
    public boolean createApplication(AdoptionApplication application) {
        try {
            logger.info("开始创建新的领养申请: petId={}, userId={}", application.getPetId(), application.getUserId());
            
            // 验证输入参数
            if (application.getPetId() == null) {
                logger.error("宠物ID为空");
                return false;
            }
            
            if (application.getUserId() == null) {
                logger.error("用户ID为空");
                return false;
            }
            
            if (application.getApplicationText() == null || application.getApplicationText().trim().isEmpty()) {
                logger.error("申请理由为空");
                return false;
            }
            
            if (application.getHomeDescription() == null || application.getHomeDescription().trim().isEmpty()) {
                logger.error("家庭环境描述为空");
                return false;
            }
            
            // 检查用户是否已经申请过这个宠物
            if (hasUserAppliedForPet(application.getUserId(), application.getPetId())) {
                logger.warn("用户 {} 已经申请过宠物 {}", application.getUserId(), application.getPetId());
                return false;
            }
            
            // 设置默认值
            application.setStatus("PENDING");
            application.setCreatedAt(new Date());
            
            logger.info("准备插入申请记录到数据库");
            int result = adoptionApplicationDao.insertApplication(application);
            
            if (result > 0) {
                // 新增：申请成功后将宠物状态设为PENDING
                Pet pet = petService.getPetById(application.getPetId());
                if (pet != null && (pet.getStatus() == null || !pet.getStatus().equals("ADOPTED"))) {
                    pet.setStatus("PENDING");
                    petService.updatePet(pet);
                }
                logger.info("申请创建成功，影响行数: {}", result);
                return true;
            } else {
                logger.error("申请创建失败，影响行数: {}", result);
                return false;
            }
            
        } catch (Exception e) {
            logger.error("创建申请时发生异常", e);
            return false;
        }
    }

    @Override
    public boolean updateApplication(AdoptionApplication application) {
        logger.info("更新领养申请: {}", application.getApplicationId());
        int result = adoptionApplicationDao.updateApplication(application);
        return result > 0;
    }

    @Override
    public boolean deleteApplication(Long applicationId) {
        logger.info("删除领养申请: {}", applicationId);
        int result = adoptionApplicationDao.deleteApplication(applicationId);
        return result > 0;
    }

    @Override
    public boolean approveApplication(Long applicationId, String adminNotes) {
        logger.info("审批通过领养申请: {}", applicationId);
        
        AdoptionApplication application = getApplicationById(applicationId);
        if (application == null) {
            logger.error("领养申请不存在: {}", applicationId);
            return false;
        }
        
        application.setStatus("APPROVED");
        application.setAdminNotes(adminNotes);
        application.setResponseDate(new Date());
        
        int result = adoptionApplicationDao.updateApplication(application);
        // 新增：审批通过后将宠物状态设为ADOPTED
        Pet pet = petService.getPetById(application.getPetId());
        if (pet != null) {
            pet.setStatus("ADOPTED");
            petService.updatePet(pet);
        }
        // 新增：自动拒绝同宠物的其他申请
        adoptionApplicationDao.rejectOtherApplications(application.getPetId(), applicationId);
        return result > 0;
    }

    @Override
    public boolean rejectApplication(Long applicationId, String adminNotes) {
        logger.info("拒绝领养申请: {}", applicationId);
        
        AdoptionApplication application = getApplicationById(applicationId);
        if (application == null) {
            logger.error("领养申请不存在: {}", applicationId);
            return false;
        }
        
        application.setStatus("REJECTED");
        application.setAdminNotes(adminNotes);
        application.setResponseDate(new Date());
        
        int result = adoptionApplicationDao.updateApplication(application);
        return result > 0;
    }

    @Override
    public int getPendingApplicationsCount() {
        logger.info("获取待处理的申请数量");
        return adoptionApplicationDao.getPendingApplicationsCount();
    }

    @Override
    public int getSuccessfulAdoptionsCount() {
        logger.info("获取成功领养的数量");
        return adoptionApplicationDao.getSuccessfulAdoptionsCount();
    }

    @Override
    public boolean hasUserAppliedForPet(Long userId, Long petId) {
        logger.info("检查用户 {} 是否已经申请过宠物 {}", userId, petId);
        return adoptionApplicationDao.hasUserAppliedForPet(userId, petId) > 0;
    }
} 