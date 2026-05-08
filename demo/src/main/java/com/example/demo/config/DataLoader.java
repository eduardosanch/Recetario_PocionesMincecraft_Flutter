package com.example.demo.config;

import java.util.HashSet;
import java.util.Set;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.example.demo.models.ERole;
import com.example.demo.models.Role;
import com.example.demo.models.User;
import com.example.demo.repository.RoleRepository;
import com.example.demo.repository.UserRepository;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner initRoles(
            RoleRepository roleRepository,
            UserRepository userRepository,
            PasswordEncoder passwordEncoder
    ) {
        return args -> {
            Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_USER)));

            Role moderatorRole = roleRepository.findByName(ERole.ROLE_MODERATOR)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_MODERATOR)));

            Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_ADMIN)));

            if (!userRepository.existsByUsername("admin")) {
                User adminUser = new User(
                        "admin",
                        "admin@local.dev",
                        passwordEncoder.encode("12345678")
                );

                Set<Role> roles = new HashSet<>();
                roles.add(adminRole);

                adminUser.setRoles(roles);
                userRepository.save(adminUser);

                System.out.println("Usuario admin creado: admin / 12345678");
            }

            System.out.println("Roles cargados correctamente");
        };
    }
}