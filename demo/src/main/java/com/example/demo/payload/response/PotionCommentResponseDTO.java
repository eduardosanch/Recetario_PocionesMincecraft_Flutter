package com.example.demo.payload.response;

import java.time.Instant;

import com.example.demo.models.PotionComment;

public class PotionCommentResponseDTO {

    private Long id;
    private String content;
    private String commentedByUsername;
    private Long commentedByUserId;
    private Long potionPostId;
    private Instant createdAt;
    private Instant updatedAt;

    public PotionCommentResponseDTO(PotionComment comment) {
        this.id = comment.getId();
        this.content = comment.getContent();
        this.commentedByUsername = comment.getCommentedBy().getUsername();
        this.commentedByUserId = comment.getCommentedBy().getId();
        this.potionPostId = comment.getPotionPost().getId();
        this.createdAt = comment.getCreatedAt();
        this.updatedAt = comment.getUpdatedAt();
    }

    public Long getId() {
        return id;
    }

    public String getContent() {
        return content;
    }

    public String getCommentedByUsername() {
        return commentedByUsername;
    }

    public Long getCommentedByUserId() {
        return commentedByUserId;
    }

    public Long getPotionPostId() {
        return potionPostId;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
}