package com.example.petadoption.mapper;

import com.example.petadoption.model.Favorite;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface FavoriteDao {
    Favorite findById(Long favoriteId);
    List<Favorite> findAll();
    List<Favorite> findByUserId(Long userId);
    List<Favorite> findByPetId(Long petId);
    int insert(Favorite favorite);
    int update(Favorite favorite);
    int delete(Long favoriteId);
    int deleteByUserAndPet(@Param("userId") Long userId, @Param("petId") Long petId);
} 