package com.example.petadoption.mapper;

import com.example.petadoption.model.PetBreed;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface PetBreedDao {
    /**
     * 查询所有宠物品种
     * @return 宠物品种列表
     */
    List<PetBreed> findAll();

    /**
     * 根据品种ID查询宠物品种
     * @param breedId 品种ID
     * @return 宠物品种
     */
    PetBreed findById(Integer breedId);

    /**
     * 插入新的宠物品种
     * @param petBreed 宠物品种对象
     * @return 插入成功的记录数
     */
    int insert(PetBreed petBreed);

    /**
     * 更新宠物品种信息
     * @param petBreed 宠物品种对象
     * @return 更新成功的记录数
     */
    int update(PetBreed petBreed);

    /**
     * 根据品种ID删除宠物品种
     * @param breedId 品种ID
     * @return 删除成功的记录数
     */
    int delete(Integer breedId);
    
    // 数据分析相关方法
    List<Map<String, Object>> getTopPetBreeds(@Param("limit") int limit);
}