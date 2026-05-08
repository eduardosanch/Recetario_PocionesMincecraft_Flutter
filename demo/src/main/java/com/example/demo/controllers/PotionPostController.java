package com.example.demo.controllers;

import java.util.List;
import java.util.Optional;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import com.example.demo.models.PotionPost;
import com.example.demo.models.User;
import com.example.demo.payload.request.CreatePotionPostRequest;
import com.example.demo.payload.response.MessageResponse;
import com.example.demo.payload.response.PotionPostResponseDTO;
import com.example.demo.repository.PotionCommentRepository;
import com.example.demo.repository.PotionPostRepository;
import com.example.demo.repository.PotionReactionRepository;
import com.example.demo.repository.UserRepository;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/potions")
public class PotionPostController {

    private final PotionPostRepository potionPostRepository;
    private final PotionCommentRepository potionCommentRepository;
    private final PotionReactionRepository potionReactionRepository;
    private final UserRepository userRepository;

    public PotionPostController(
            PotionPostRepository potionPostRepository,
            PotionCommentRepository potionCommentRepository,
            PotionReactionRepository potionReactionRepository,
            UserRepository userRepository
    ) {
        this.potionPostRepository = potionPostRepository;
        this.potionCommentRepository = potionCommentRepository;
        this.potionReactionRepository = potionReactionRepository;
        this.userRepository = userRepository;
    }

    /*
     * Ruta de prueba.
     * Sirve para saber si el controlador está respondiendo.
     *
     * Prueba:
     * https://recetario-pociones.onrender.com/api/potions/ping
     */
    @GetMapping("/ping")
    public ResponseEntity<String> ping() {
        return ResponseEntity.ok("Controlador de pociones funcionando");
    }

    /*
     * Obtener todas las pociones.
     *
     * Ruta:
     * GET /api/potions
     */
    @GetMapping
    @Transactional(readOnly = true)
    public ResponseEntity<List<PotionPostResponseDTO>> getAllPotions() {
        List<PotionPostResponseDTO> potions = potionPostRepository.findAll()
                .stream()
                .map(this::toDTO)
                .toList();

        return ResponseEntity.ok(potions);
    }

    /*
     * Obtener una poción por ID.
     *
     * Ruta:
     * GET /api/potions/{id}
     */
    @GetMapping("/{id}")
    @Transactional(readOnly = true)
    public ResponseEntity<?> getPotionById(@PathVariable Long id) {
        Optional<PotionPost> potionOpt = potionPostRepository.findById(id);

        if (potionOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Potion not found"));
        }

        return ResponseEntity.ok(toDTO(potionOpt.get()));
    }

    /*
     * Crear una poción.
     *
     * Ruta:
     * POST /api/potions/create
     *
     * Esta ruta sí necesita usuario autenticado.
     */
    @PostMapping("/create")
    public ResponseEntity<?> createPotion(
            @Valid @RequestBody CreatePotionPostRequest request
    ) {
        try {
            User user = getAuthenticatedUser();

            PotionPost potion = new PotionPost(
                    request.getNombre(),
                    request.getDescripcion(),
                    request.getDuracionSegundos(),
                    request.getImagenes()
            );

            potion.setPostedBy(user);

            PotionPost savedPotion = potionPostRepository.save(potion);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(toDTO(savedPotion));

        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    /*
     * Eliminar una poción.
     *
     * Ruta:
     * DELETE /api/potions/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePotion(@PathVariable Long id) {
        if (!potionPostRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Potion not found"));
        }

        potionPostRepository.deleteById(id);

        return ResponseEntity.ok(
                new MessageResponse("Potion deleted successfully")
        );
    }

    private PotionPostResponseDTO toDTO(PotionPost potionPost) {
        Long commentsCount = potionCommentRepository.countByPotionPost(potionPost);
        Long reactionsCount = potionReactionRepository.countByPotionPost(potionPost);

        return new PotionPostResponseDTO(
                potionPost,
                commentsCount,
                reactionsCount
        );
    }

    private User getAuthenticatedUser() {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || authentication.getName() == null) {
            throw new RuntimeException("User not authenticated");
        }

        String username = authentication.getName();

        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}