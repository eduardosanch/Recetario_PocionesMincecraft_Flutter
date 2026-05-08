package com.example.demo.payload.request;

import com.example.demo.models.EReaction;

import jakarta.validation.constraints.NotNull;

public class PotionReactionRequest {

    @NotNull
    private Long potionPostId;

    @NotNull
    private EReaction type;

    public Long getPotionPostId() {
        return potionPostId;
    }

    public void setPotionPostId(Long potionPostId) {
        this.potionPostId = potionPostId;
    }

    public EReaction getType() {
        return type;
    }

    public void setType(EReaction type) {
        this.type = type;
    }
}