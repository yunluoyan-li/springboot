package com.example.petadoption.mapper;

import com.example.petadoption.model.PetImage;
import java.util.List;

public interface PetImageDao {
    List<PetImage> findByPetId(Long petId);
    void insert(PetImage petImage);
    int delete(Long imageId);
}