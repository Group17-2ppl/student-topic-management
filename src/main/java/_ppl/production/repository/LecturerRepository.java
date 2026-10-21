package _ppl.production.repository;

import _ppl.production.entity.Lecturer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LecturerRepository extends JpaRepository<Lecturer, Long> {

    Optional<Lecturer> findByLecturerCode(String lecturerCode);

    Optional<Lecturer> findByUserId(Long userId);

    Optional<Lecturer> findByUser_Username(String username);

    boolean existsByLecturerCode(String lecturerCode);

}