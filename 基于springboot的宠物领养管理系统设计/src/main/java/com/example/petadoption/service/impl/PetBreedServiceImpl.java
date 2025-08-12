package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.PetBreedDao;
import com.example.petadoption.model.PetBreed;
import com.example.petadoption.service.PetBreedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PetBreedServiceImpl implements PetBreedService {

    private static final Logger logger = LoggerFactory.getLogger(PetBreedServiceImpl.class);

    @Autowired
    private PetBreedDao petBreedDao;

    @Override
    public List<PetBreed> getAllPetBreeds() {
        try {
            logger.info("开始从数据库查询所有宠物品种");
            List<PetBreed> petBreeds = petBreedDao.findAll();
            logger.info("从数据库查询到 {} 条宠物品种记录", petBreeds != null ? petBreeds.size() : 0);
            return petBreeds;
        } catch (Exception e) {
            logger.error("查询所有宠物品种时出现异常", e);
            return null;
        }
    }

    @Override
    public PetBreed getPetBreedById(Integer breedId) {
        try {
            return petBreedDao.findById(breedId);
        } catch (Exception e) {
            logger.error("根据 ID 查询宠物品种信息时出现异常，ID: {}", breedId, e);
            return null;
        }
    }

    @Override
    public int insertPetBreed(PetBreed petBreed) {
        try {
            return petBreedDao.insert(petBreed);
        } catch (Exception e) {
            logger.error("插入宠物品种信息时出现异常", e);
            return 0;
        }
    }

    @Override
    public int updatePetBreed(PetBreed petBreed) {
        try {
            return petBreedDao.update(petBreed);
        } catch (Exception e) {
            logger.error("更新宠物品种信息时出现异常，宠物品种 ID: {}", petBreed.getBreedId(), e);
            return 0;
        }
    }

    @Override
    public int deletePetBreed(Integer breedId) {
        try {
            return petBreedDao.delete(breedId);
        } catch (Exception e) {
            logger.error("删除宠物品种信息时出现异常，宠物品种 ID: {}", breedId, e);
            return 0;
        }
    }
}