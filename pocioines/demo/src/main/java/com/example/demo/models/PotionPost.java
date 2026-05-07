package com.example.demo.models;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "potion_posts")
public class PotionPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 150)
    private String nombre;

    @NotBlank
    @Size(max = 3000)
    private String descripcion;

    @NotNull
    @Min(1)
    private Integer duracionSegundos;

    @ElementCollection
    @CollectionTable(
            name = "potion_post_images",
            joinColumns = @JoinColumn(name = "potion_post_id")
    )
    @Column(name = "image_url", length = 1000)
    private List<String> imagenes = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "posted_by", referencedColumnName = "id")
    private User postedBy;

    private Instant createdAt;

    private Instant updatedAt;

    @OneToMany(mappedBy = "potionPost", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PotionComment> comments = new HashSet<>();

    @OneToMany(mappedBy = "potionPost", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<PotionReaction> reactions = new HashSet<>();

    public PotionPost() {
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    public PotionPost(
            String nombre,
            String descripcion,
            Integer duracionSegundos,
            List<String> imagenes
    ) {
        this();
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.duracionSegundos = duracionSegundos;
        this.imagenes = imagenes;
    }

    public Long getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
        this.updatedAt = Instant.now();
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
        this.updatedAt = Instant.now();
    }

    public Integer getDuracionSegundos() {
        return duracionSegundos;
    }

    public void setDuracionSegundos(Integer duracionSegundos) {
        this.duracionSegundos = duracionSegundos;
        this.updatedAt = Instant.now();
    }

    public List<String> getImagenes() {
        return imagenes;
    }

    public void setImagenes(List<String> imagenes) {
        this.imagenes = imagenes;
        this.updatedAt = Instant.now();
    }

    public User getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(User postedBy) {
        this.postedBy = postedBy;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public Set<PotionComment> getComments() {
        return comments;
    }

    public Set<PotionReaction> getReactions() {
        return reactions;
    }
}