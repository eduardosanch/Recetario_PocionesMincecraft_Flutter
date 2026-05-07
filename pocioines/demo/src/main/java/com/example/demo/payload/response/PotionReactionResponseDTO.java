package com.example.demo.payload.response;

import java.time.Instant;

import com.example.demo.models.EReaction;
import com.example.demo.models.PotionReaction;

public class PotionReactionResponseDTO {

    private Long id;
    private EReaction type;
    private String reactedByUsername;
    private Long reactedByUserId;
    private Long potionPostId;
    private Instant createdAt;

    public PotionReactionResponseDTO(PotionReaction reaction) {
        this.id = reaction.getId();
        this.type = reaction.getType();
        this.reactedByUsername = reaction.getReactedBy().getUsername();
        this.reactedByUserId = reaction.getReactedBy().getId();
        this.potionPostId = reaction.getPotionPost().getId();
        this.createdAt = reaction.getCreatedAt();
    }

    public Long getId() {
        return id;
    }

    public EReaction getType() {
        return type;
    }

    public String getReactedByUsername() {
        return reactedByUsername;
    }

    public Long getReactedByUserId() {
        return reactedByUserId;
    }

    public Long getPotionPostId() {
        return potionPostId;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}