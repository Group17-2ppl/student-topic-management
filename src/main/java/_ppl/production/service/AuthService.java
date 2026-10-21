package _ppl.production.service;

import _ppl.production.entity.User;
import _ppl.production.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    public void register(User user) {

        if (userRepository.existsByUsername(
                user.getUsername())) {

            throw new RuntimeException(
                    "Username đã tồn tại!"
            );
        }

        if (userRepository.existsByEmail(
                user.getEmail())) {

            throw new RuntimeException(
                    "Email đã tồn tại!"
            );
        }

        user.setPassword(
                passwordEncoder.encode(
                        user.getPassword()
                )
        );

        user.setRole("STUDENT");

        userRepository.save(user);
    }
}