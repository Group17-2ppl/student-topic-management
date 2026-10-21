package _ppl.production.service;

import _ppl.production.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    List<User> findAll();

    Optional<User> findById(Long id);

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    User save(User user);

    User create(
            User user,
            String lecturerCode,
            Long departmentId,
            String specialization,
            String studentCode,
            String className,
            String major
    );

    User update(
            Long id,
            User user,
            String lecturerCode,
            Long departmentId,
            String specialization,
            String studentCode,
            String className,
            String major
    );

    void deleteById(Long id);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
}