package com.example.petadoption.service;

import com.example.petadoption.model.PetBreed;
import java.util.List;

public interface PetBreedService {
    /**
     * 查询所有宠物品种
     * @return 宠物品种列表
     */
    List<PetBreed> getAllPetBreeds();

    /**
     * 根据品种ID查询宠物品种
     * @param breedId 品种ID
     * @return 宠物品种
     */
    PetBreed getPetBreedById(Integer breedId);

    /**
     * 插入新的宠物品种
     * @param petBreed 宠物品种对象
     * @return 插入成功的记录数
     */
    int insertPetBreed(PetBreed petBreed);

    /**
     * 更新宠物品种信息
     * @param petBreed 宠物品种对象
     * @return 更新成功的记录数
     */
    int updatePetBreed(PetBreed petBreed);

    /**
     * 根据品种ID删除宠物品种
     * @param breedId 品种ID
     * @return 删除成功的记录数
     */
    int deletePetBreed(Integer breedId);

}