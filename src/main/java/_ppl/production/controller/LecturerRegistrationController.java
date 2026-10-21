package _ppl.production.controller;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.Lecturer;
import _ppl.production.service.AssignmentService;
import _ppl.production.service.LecturerService;
import _ppl.production.service.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/lecturer/registrations")
@RequiredArgsConstructor
public class LecturerRegistrationController {

    private final AssignmentService assignmentService;
    private final LecturerService lecturerService;
    private final TopicService topicService;

    @GetMapping
    public String list(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        try {
            Lecturer lecturer = currentLecturer(userDetails);
            List<Assignment> assignments =
                    assignmentService.findByLecturerId(lecturer.getId());

            model.addAttribute("lecturer", lecturer);
            model.addAttribute("assignments", assignments);
            model.addAttribute("topics", topicService.findTopicsWithApprovedRegistration());
            return "lecturer/registrations/list";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/";
        }
    }

    @PostMapping("/register")
    public String register(
            @RequestParam Long topicId,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {
        try {
            Lecturer lecturer = currentLecturer(userDetails);
            assignmentService.registerGuidance(topicId, lecturer.getId());
            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đăng ký hướng dẫn thành công."
            );
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/lecturer/registrations";
    }

    private Lecturer currentLecturer(UserDetails userDetails) {
        if (userDetails == null || userDetails.getUsername() == null) {
            throw new RuntimeException("Phiên đăng nhập không hợp lệ");
        }
        return lecturerService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException(
                        "Không tìm thấy thông tin giảng viên cho tài khoản: "
                                + userDetails.getUsername()
                ));
    }
}
