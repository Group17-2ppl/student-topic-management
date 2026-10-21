package _ppl.production.controller;

import _ppl.production.entity.RegistrationRound;
import _ppl.production.service.RegistrationRoundService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/registration-rounds")
@RequiredArgsConstructor
public class RegistrationRoundController {

    private final RegistrationRoundService registrationRoundService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "rounds",
                registrationRoundService.findAll()
        );

        return "admin/registration-rounds/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute(
                "registrationRound",
                new RegistrationRound()
        );

        return "admin/registration-rounds/form";
    }

    @PostMapping("/create")
    public String create(
            @ModelAttribute RegistrationRound registrationRound,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.save(registrationRound);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Tạo đợt đăng ký thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            Model model
    ) {

        RegistrationRound round = registrationRoundService
                .findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đợt đăng ký"
                        )
                );

        model.addAttribute(
                "registrationRound",
                round
        );

        return "admin/registration-rounds/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,
            @ModelAttribute RegistrationRound registrationRound,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.update(
                    id,
                    registrationRound
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Cập nhật đợt đăng ký thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @PostMapping("/open-topic-submission/{id}")
    public String openTopicSubmission(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.openTopicSubmission(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã mở giai đoạn nhận đề tài."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @PostMapping("/open-topic-review/{id}")
    public String openTopicReview(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.openTopicReview(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã chuyển sang giai đoạn duyệt đề tài."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @PostMapping("/publish/{id}")
    public String publishTopics(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.publishTopics(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã công bố các đề tài được duyệt."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @PostMapping("/close/{id}")
    public String close(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.close(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã đóng đợt đăng ký."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationRoundService.deleteById(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa đợt đăng ký."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/registration-rounds";
    }

}
