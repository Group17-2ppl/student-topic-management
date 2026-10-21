package _ppl.production.impl;

import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;
import _ppl.production.entity.Submission;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.repository.StudentRepository;
import _ppl.production.repository.SubmissionRepository;
import _ppl.production.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class SubmissionServiceImpl implements SubmissionService {

    private final SubmissionRepository submissionRepository;
    private final RegistrationRepository registrationRepository;
    private final StudentRepository studentRepository;

    @Override
    @Transactional(readOnly = true)
    public Optional<Submission> findByRegistrationId(
            Long registrationId
    ) {
        return submissionRepository
                .findByRegistrationId(registrationId);
    }

    @Override
    public Submission submit(
            Long registrationId,
            Long studentId,
            String fileName,
            String filePath,
            String description
    ) {

        if (registrationId == null)
            throw new RuntimeException(
                    "Không xác định được đăng ký"
            );

        if (studentId == null)
            throw new RuntimeException(
                    "Không xác định được sinh viên"
            );

        if (fileName == null || fileName.trim().isEmpty())
            throw new RuntimeException(
                    "Vui lòng chọn file bài nộp"
            );

        if (filePath == null || filePath.trim().isEmpty())
            throw new RuntimeException(
                    "Không xác định được đường dẫn file"
            );

        Registration registration =
                registrationRepository.findById(registrationId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đăng ký"
                                )
                        );

        Student student =
                studentRepository.findById(studentId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy sinh viên"
                                )
                        );

        validateRegistration(registration, student);

        if (submissionRepository
                .existsByRegistrationId(registrationId)) {

            throw new RuntimeException(
                    "Đăng ký này đã có bài nộp"
            );
        }

        Submission submission =
                Submission.builder()
                        .registration(registration)
                        .fileName(fileName.trim())
                        .filePath(filePath.trim())
                        .description(
                                description == null
                                        ? null
                                        : description.trim()
                        )
                        .status("SUBMITTED")
                        .build();

        return submissionRepository.save(submission);
    }

    @Override
    public Submission update(
            Long registrationId,
            Long studentId,
            String fileName,
            String filePath,
            String description
    ) {

        if (fileName == null || fileName.trim().isEmpty())
            throw new RuntimeException(
                    "Vui lòng chọn file bài nộp"
            );

        if (filePath == null || filePath.trim().isEmpty())
            throw new RuntimeException(
                    "Không xác định được đường dẫn file"
            );

        Registration registration =
                registrationRepository.findById(registrationId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đăng ký"
                                )
                        );

        Student student =
                studentRepository.findById(studentId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy sinh viên"
                                )
                        );

        validateRegistration(registration, student);

        Submission submission =
                submissionRepository
                        .findByRegistrationId(registrationId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Chưa có bài nộp"
                                )
                        );

        submission.setFileName(fileName.trim());
        submission.setFilePath(filePath.trim());
        submission.setDescription(
                description == null
                        ? null
                        : description.trim()
        );

        submission.setStatus("SUBMITTED");

        return submissionRepository.save(submission);
    }

    private void validateRegistration(
            Registration registration,
            Student student
    ) {

        if (!"APPROVED".equalsIgnoreCase(
                registration.getStatus()
        )) {
            throw new RuntimeException(
                    "Chỉ được nộp bài khi đăng ký đề tài đã được duyệt"
            );
        }

        if (registration.getGroup() == null)
            throw new RuntimeException(
                    "Đăng ký chưa có nhóm"
            );

        if (registration.getGroup().getLeader() == null)
            throw new RuntimeException(
                    "Nhóm chưa có trưởng nhóm"
            );

        if (!registration.getGroup()
                .getLeader()
                .getId()
                .equals(student.getId())) {

            throw new RuntimeException(
                    "Chỉ trưởng nhóm mới được nộp bài"
            );
        }
    }
}