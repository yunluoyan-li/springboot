package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.FavoriteDao;
import com.example.petadoption.model.Favorite;
import com.example.petadoption.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FavoriteServiceImpl implements FavoriteService {
    @Autowired
    private FavoriteDao favoriteDao;

    @Override
    public Favorite findById(Long favoriteId) {
        return favoriteDao.findById(favoriteId);
    }

    @Override
    public List<Favorite> findAll() {
        return favoriteDao.findAll();
    }

    @Override
    public List<Favorite> findByUserId(Long userId) {
        return favoriteDao.findByUserId(userId);
    }

    @Override
    public List<Favorite> findByPetId(Long petId) {
        return favoriteDao.findByPetId(petId);
    }

    @Override
    public int addFavorite(Favorite favorite) {
        return favoriteDao.insert(favorite);
    }

    @Override
    public int updateFavorite(Favorite favorite) {
        return favoriteDao.update(favorite);
    }

    @Override
    public int deleteFavorite(Long favoriteId) {
        return favoriteDao.delete(favoriteId);
    }

    @Override
    public int deleteByUserAndPet(Long userId, Long petId) {
        return favoriteDao.deleteByUserAndPet(userId, petId);
    }
} 