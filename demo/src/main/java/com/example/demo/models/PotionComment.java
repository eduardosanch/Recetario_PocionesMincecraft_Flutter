package com.example.demo.models;

import java.time.Instant;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "potion_comments")
public class PotionComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 500)
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "commented_by", nullable = false)
    private User commentedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "potion_post_id", nullable = false)
    private PotionPost potionPost;

    private Instant createdAt;

    private Instant updatedAt;

    public PotionComment() {
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    public PotionComment(String content, User commentedBy, PotionPost potionPost) {
        this();
        this.content = content;
        this.commentedBy = commentedBy;
        this.potionPost = potionPost;
    }

    public Long getId() {
        return id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
        this.updatedAt = Instant.now();
    }

    public User getCommentedBy() {
        return commentedBy;
    }

    public void setCommentedBy(User commentedBy) {
        this.commentedBy = commentedBy;
    }

    public PotionPost getPotionPost() {
        return potionPost;
    }

    public void setPotionPost(PotionPost potionPost) {
        this.potionPost = potionPost;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
}