package com.example.demo.payload.request;

import java.util.List;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class CreatePotionPostRequest {

    @NotBlank
    @Size(max = 150)
    private String nombre;

    @NotBlank
    @Size(max = 3000)
    private String descripcion;

    @NotNull
    @Min(1)
    private Integer duracionSegundos;

    @NotEmpty
    private List<@NotBlank String> imagenes;

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
}