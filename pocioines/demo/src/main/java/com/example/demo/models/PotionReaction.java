package com.example.demo.models;

import java.time.Instant;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(
        name = "potion_reactions",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "potion_post_id"})
        }
)
public class PotionReaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private EReaction type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User reactedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "potion_post_id", nullable = false)
    private PotionPost potionPost;

    private Instant createdAt;

    public PotionReaction() {
        this.createdAt = Instant.now();
    }

    public PotionReaction(EReaction type, User reactedBy, PotionPost potionPost) {
        this();
        this.type = type;
        this.reactedBy = reactedBy;
        this.potionPost = potionPost;
    }

    public Long getId() {
        return id;
    }

    public EReaction getType() {
        return type;
    }

    public void setType(EReaction type) {
        this.type = type;
    }

    public User getReactedBy() {
        return reactedBy;
    }

    public void setReactedBy(User reactedBy) {
        this.reactedBy = reactedBy;
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
}