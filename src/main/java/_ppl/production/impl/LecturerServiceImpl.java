package _ppl.production.impl;

import _ppl.production.entity.Lecturer;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.service.LecturerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class LecturerServiceImpl implements LecturerService {

    private final LecturerRepository lecturerRepository;

    @Override
    public List<Lecturer> findAll() {
        return lecturerRepository.findAll();
    }

    @Override
    public Optional<Lecturer> findById(Long id) {
        return lecturerRepository.findById(id);
    }

    @Override
    public Optional<Lecturer> findByLecturerCode(String lecturerCode) {
        return lecturerRepository.findByLecturerCode(lecturerCode);
    }

    @Override
    public Optional<Lecturer> findByUserId(Long userId) {
        return lecturerRepository.findByUserId(userId);
    }

    @Override
    public Optional<Lecturer> findByUsername(String username) {
        return lecturerRepository.findByUser_Username(username);
    }

    @Override
    public Lecturer save(Lecturer lecturer) {
        return lecturerRepository.save(lecturer);
    }

    @Override
    public Lecturer update(Long id, Lecturer lecturer) {

        Lecturer existing = lecturerRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy giảng viên"
                        ));

        existing.setLecturerCode(lecturer.getLecturerCode());
        existing.setDepartment(lecturer.getDepartment());
        existing.setSpecialization(lecturer.getSpecialization());

        return lecturerRepository.save(existing);
    }

    @Override
    public void deleteById(Long id) {
        lecturerRepository.deleteById(id);
    }

    @Override
    public boolean existsByLecturerCode(String lecturerCode) {
        return lecturerRepository.existsByLecturerCode(lecturerCode);
    }

}