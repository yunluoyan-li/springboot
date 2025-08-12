package com.example.petadoption.mapper;

import com.example.petadoption.model.Comment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface CommentDao {
    // 查询所有评论（可分页、可筛选）
    List<Comment> findAll(@Param("keyword") String keyword,
                         @Param("status") String status,
                         @Param("petId") Long petId,
                         @Param("userId") Long userId,
                         @Param("offset") int offset,
                         @Param("limit") int limit);

    // 获取评论总数（可筛选）
    int getCount(@Param("keyword") String keyword,
                 @Param("status") String status,
                 @Param("petId") Long petId,
                 @Param("userId") Long userId);

    // 根据ID查询评论
    Comment findById(Long commentId);

    // 插入新评论
    int insert(Comment comment);

    // 更新评论内容/状态
    int update(Comment comment);

    // 删除评论
    int delete(Long commentId);

    // 批量审核/修改状态
    int updateStatusBatch(@Param("ids") List<Long> ids, @Param("status") String status);

    // 查询某宠物的所有评论（按时间排序）
    List<Comment> findByPetId(@Param("petId") Long petId);

    // 查询某用户的所有评论
    List<Comment> findByUserId(@Param("userId") Long userId);

    // 查询最新评论（按时间倒序）
    List<Comment> findRecent(@Param("limit") int limit);

    // 评论统计（总数、今日、待审核等）
    Map<String, Object> getCommentStats();
} 