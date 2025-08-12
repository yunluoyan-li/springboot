package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.PetBreedDao;
import com.example.petadoption.mapper.PetDao;
import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed;
import com.example.petadoption.service.PetService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PetServiceImpl implements PetService {

    private static final Logger logger = LoggerFactory.getLogger(PetServiceImpl.class);

    @Autowired
    private PetDao petDao;

    @Autowired
    private PetBreedDao petBreedDao;

    @Override
    public List<Pet> findAll() {
        try {
            logger.info("开始从数据库查询所有宠物");
            List<Pet> pets = petDao.findAll();
            logger.info("从数据库查询到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("查询所有宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public Pet save(Pet pet) {
        try {
            logger.info("开始保存宠物信息: {}", pet.getName());
            int result = petDao.insert(pet);
            if (result > 0) {
                logger.info("宠物保存成功，ID: {}", pet.getPetId());
                return pet;
            } else {
                logger.error("宠物保存失败，插入记录数为0");
                return null;
            }
        } catch (Exception e) {
            logger.error("保存宠物信息时出现异常: {}", e.getMessage(), e);
            return null;
        }
    }

    @Override
    public Pet getPetById(Long id) {
        try {
            return petDao.getPetById(id);
        } catch (Exception e) {
            logger.error("根据 ID 查询宠物信息时出现异常，ID: {}", id, e);
            return null;
        }
    }

    @Override
    public boolean updatePet(Pet pet) {
        try {
            logger.info("开始更新宠物信息: ID={}, 名称={}", pet.getPetId(), pet.getName());
            int result = petDao.updatePet(pet);
            if (result > 0) {
                logger.info("宠物更新成功，ID: {}", pet.getPetId());
                return true;
            } else {
                logger.error("宠物更新失败，更新记录数为0，ID: {}", pet.getPetId());
                return false;
            }
        } catch (Exception e) {
            logger.error("更新宠物信息时出现异常: {}", e.getMessage(), e);
            return false;
        }
    }

    @Override
    public void deletePet(Long id) {
        try {
            petDao.deletePet(id);
        } catch (Exception e) {
            logger.error("删除宠物信息时出现异常，宠物 ID: {}", id, e);
        }
    }

    @Override
    public List<PetBreed> getAllBreeds() {
        try {
            return petBreedDao.findAll();
        } catch (Exception e) {
            logger.error("查询所有宠物品种时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Pet> searchPets(String keyword, Long breedId, String status, String gender) {
        try {
            logger.info("开始搜索宠物: keyword={}, breedId={}, status={}, gender={}", 
                       keyword, breedId, status, gender);
            List<Pet> pets = petDao.searchPets(keyword, breedId, status, gender);
            logger.info("搜索到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("搜索宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Pet> getPetsByBreed(Long breedId) {
        try {
            logger.info("开始根据品种查询宠物: breedId={}", breedId);
            List<Pet> pets = petDao.getPetsByBreed(breedId);
            logger.info("查询到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("根据品种查询宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Pet> getPetsByStatus(String status) {
        try {
            logger.info("开始根据状态查询宠物: status={}", status);
            List<Pet> pets = petDao.getPetsByStatus(status);
            logger.info("查询到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("根据状态查询宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Pet> getPetsByGender(String gender) {
        try {
            logger.info("开始根据性别查询宠物: gender={}", gender);
            List<Pet> pets = petDao.getPetsByGender(gender);
            logger.info("查询到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("根据性别查询宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public List<Pet> getPetsWithPagination(int page, int size) {
        try {
            int offset = (page - 1) * size;
            logger.info("开始分页查询宠物: page={}, size={}, offset={}", page, size, offset);
            List<Pet> pets = petDao.getPetsWithPagination(offset, size);
            logger.info("查询到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("分页查询宠物时出现异常", e);
            return null;
        }
    }

    @Override
    public int getFilteredPetsCount(String keyword, Long breedId, String status, String gender) {
        try {
            logger.info("开始统计筛选后的宠物数量: keyword={}, breedId={}, status={}, gender={}", 
                       keyword, breedId, status, gender);
            int count = petDao.getFilteredPetsCount(keyword, breedId, status, gender);
            logger.info("筛选后的宠物数量: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("统计筛选后的宠物数量时出现异常", e);
            return 0;
        }
    }

    @Override
    public List<Pet> searchPetsWithPagination(String keyword, Long breedId, String status, String gender, int page, int size) {
        try {
            int offset = (page - 1) * size;
            logger.info("开始分页搜索宠物: keyword={}, breedId={}, status={}, gender={}, page={}, size={}, offset={}", 
                       keyword, breedId, status, gender, page, size, offset);
            List<Pet> pets = petDao.searchPetsWithPagination(keyword, breedId, status, gender, offset, size);
            logger.info("分页搜索到 {} 条宠物记录", pets != null ? pets.size() : 0);
            return pets;
        } catch (Exception e) {
            logger.error("分页搜索宠物时出现异常", e);
            return null;
        }
    }
    
    @Override
    public int getTotalPetsCount() {
        try {
            logger.info("开始统计总宠物数量");
            int count = petDao.getTotalPetsCount();
            logger.info("总宠物数量: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("统计总宠物数量时出现异常", e);
            return 0;
        }
    }
    
    @Override
    public int getAvailablePetsCount() {
        try {
            logger.info("开始统计可领养宠物数量");
            int count = petDao.getAvailablePetsCount();
            logger.info("可领养宠物数量: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("统计可领养宠物数量时出现异常", e);
            return 0;
        }
    }
    
    @Override
    public int getAdoptedPetsCount() {
        try {
            logger.info("开始统计已领养宠物数量");
            int count = petDao.getAdoptedPetsCount();
            logger.info("已领养宠物数量: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("统计已领养宠物数量时出现异常", e);
            return 0;
        }
    }
    
    @Override
    public int getPendingPetsCount() {
        try {
            logger.info("开始统计待审核宠物数量");
            int count = petDao.getPendingPetsCount();
            logger.info("待审核宠物数量: {}", count);
            return count;
        } catch (Exception e) {
            logger.error("统计待审核宠物数量时出现异常", e);
            return 0;
        }
    }
}