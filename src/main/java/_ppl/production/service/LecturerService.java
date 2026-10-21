package _ppl.production.service;

import _ppl.production.entity.Lecturer;

import java.util.List;
import java.util.Optional;

public interface LecturerService {

    List<Lecturer> findAll();

    Optional<Lecturer> findById(Long id);

    Optional<Lecturer> findByLecturerCode(String lecturerCode);

    Optional<Lecturer> findByUserId(Long userId);

    Optional<Lecturer> findByUsername(String username);

    Lecturer save(Lecturer lecturer);

    Lecturer update(Long id, Lecturer lecturer);

    void deleteById(Long id);

    boolean existsByLecturerCode(String lecturerCode);

}