package com.example.petadoption.service;

import com.example.petadoption.model.Favorite;
import java.util.List;

public interface FavoriteService {
    Favorite findById(Long favoriteId);
    List<Favorite> findAll();
    List<Favorite> findByUserId(Long userId);
    List<Favorite> findByPetId(Long petId);
    int addFavorite(Favorite favorite);
    int updateFavorite(Favorite favorite);
    int deleteFavorite(Long favoriteId);
    int deleteByUserAndPet(Long userId, Long petId);
} 