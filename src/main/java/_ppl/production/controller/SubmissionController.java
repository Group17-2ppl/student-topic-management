package _ppl.production.controller;

import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;
import _ppl.production.entity.StudentGroup;
import _ppl.production.entity.Submission;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.repository.StudentRepository;
import _ppl.production.service.SubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Controller
@RequestMapping("/submission")
@RequiredArgsConstructor
public class SubmissionController {

    private final SubmissionService submissionService;
    private final RegistrationRepository registrationRepository;
    private final StudentRepository studentRepository;

    private static final String UPLOAD_DIR =
            "uploads/submissions";

    @GetMapping("/{registrationId}")
    public String form(
            @PathVariable Long registrationId,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);

            Registration registration =
                    registrationRepository.findById(
                            registrationId
                    ).orElseThrow(() ->
                            new RuntimeException(
                                    "Không tìm thấy đăng ký"
                            )
                    );

            validateAccess(registration, student);

            Submission submission =
                    submissionService
                            .findByRegistrationId(
                                    registrationId
                            )
                            .orElse(null);

            model.addAttribute(
                    "registration",
                    registration
            );

            model.addAttribute(
                    "submission",
                    submission
            );

            return "submission/form";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/registrations";
        }
    }

    @PostMapping("/{registrationId}")
    public String submit(
            @PathVariable Long registrationId,
            @RequestParam("file") MultipartFile file,
            @RequestParam(required = false) String description,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);

            Registration registration =
                    registrationRepository.findById(
                            registrationId
                    ).orElseThrow(() ->
                            new RuntimeException(
                                    "Không tìm thấy đăng ký"
                            )
                    );

            validateAccess(registration, student);

            if (file == null || file.isEmpty()) {
                throw new RuntimeException(
                        "Vui lòng chọn file bài nộp"
                );
            }

            Path uploadPath =
                    Paths.get(UPLOAD_DIR)
                            .toAbsolutePath()
                            .normalize();

            Files.createDirectories(uploadPath);

            String originalName =
                    file.getOriginalFilename();

            if (originalName == null ||
                    originalName.trim().isEmpty()) {

                throw new RuntimeException(
                        "Tên file không hợp lệ"
                );
            }

            String storedFileName =
                    UUID.randomUUID()
                            + "_"
                            + Paths.get(originalName)
                            .getFileName();

            Path target =
                    uploadPath.resolve(storedFileName);

            Files.copy(
                    file.getInputStream(),
                    target
            );

            Submission existing =
                    submissionService
                            .findByRegistrationId(
                                    registrationId
                            )
                            .orElse(null);

            if (existing == null) {

                submissionService.submit(
                        registrationId,
                        student.getId(),
                        originalName,
                        target.toString(),
                        description
                );

                redirectAttributes.addFlashAttribute(
                        "success",
                        "Nộp bài thành công."
                );

            } else {

                submissionService.update(
                        registrationId,
                        student.getId(),
                        originalName,
                        target.toString(),
                        description
                );

                redirectAttributes.addFlashAttribute(
                        "success",
                        "Đã cập nhật bài nộp."
                );
            }

        } catch (IOException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    "Không thể lưu file bài nộp."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/registrations";
    }

    private Student getCurrentStudent(
            UserDetails userDetails
    ) {

        if (userDetails == null)
            throw new RuntimeException(
                    "Bạn chưa đăng nhập"
            );

        return studentRepository
                .findByUser_Username(
                        userDetails.getUsername()
                )
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy thông tin sinh viên"
                        )
                );
    }

    private void validateAccess(
            Registration registration,
            Student student
    ) {

        if (!"APPROVED".equalsIgnoreCase(
                registration.getStatus()
        )) {

            throw new RuntimeException(
                    "Đăng ký đề tài chưa được duyệt"
            );
        }

        StudentGroup group =
                registration.getGroup();

        if (group == null ||
                group.getLeader() == null ||
                !group.getLeader()
                        .getId()
                        .equals(student.getId())) {

            throw new RuntimeException(
                    "Chỉ trưởng nhóm mới được nộp bài"
            );
        }
    }
}