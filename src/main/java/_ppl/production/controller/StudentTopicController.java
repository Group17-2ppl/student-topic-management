package _ppl.production.controller;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.GroupMember;
import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;
import _ppl.production.entity.Submission;
import _ppl.production.service.StudentTopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@RequestMapping("/student/my-topic")
@RequiredArgsConstructor
public class StudentTopicController {

    private final StudentTopicService studentTopicService;

    @GetMapping
    public String myTopic(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);


            Registration registration =
                    studentTopicService
                            .findMyRegistration(
                                    student.getId()
                            )
                            .orElse(null);


            model.addAttribute(
                    "student",
                    student
            );

            model.addAttribute(
                    "registration",
                    registration
            );

            if (registration != null) {

                if (registration.getGroup() != null) {

                    List<GroupMember> members =
                            studentTopicService
                                    .findGroupMembers(
                                            registration
                                                    .getGroup()
                                                    .getId()
                                    );

                    model.addAttribute(
                            "members",
                            members
                    );

                } else {

                    model.addAttribute(
                            "members",
                            List.of()
                    );
                }

                if (registration.getTopic() != null) {

                    List<Assignment> supervisors =
                            studentTopicService
                                    .findSupervisors(
                                            registration
                                                    .getTopic()
                                                    .getId()
                                    );

                    model.addAttribute(
                            "supervisors",
                            supervisors
                    );

                } else {

                    model.addAttribute(
                            "supervisors",
                            List.of()
                    );
                }

                Submission submission =
                        registration.getSubmission();

                model.addAttribute(
                        "submission",
                        submission
                );

            } else {

                model.addAttribute(
                        "members",
                        List.of()
                );

                model.addAttribute(
                        "supervisors",
                        List.of()
                );

                model.addAttribute(
                        "submission",
                        null
                );
            }


            return "student/my-topic";


        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/topics";
        }
    }

    @GetMapping("/download/{submissionId}")
    public ResponseEntity<Resource> download(
            @PathVariable Long submissionId,
            @AuthenticationPrincipal UserDetails userDetails
    ) {

        Student student =
                getCurrentStudent(userDetails);


        Registration registration =
                studentTopicService
                        .findMyRegistration(
                                student.getId()
                        )
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Sinh viên chưa có đề tài"
                                )
                        );


        Submission submission =
                registration.getSubmission();

        if (submission == null ||
                submission.getId() == null ||
                !submission.getId()
                        .equals(submissionId)) {

            return ResponseEntity
                    .notFound()
                    .build();
        }


        if (submission.getFilePath() == null ||
                submission.getFilePath().isBlank()) {

            return ResponseEntity
                    .notFound()
                    .build();
        }


        Path path =
                Paths.get(
                                submission.getFilePath()
                        )
                        .toAbsolutePath()
                        .normalize();


        if (!Files.exists(path) ||
                !Files.isRegularFile(path)) {

            return ResponseEntity
                    .notFound()
                    .build();
        }


        Resource resource =
                new FileSystemResource(path);


        String fileName =
                submission.getFileName();


        if (fileName == null ||
                fileName.isBlank()) {

            fileName =
                    path.getFileName()
                            .toString();
        }


        MediaType mediaType =
                MediaType.APPLICATION_OCTET_STREAM;


        try {

            String detected =
                    Files.probeContentType(path);


            if (detected != null) {

                mediaType =
                        MediaType.parseMediaType(
                                detected
                        );
            }

        } catch (Exception ignored) {

        }


        return ResponseEntity
                .ok()

                .contentType(mediaType)

                .header(
                        HttpHeaders.CONTENT_DISPOSITION,

                        ContentDisposition
                                .attachment()
                                .filename(fileName)
                                .build()
                                .toString()
                )

                .body(resource);
    }

    private Student getCurrentStudent(
            UserDetails userDetails
    ) {

        if (userDetails == null) {

            throw new RuntimeException(
                    "Bạn chưa đăng nhập"
            );
        }


        return studentTopicService
                .findStudentByUsername(
                        userDetails.getUsername()
                )

                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy thông tin sinh viên"
                        )
                );
    }
}