package com.example.petadoption.mapper;

import com.example.petadoption.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper

public interface UserDao {
    List<User> findAll();
    User findById(Long userId);
    int insert(User user);
    int update(User user);
    int delete(Long userId);
    User findByUsername(String username);
    User findByEmail(String email);
    int register(User user);
    User login(String username, String password);
    // 添加缺失的方法
    List<User> getAllUsers();
    User getUserById(Long id);
    void updateUser(User user);
    void deleteUser(Long id);

    int getRegisteredUsersCount();
    boolean isEmailExists(String email);
    
    // 数据分析相关方法
    List<Map<String, Object>> getUserRoleDistribution();
    
    // 新增用户查询方法
    List<User> searchUsers(@Param("keyword") String keyword, 
                          @Param("role") String role, 
                          @Param("status") String status);
    
    List<User> getUsersByRole(@Param("role") String role);
    
    List<User> getUsersByStatus(@Param("status") String status);
    
    List<User> getUsersWithPagination(@Param("offset") int offset, 
                                     @Param("limit") int limit);
    
    int getTotalUserCount();
    
    int getFilteredUserCount(@Param("keyword") String keyword, 
                           @Param("role") String role, 
                           @Param("status") String status);
}