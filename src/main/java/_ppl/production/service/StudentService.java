package _ppl.production.service;

import _ppl.production.entity.Student;

import java.util.List;
import java.util.Optional;

public interface StudentService {

    List<Student> findAll();

    Optional<Student> findById(Long id);

    Optional<Student> findByStudentCode(String studentCode);

    Optional<Student> findByUserId(Long userId);

    Optional<Student> findByUsername(String username);

    Student save(Student student);

    Student update(Long id, Student student);

    void deleteById(Long id);

    boolean existsByStudentCode(String studentCode);
}