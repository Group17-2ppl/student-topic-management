package _ppl.production.controller;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.Lecturer;
import _ppl.production.entity.Registration;
import _ppl.production.entity.Submission;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.repository.SubmissionRepository;
import _ppl.production.service.LecturerSubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@RequestMapping("/lecturer/submissions")
@RequiredArgsConstructor
public class LecturerSubmissionController {

    private final LecturerRepository lecturerRepository;
    private final SubmissionRepository submissionRepository;
    private final LecturerSubmissionService lecturerSubmissionService;

    @GetMapping
    public String list(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy thông tin giảng viên"
                                    )
                            );

            List<Assignment> assignments =
                    lecturerSubmissionService
                            .findAssignedTopics(
                                    lecturer.getId()
                            );

            model.addAttribute(
                    "assignments",
                    assignments
            );

            model.addAttribute(
                    "lecturer",
                    lecturer
            );

            return "lecturer/submissions/list";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/";
        }
    }

    @GetMapping("/topic/{topicId}")
    public String topic(
            @PathVariable Long topicId,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy thông tin giảng viên"
                                    )
                            );

            List<Registration> registrations =
                    lecturerSubmissionService
                            .findApprovedRegistrations(
                                    lecturer.getId(),
                                    topicId
                            );

            model.addAttribute(
                    "registrations",
                    registrations
            );

            if (!registrations.isEmpty()) {

                model.addAttribute(
                        "topic",
                        registrations
                                .get(0)
                                .getTopic()
                );

            }

            model.addAttribute(
                    "lecturer",
                    lecturer
            );

            return "lecturer/submissions/topic";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/lecturer/submissions";
        }
    }

    @GetMapping("/download/{submissionId}")
    public ResponseEntity<Resource> download(
            @PathVariable Long submissionId,
            @AuthenticationPrincipal UserDetails userDetails
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy giảng viên"
                                    )
                            );

            Submission submission =
                    submissionRepository
                            .findById(submissionId)
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy bài nộp"
                                    )
                            );

            if (submission.getRegistration() == null
                    || submission.getRegistration().getTopic() == null) {

                throw new RuntimeException(
                        "Bài nộp không hợp lệ"
                );
            }

            Long topicId =
                    submission
                            .getRegistration()
                            .getTopic()
                            .getId();

            boolean assigned =
                    lecturerSubmissionService
                            .findAssignedTopics(
                                    lecturer.getId()
                            )
                            .stream()
                            .anyMatch(assignment ->
                                    assignment.getTopic() != null
                                            && assignment
                                            .getTopic()
                                            .getId()
                                            .equals(topicId)
                            );

            if (!assigned) {

                return ResponseEntity
                        .status(403)
                        .build();
            }

            Path filePath =
                    Paths.get(
                            submission.getFilePath()
                    ).toAbsolutePath().normalize();

            Resource resource =
                    new UrlResource(
                            filePath.toUri()
                    );

            if (!resource.exists()
                    || !resource.isReadable()) {

                return ResponseEntity
                        .notFound()
                        .build();
            }

            return ResponseEntity
                    .ok()
                    .header(
                            HttpHeaders.CONTENT_DISPOSITION,
                            "attachment; filename=\""
                                    + submission.getFileName()
                                    + "\""
                    )
                    .header(
                            HttpHeaders.CONTENT_TYPE,
                            "application/octet-stream"
                    )
                    .body(resource);

        } catch (Exception e) {

            return ResponseEntity
                    .badRequest()
                    .build();
        }
    }
}