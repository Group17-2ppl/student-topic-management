package _ppl.production.controller;

import _ppl.production.service.AssignmentService;
import _ppl.production.service.LecturerService;
import _ppl.production.service.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/assignments")
@RequiredArgsConstructor
public class AssignmentController {

    private final AssignmentService assignmentService;
    private final TopicService topicService;
    private final LecturerService lecturerService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "assignments",
                assignmentService.findAll()
        );

        return "admin/assignments/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute(
                "topics",
                topicService.findTopicsWithApprovedRegistration()
        );

        model.addAttribute(
                "lecturers",
                lecturerService.findAll()
        );

        return "admin/assignments/form";
    }

    @PostMapping("/create")
    public String create(
            @RequestParam Long topicId,
            @RequestParam Long lecturerId,
            @RequestParam String role,
            RedirectAttributes redirectAttributes
    ) {

        try {

            assignmentService.assign(
                    topicId,
                    lecturerId,
                    role
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Phân công giảng viên thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/assignments";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            assignmentService.deleteById(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa phân công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/assignments";
    }
}