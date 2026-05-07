package com.example.demo.controllers;

import java.util.List;
import java.util.Optional;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.example.demo.models.PotionPost;
import com.example.demo.models.PotionReaction;
import com.example.demo.models.User;
import com.example.demo.payload.request.PotionReactionRequest;
import com.example.demo.payload.response.MessageResponse;
import com.example.demo.payload.response.PotionReactionResponseDTO;
import com.example.demo.repository.PotionPostRepository;
import com.example.demo.repository.PotionReactionRepository;
import com.example.demo.repository.UserRepository;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/potion-reactions")
public class PotionReactionController {

    private final PotionReactionRepository potionReactionRepository;
    private final PotionPostRepository potionPostRepository;
    private final UserRepository userRepository;

    public PotionReactionController(
            PotionReactionRepository potionReactionRepository,
            PotionPostRepository potionPostRepository,
            UserRepository userRepository
    ) {
        this.potionReactionRepository = potionReactionRepository;
        this.potionPostRepository = potionPostRepository;
        this.userRepository = userRepository;
    }

    @GetMapping("/potion/{potionPostId}")
    public ResponseEntity<?> getReactionsByPotion(@PathVariable Long potionPostId) {
        Optional<PotionPost> potionOpt = potionPostRepository.findById(potionPostId);

        if (potionOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Potion not found"));
        }

        List<PotionReactionResponseDTO> reactions =
                potionReactionRepository.findByPotionPost(potionOpt.get())
                        .stream()
                        .map(PotionReactionResponseDTO::new)
                        .toList();

        return ResponseEntity.ok(reactions);
    }

    @PostMapping
    public ResponseEntity<?> createReaction(
            @Valid @RequestBody PotionReactionRequest request
    ) {
        try {
            User user = getAuthenticatedUser();

            PotionPost potion = potionPostRepository
                    .findById(request.getPotionPostId())
                    .orElseThrow(() -> new RuntimeException("Potion not found"));

            Optional<PotionReaction> existingReaction =
                    potionReactionRepository.findByPotionPostAndReactedBy(potion, user);

            PotionReaction reaction;

            if (existingReaction.isPresent()) {
                reaction = existingReaction.get();
                reaction.setType(request.getType());
            } else {
                reaction = new PotionReaction(
                        request.getType(),
                        user,
                        potion
                );
            }

            PotionReaction savedReaction =
                    potionReactionRepository.save(reaction);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new PotionReactionResponseDTO(savedReaction));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @DeleteMapping("/{reactionId}")
    public ResponseEntity<?> deleteReaction(@PathVariable Long reactionId) {
        if (!potionReactionRepository.existsById(reactionId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Reaction not found"));
        }

        potionReactionRepository.deleteById(reactionId);

        return ResponseEntity.ok(
                new MessageResponse("Reaction deleted successfully")
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