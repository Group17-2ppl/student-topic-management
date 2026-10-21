package _ppl.production.impl;

import _ppl.production.entity.Student;
import _ppl.production.repository.StudentRepository;
import _ppl.production.repository.UserRepository;
import _ppl.production.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class StudentServiceImpl implements StudentService {

    private final StudentRepository studentRepository;
    private final UserRepository userRepository;

    @Override
    public List<Student> findAll() {
        return studentRepository.findAll();
    }

    @Override
    public Optional<Student> findById(Long id) {
        return studentRepository.findById(id);
    }

    @Override
    public Optional<Student> findByStudentCode(String studentCode) {
        return studentRepository.findByStudentCode(studentCode);
    }

    @Override
    public Optional<Student> findByUserId(Long userId) {
        return studentRepository.findByUserId(userId);
    }

    @Override
    public Optional<Student> findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return Optional.empty();
        }

        return userRepository.findByUsername(username.trim())
                .flatMap(user -> studentRepository.findByUserId(user.getId()));
    }

    @Override
    public Student save(Student student) {
        return studentRepository.save(student);
    }

    @Override
    public Student update(Long id, Student student) {

        Student existing = studentRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy sinh viên"));

        existing.setStudentCode(student.getStudentCode());
        existing.setClassName(student.getClassName());
        existing.setMajor(student.getMajor());

        return studentRepository.save(existing);
    }

    @Override
    public void deleteById(Long id) {
        studentRepository.deleteById(id);
    }

    @Override
    public boolean existsByStudentCode(String studentCode) {
        return studentRepository.existsByStudentCode(studentCode);
    }
}