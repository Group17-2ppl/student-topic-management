package _ppl.production.repository;

import _ppl.production.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Long> {

    Optional<Student> findByStudentCode(String studentCode);

    Optional<Student> findByUserId(Long userId);

    boolean existsByStudentCode(String studentCode);

    Optional<Student> findByUser_Username(String username);
}