package com.example.demo.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.models.EReaction;
import com.example.demo.models.PotionPost;
import com.example.demo.models.PotionReaction;
import com.example.demo.models.User;

@Repository
public interface PotionReactionRepository extends JpaRepository<PotionReaction, Long> {

    List<PotionReaction> findByPotionPost(PotionPost potionPost);

    Long countByPotionPost(PotionPost potionPost);

    Long countByPotionPostAndType(PotionPost potionPost, EReaction type);

    Optional<PotionReaction> findByPotionPostAndReactedBy(
            PotionPost potionPost,
            User reactedBy
    );
}