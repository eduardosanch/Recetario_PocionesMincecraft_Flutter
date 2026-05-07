package com.example.demo.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.models.PotionComment;
import com.example.demo.models.PotionPost;

@Repository
public interface PotionCommentRepository extends JpaRepository<PotionComment, Long> {

    Page<PotionComment> findByPotionPostOrderByCreatedAtDesc(
            PotionPost potionPost,
            Pageable pageable
    );

    Long countByPotionPost(PotionPost potionPost);
}