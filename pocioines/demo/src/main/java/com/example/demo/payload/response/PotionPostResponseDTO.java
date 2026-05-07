package com.example.demo.payload.response;

import java.time.Instant;
import java.util.List;

import com.example.demo.models.PotionPost;

public class PotionPostResponseDTO {

    private Long id;
    private String nombre;
    private String descripcion;
    private Integer duracionSegundos;
    private List<String> imagenes;
    private String postedByUsername;
    private Long postedByUserId;
    private Long commentsCount;
    private Long reactionsCount;
    private Instant createdAt;
    private Instant updatedAt;

    public PotionPostResponseDTO(
            PotionPost potionPost,
            Long commentsCount,
            Long reactionsCount
    ) {
        this.id = potionPost.getId();
        this.nombre = potionPost.getNombre();
        this.descripcion = potionPost.getDescripcion();
        this.duracionSegundos = potionPost.getDuracionSegundos();
        this.imagenes = potionPost.getImagenes();

        if (potionPost.getPostedBy() != null) {
            this.postedByUsername = potionPost.getPostedBy().getUsername();
            this.postedByUserId = potionPost.getPostedBy().getId();
        }

        this.commentsCount = commentsCount;
        this.reactionsCount = reactionsCount;
        this.createdAt = potionPost.getCreatedAt();
        this.updatedAt = potionPost.getUpdatedAt();
    }

    public Long getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public Integer getDuracionSegundos() {
        return duracionSegundos;
    }

    public List<String> getImagenes() {
        return imagenes;
    }

    public String getPostedByUsername() {
        return postedByUsername;
    }

    public Long getPostedByUserId() {
        return postedByUserId;
    }

    public Long getCommentsCount() {
        return commentsCount;
    }

    public Long getReactionsCount() {
        return reactionsCount;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }
}