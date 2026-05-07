package com.example.demo.payload.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class CreatePotionCommentRequest {

    @NotBlank
    @Size(min = 1, max = 500)
    private String content;

    @NotNull
    private Long potionPostId;

    public String getContent() {
        return content;
    }

    public Long getPotionPostId() {
        return potionPostId;
    }
}