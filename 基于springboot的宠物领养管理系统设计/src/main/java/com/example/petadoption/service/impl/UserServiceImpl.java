package com.example.petadoption.service.impl;

import com.example.petadoption.mapper.UserDao;
import com.example.petadoption.model.User;
import com.example.petadoption.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    // 新增更新用户信息的方法
    public User update(User user) {
        // 检查密码是否为空，如果为空则获取原密码
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            User originalUser = userDao.findById(user.getUserId());
            if (originalUser != null) {
                user.setPassword(originalUser.getPassword());
            }
        } else {
            // 简单MD5加密（实际项目用BCrypt）
            user.setPassword(DigestUtils.md5DigestAsHex(
                    user.getPassword().getBytes(StandardCharsets.UTF_8)
            ));
        }

        userDao.update(user);
        return user;
    }

    @Override
    public User register(User user) {
        // 不加密，直接存明文
        if (userDao.findByUsername(user.getUsername()) != null) {
            throw new RuntimeException("用户名已存在");
        }
        userDao.insert(user);
        return user;
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(username);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        // 明文比对
        if (!user.getPassword().equals(password)) {
            throw new RuntimeException("密码错误");
        }
        return user;
    }

    @Override
    public User getUserById(Long id) {
        return userDao.findById(id);
    }
    
    @Override
    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }
    
    @Override
    public boolean updateUser(User user) {
        try {
            userDao.updateUser(user);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    @Override
    public boolean deleteUser(Long id) {
        try {
            userDao.deleteUser(id);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    @Override
    public boolean isEmailExists(String email) {
        return userDao.isEmailExists(email);
    }
    
    @Override
    public User getUserByUsername(String username) {
        return userDao.findByUsername(username);
    }
    
    @Override
    public int getRegisteredUsersCount() {
        return userDao.getRegisteredUsersCount();
    }
    
    // 新增用户查询方法实现
    @Override
    public List<User> searchUsers(String keyword, String role, String status) {
        return userDao.searchUsers(keyword, role, status);
    }
    
    @Override
    public List<User> getUsersByRole(String role) {
        return userDao.getUsersByRole(role);
    }
    
    @Override
    public List<User> getUsersByStatus(String status) {
        return userDao.getUsersByStatus(status);
    }
    
    @Override
    public List<User> getUsersWithPagination(int page, int size) {
        int offset = (page - 1) * size;
        return userDao.getUsersWithPagination(offset, size);
    }
    
    @Override
    public int getTotalUserCount() {
        return userDao.getTotalUserCount();
    }
    
    @Override
    public int getFilteredUserCount(String keyword, String role, String status) {
        return userDao.getFilteredUserCount(keyword, role, status);
    }
    
    @Override
    public List<Map<String, Object>> getUserRoleDistribution() {
        return userDao.getUserRoleDistribution();
    }
}