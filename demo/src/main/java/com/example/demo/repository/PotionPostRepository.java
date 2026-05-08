package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.models.PotionPost;

@Repository
public interface PotionPostRepository extends JpaRepository<PotionPost, Long> {
}