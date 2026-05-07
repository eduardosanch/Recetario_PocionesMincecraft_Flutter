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

    public EReaction getType() {
        return type;
    }
}