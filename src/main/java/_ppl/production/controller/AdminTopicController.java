package _ppl.production.controller;

import _ppl.production.service.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/topics")
@RequiredArgsConstructor
public class AdminTopicController {

    private final TopicService topicService;

    @GetMapping("/pending")
    public String pending(Model model) {

        model.addAttribute(
                "topics",
                topicService.findPending()
        );

        return "admin/topics/pending";
    }

    @PostMapping("/approve/{id}")
    public String approve(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            topicService.approve(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã duyệt đề tài."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/topics/pending";
    }

    @PostMapping("/reject/{id}")
    public String reject(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            topicService.reject(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã từ chối đề tài."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/topics/pending";
    }

    @GetMapping("/approved")
    public String approved(Model model) {

        model.addAttribute(
                "topics",
                topicService.findApproved()
        );

        return "admin/topics/approved";
    }

    @PostMapping("/publish/{id}")
    public String publish(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            topicService.publish(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã công bố đề tài. Sinh viên hiện có thể đăng ký."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/topics/approved";
    }
}