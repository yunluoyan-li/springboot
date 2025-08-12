package com.example.petadoption.model;

import java.util.Date;

public class Tag {
    private Integer tagId;
    private String name;
    private String slug;
    private String color;
    private Date createdAt;

    public Integer getTagId() {
        return tagId;
    }

    public void setTagId(Integer tagId) {
        this.tagId = tagId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Tag{" +
                "tagId=" + tagId +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                ", color='" + color + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}