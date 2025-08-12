package com.example.petadoption;  // 改成您的实际包名

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.petadoption.mapper") // 扫描DAO接口

public class PetAdoptionApplication {
    public static void main(String[] args) {
        SpringApplication.run(PetAdoptionApplication.class, args);
    }
}