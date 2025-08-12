package com.example.petadoption.mapper;

import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed; // 假设 PetBreed 是宠物品种的实体类
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface PetDao {
    List<Pet> findAll();
    int insert(Pet pet);
    Pet getPetById(Long id);
    int updatePet(Pet pet);
    void deletePet(Long id);
    int getAvailablePetsCount();
    List<PetBreed> getAllPetBreeds(); // 添加这个方法
    
    // 数据分析相关方法
    int getTotalPetsCount();
    List<Map<String, Object>> getPetStatusDistribution();
    List<Map<String, Object>> getPetGenderDistribution();
    
    // 新增宠物搜索方法
    List<Pet> searchPets(@Param("keyword") String keyword, 
                         @Param("breedId") Long breedId, 
                         @Param("status") String status,
                         @Param("gender") String gender);
    
    List<Pet> getPetsByBreed(@Param("breedId") Long breedId);
    
    List<Pet> getPetsByStatus(@Param("status") String status);
    
    List<Pet> getPetsByGender(@Param("gender") String gender);
    
    List<Pet> getPetsWithPagination(@Param("offset") int offset, 
                                   @Param("limit") int limit);
    
    int getFilteredPetsCount(@Param("keyword") String keyword, 
                            @Param("breedId") Long breedId, 
                            @Param("status") String status,
                            @Param("gender") String gender);
    
    // 新增：支持分页的搜索方法
    List<Pet> searchPetsWithPagination(@Param("keyword") String keyword, 
                                      @Param("breedId") Long breedId, 
                                      @Param("status") String status,
                                      @Param("gender") String gender,
                                      @Param("offset") int offset, 
                                      @Param("limit") int limit);
    
    // 新增：统计方法
    int getAdoptedPetsCount();
    int getPendingPetsCount();
}