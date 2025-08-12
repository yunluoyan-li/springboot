package com.example.petadoption.service;

import com.example.petadoption.model.User;
import java.util.List;
import java.util.Map;

public interface UserService {
    User register(User user);
    User login(String username, String password);
    User getUserById(Long id);
    List<User> getAllUsers();
    boolean updateUser(User user);
    boolean deleteUser(Long id);
    boolean isEmailExists(String email);
    User getUserByUsername(String username);
    int getRegisteredUsersCount();
    
    // 新增用户查询方法
    List<User> searchUsers(String keyword, String role, String status);
    List<User> getUsersByRole(String role);
    List<User> getUsersByStatus(String status);
    List<User> getUsersWithPagination(int page, int size);
    int getTotalUserCount();
    int getFilteredUserCount(String keyword, String role, String status);
    List<Map<String, Object>> getUserRoleDistribution();
}