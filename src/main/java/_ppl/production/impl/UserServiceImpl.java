package _ppl.production.impl;

import _ppl.production.entity.Department;
import _ppl.production.entity.Lecturer;
import _ppl.production.entity.Student;
import _ppl.production.entity.User;
import _ppl.production.repository.DepartmentRepository;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.repository.StudentRepository;
import _ppl.production.repository.UserRepository;
import _ppl.production.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final LecturerRepository lecturerRepository;
    private final StudentRepository studentRepository;
    private final DepartmentRepository departmentRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User save(User user) {

        if (user.getPassword() == null
                || user.getPassword().isBlank()) {

            throw new RuntimeException(
                    "Mật khẩu không được để trống"
            );
        }

        user.setPassword(
                passwordEncoder.encode(
                        user.getPassword()
                )
        );

        return userRepository.save(user);
    }

    @Override
    public User create(
            User user,
            String lecturerCode,
            Long departmentId,
            String specialization,
            String studentCode,
            String className,
            String major
    ) {

        if (user.getUsername() == null
                || user.getUsername().isBlank()) {

            throw new RuntimeException(
                    "Username không được để trống"
            );
        }

        if (user.getPassword() == null
                || user.getPassword().isBlank()) {

            throw new RuntimeException(
                    "Mật khẩu không được để trống"
            );
        }

        if (user.getRole() == null
                || user.getRole().isBlank()) {

            throw new RuntimeException(
                    "Vai trò không được để trống"
            );
        }

        if (userRepository.existsByUsername(
                user.getUsername().trim()
        )) {

            throw new RuntimeException(
                    "Username đã tồn tại"
            );
        }

        if (user.getEmail() != null
                && !user.getEmail().isBlank()
                && userRepository.existsByEmail(
                user.getEmail().trim()
        )) {

            throw new RuntimeException(
                    "Email đã tồn tại"
            );
        }

        user.setUsername(
                user.getUsername().trim()
        );

        user.setRole(
                user.getRole().trim().toUpperCase()
        );

        /*
         * BCrypt password
         */
        user.setPassword(
                passwordEncoder.encode(
                        user.getPassword()
                )
        );

        User savedUser =
                userRepository.save(user);

        if ("STUDENT".equals(savedUser.getRole())) {

            if (studentCode == null || studentCode.isBlank()) {
                throw new RuntimeException("Mã sinh viên không được để trống");
            }

            String normalizedStudentCode = studentCode.trim();

            if (studentRepository.findByStudentCode(normalizedStudentCode).isPresent()) {
                throw new RuntimeException("Mã sinh viên đã tồn tại");
            }

            Student student = Student.builder()
                    .user(savedUser)
                    .studentCode(normalizedStudentCode)
                    .className(className != null && !className.isBlank() ? className.trim() : null)
                    .major(major != null && !major.isBlank() ? major.trim() : null)
                    .build();

            studentRepository.save(student);
        }

        if ("LECTURER".equals(
                savedUser.getRole()
        )) {

            if (lecturerCode == null
                    || lecturerCode.isBlank()) {

                throw new RuntimeException(
                        "Mã giảng viên không được để trống"
                );
            }

            if (specialization == null
                    || specialization.isBlank()) {

                throw new RuntimeException(
                        "Chuyên môn không được để trống"
                );
            }

            if (departmentId == null) {

                throw new RuntimeException(
                        "Vui lòng chọn khoa"
                );
            }

            if (lecturerRepository
                    .findByLecturerCode(
                            lecturerCode.trim()
                    )
                    .isPresent()) {

                throw new RuntimeException(
                        "Mã giảng viên đã tồn tại"
                );
            }

            Department department =
                    departmentRepository
                            .findById(departmentId)
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy khoa"
                                    )
                            );

            Lecturer lecturer =
                    Lecturer.builder()
                            .user(savedUser)
                            .lecturerCode(
                                    lecturerCode.trim()
                            )
                            .department(department)
                            .specialization(
                                    specialization.trim()
                            )
                            .build();

            lecturerRepository.save(
                    lecturer
            );
        }

        return savedUser;
    }

    @Override
    public User update(
            Long id,
            User user,
            String lecturerCode,
            Long departmentId,
            String specialization,
            String studentCode,
            String className,
            String major
    ) {

        User existingUser =
                userRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy người dùng"
                                )
                        );

        existingUser.setUsername(
                user.getUsername()
        );

        existingUser.setEmail(
                user.getEmail()
        );

        existingUser.setRole(
                user.getRole()
                        .trim()
                        .toUpperCase()
        );

        existingUser.setFullName(
                user.getFullName()
        );

        existingUser.setPhone(
                user.getPhone()
        );

        existingUser.setAddress(
                user.getAddress()
        );

        /*
         * Chỉ đổi password khi Admin nhập password mới.
         */
        if (user.getPassword() != null
                && !user.getPassword().isBlank()) {

            existingUser.setPassword(
                    passwordEncoder.encode(
                            user.getPassword()
                    )
            );
        }

        User savedUser =
                userRepository.save(
                        existingUser
                );

        if ("STUDENT".equals(savedUser.getRole())) {

            Student student = studentRepository
                    .findByUserId(savedUser.getId())
                    .orElse(null);

            if (student == null) {
                if (studentCode == null || studentCode.isBlank()) {
                    throw new RuntimeException("Mã sinh viên không được để trống");
                }

                String normalizedStudentCode = studentCode.trim();
                if (studentRepository.findByStudentCode(normalizedStudentCode).isPresent()) {
                    throw new RuntimeException("Mã sinh viên đã tồn tại");
                }

                student = Student.builder()
                        .user(savedUser)
                        .studentCode(normalizedStudentCode)
                        .className(className != null && !className.isBlank() ? className.trim() : null)
                        .major(major != null && !major.isBlank() ? major.trim() : null)
                        .build();
            } else {
                if (studentCode != null && !studentCode.isBlank()
                        && !studentCode.trim().equals(student.getStudentCode())
                        && studentRepository.findByStudentCode(studentCode.trim()).isPresent()) {
                    throw new RuntimeException("Mã sinh viên đã tồn tại");
                }

                if (studentCode != null && !studentCode.isBlank()) {
                    student.setStudentCode(studentCode.trim());
                }
                student.setClassName(className != null && !className.isBlank() ? className.trim() : null);
                student.setMajor(major != null && !major.isBlank() ? major.trim() : null);
            }

            studentRepository.save(student);
        }

        if ("LECTURER".equals(
                savedUser.getRole()
        )) {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUserId(
                                    savedUser.getId()
                            )
                            .orElse(null);

            if (lecturer == null) {

                if (lecturerCode == null
                        || lecturerCode.isBlank()) {

                    throw new RuntimeException(
                            "Mã giảng viên không được để trống"
                    );
                }

                if (departmentId == null) {

                    throw new RuntimeException(
                            "Vui lòng chọn khoa"
                    );
                }

                if (specialization == null
                        || specialization.isBlank()) {

                    throw new RuntimeException(
                            "Chuyên môn không được để trống"
                    );
                }

                Department department =
                        departmentRepository
                                .findById(departmentId)
                                .orElseThrow(() ->
                                        new RuntimeException(
                                                "Không tìm thấy khoa"
                                        )
                                );

                lecturer =
                        Lecturer.builder()
                                .user(savedUser)
                                .lecturerCode(
                                        lecturerCode.trim()
                                )
                                .department(department)
                                .specialization(
                                        specialization.trim()
                                )
                                .build();

            } else {

                if (lecturerCode != null
                        && !lecturerCode.isBlank()) {

                    lecturer.setLecturerCode(
                            lecturerCode.trim()
                    );
                }

                if (departmentId != null) {

                    Department department =
                            departmentRepository
                                    .findById(
                                            departmentId
                                    )
                                    .orElseThrow(() ->
                                            new RuntimeException(
                                                    "Không tìm thấy khoa"
                                            )
                                    );

                    lecturer.setDepartment(
                            department
                    );
                }

                if (specialization != null
                        && !specialization.isBlank()) {

                    lecturer.setSpecialization(
                            specialization.trim()
                    );
                }
            }

            lecturerRepository.save(
                    lecturer
            );
        }

        return savedUser;
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByUsername(
            String username
    ) {
        return userRepository
                .existsByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByEmail(
            String email
    ) {
        return userRepository
                .existsByEmail(email);
    }
}