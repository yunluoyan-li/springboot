package com.example.petadoption.service;

import com.example.petadoption.model.Pet;
import com.example.petadoption.model.PetBreed;
import java.util.List;

public interface PetService {
    List<Pet> findAll();
    Pet save(Pet pet);
    Pet getPetById(Long id);
    boolean updatePet(Pet pet);
    void deletePet(Long id);
    // 添加获取所有宠物品种的方法
    List<PetBreed> getAllBreeds();
    
    // 新增宠物搜索方法
    List<Pet> searchPets(String keyword, Long breedId, String status, String gender);
    List<Pet> getPetsByBreed(Long breedId);
    List<Pet> getPetsByStatus(String status);
    List<Pet> getPetsByGender(String gender);
    List<Pet> getPetsWithPagination(int page, int size);
    int getFilteredPetsCount(String keyword, Long breedId, String status, String gender);
    
    // 新增：支持分页的搜索方法
    List<Pet> searchPetsWithPagination(String keyword, Long breedId, String status, String gender, int page, int size);
    
    // 新增：统计方法
    int getTotalPetsCount();
    int getAvailablePetsCount();
    int getAdoptedPetsCount();
    int getPendingPetsCount();
}