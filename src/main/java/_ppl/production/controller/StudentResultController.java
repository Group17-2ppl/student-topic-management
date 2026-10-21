package _ppl.production.controller;

import _ppl.production.entity.CouncilTopic;
import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;
import _ppl.production.repository.StudentRepository;
import _ppl.production.service.StudentResultService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/student/results")
@RequiredArgsConstructor
public class StudentResultController {

    private final StudentResultService studentResultService;
    private final StudentRepository studentRepository;

    @GetMapping
    public String results(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);

            List<Registration> registrations =
                    studentResultService
                            .findStudentRegistrations(
                                    student.getId()
                            );

            List<CouncilTopic> publishedResults =
                    new ArrayList<>();

            for (Registration registration : registrations) {

                if (registration.getTopic() == null) {
                    continue;
                }

                studentResultService
                        .findPublishedResult(
                                registration.getTopic().getId()
                        )
                        .ifPresent(publishedResults::add);
            }

            model.addAttribute(
                    "registrations",
                    registrations
            );

            model.addAttribute(
                    "results",
                    publishedResults
            );

            return "student/results";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/";
        }
    }

    private Student getCurrentStudent(
            UserDetails userDetails
    ) {

        if (userDetails == null) {

            throw new RuntimeException(
                    "Bạn chưa đăng nhập"
            );
        }

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
}