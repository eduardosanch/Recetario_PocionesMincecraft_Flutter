package com.example.demo.controllers;

import java.util.Optional;

import jakarta.validation.Valid;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import com.example.demo.models.PotionComment;
import com.example.demo.models.PotionPost;
import com.example.demo.models.User;
import com.example.demo.payload.request.CreatePotionCommentRequest;
import com.example.demo.payload.response.MessageResponse;
import com.example.demo.payload.response.PotionCommentResponseDTO;
import com.example.demo.repository.PotionCommentRepository;
import com.example.demo.repository.PotionPostRepository;
import com.example.demo.repository.UserRepository;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/potion-comments")
public class PotionCommentController {

    private final PotionCommentRepository potionCommentRepository;
    private final PotionPostRepository potionPostRepository;
    private final UserRepository userRepository;

    public PotionCommentController(
            PotionCommentRepository potionCommentRepository,
            PotionPostRepository potionPostRepository,
            UserRepository userRepository
    ) {
        this.potionCommentRepository = potionCommentRepository;
        this.potionPostRepository = potionPostRepository;
        this.userRepository = userRepository;
    }

    @GetMapping("/potion/{potionPostId}")
    @Transactional(readOnly = true)
    public ResponseEntity<?> getCommentsByPotion(
            @PathVariable Long potionPostId,
            Pageable pageable
    ) {
        Optional<PotionPost> potionOpt = potionPostRepository.findById(potionPostId);

        if (potionOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Potion not found"));
        }

        Page<PotionCommentResponseDTO> comments =
                potionCommentRepository
                        .findByPotionPostOrderByCreatedAtDesc(potionOpt.get(), pageable)
                        .map(PotionCommentResponseDTO::new);

        return ResponseEntity.ok(comments);
    }

    @PostMapping
    public ResponseEntity<?> createComment(
            @Valid @RequestBody CreatePotionCommentRequest request
    ) {
        try {
            User user = getAuthenticatedUser();

            PotionPost potionPost = potionPostRepository
                    .findById(request.getPotionPostId())
                    .orElseThrow(() -> new RuntimeException("Potion not found"));

            PotionComment comment = new PotionComment(
                    request.getContent(),
                    user,
                    potionPost
            );

            PotionComment savedComment = potionCommentRepository.save(comment);

            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new PotionCommentResponseDTO(savedComment));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(@PathVariable Long commentId) {
        if (!potionCommentRepository.existsById(commentId)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new MessageResponse("Comment not found"));
        }

        potionCommentRepository.deleteById(commentId);

        return ResponseEntity.ok(
                new MessageResponse("Comment deleted successfully")
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