package _ppl.production.controller;

import _ppl.production.entity.Council;
import _ppl.production.service.CouncilService;
import _ppl.production.service.LecturerService;
import _ppl.production.service.RegistrationRoundService;
import _ppl.production.service.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/councils")
@RequiredArgsConstructor
public class CouncilController {

    private final CouncilService councilService;
    private final LecturerService lecturerService;
    private final RegistrationRoundService registrationRoundService;
    private final TopicService topicService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "councils",
                councilService.findAll()
        );

        return "admin/councils/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute(
                "council",
                new Council()
        );

        model.addAttribute(
                "registrationRounds",
                registrationRoundService.findAll()
        );

        return "admin/councils/form";
    }

    @PostMapping("/create")
    public String create(
            @RequestParam String name,
            @RequestParam Long registrationRoundId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Council council = Council.builder()
                    .name(name)
                    .registrationRound(
                            registrationRoundService
                                    .findById(registrationRoundId)
                                    .orElseThrow(() ->
                                            new RuntimeException(
                                                    "Không tìm thấy đợt đăng ký"
                                            )
                                    )
                    )
                    .status("DRAFT")
                    .build();

            councilService.save(council);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Tạo hội đồng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils";
    }

    @GetMapping("/{id}")
    public String detail(
            @PathVariable Long id,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Council council = councilService.findById(id)
                    .orElseThrow(() ->
                            new RuntimeException(
                                    "Không tìm thấy hội đồng"
                            )
                    );

            model.addAttribute(
                    "council",
                    council
            );

            model.addAttribute(
                    "members",
                    council.getMembers()
            );

            model.addAttribute(
                    "topics",
                    council.getTopics()
            );

            model.addAttribute(
                    "lecturers",
                    lecturerService.findAll()
            );

            model.addAttribute(
                    "openTopics",
                    topicService.findOpenTopics()
            );

            return "admin/councils/detail";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/admin/councils";
        }
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Council council = councilService.findById(id)
                    .orElseThrow(() ->
                            new RuntimeException(
                                    "Không tìm thấy hội đồng"
                            )
                    );

            model.addAttribute(
                    "council",
                    council
            );

            model.addAttribute(
                    "registrationRounds",
                    registrationRoundService.findAll()
            );

            return "admin/councils/form";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/admin/councils";
        }
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam Long registrationRoundId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Council council = Council.builder()
                    .name(name)
                    .registrationRound(
                            registrationRoundService
                                    .findById(registrationRoundId)
                                    .orElseThrow(() ->
                                            new RuntimeException(
                                                    "Không tìm thấy đợt đăng ký"
                                            )
                                    )
                    )
                    .build();

            councilService.update(
                    id,
                    council
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Cập nhật hội đồng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.deleteById(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa hội đồng."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils";
    }

    @PostMapping("/{id}/members/add")
    public String addMember(
            @PathVariable Long id,
            @RequestParam Long lecturerId,
            @RequestParam String role,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.addMember(
                    id,
                    lecturerId,
                    role
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Thêm thành viên hội đồng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + id;
    }

    @PostMapping("/members/delete/{memberId}")
    public String removeMember(
            @PathVariable Long memberId,
            @RequestParam Long councilId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.removeMember(
                    memberId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa thành viên khỏi hội đồng."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + councilId;
    }

    @PostMapping("/{id}/topics/add")
    public String assignTopic(
            @PathVariable Long id,
            @RequestParam Long topicId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.assignTopic(
                    id,
                    topicId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Thêm đề tài vào hội đồng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + id;
    }

    @PostMapping("/topics/delete/{councilTopicId}")
    public String removeTopic(
            @PathVariable Long councilTopicId,
            @RequestParam Long councilId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.removeTopic(
                    councilTopicId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa đề tài khỏi hội đồng."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + councilId;
    }

    @PostMapping("/activate/{id}")
    public String activate(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.activate(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Kích hoạt hội đồng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + id;
    }

    @PostMapping("/complete/{id}")
    public String complete(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            councilService.complete(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã hoàn thành hội đồng."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils/" + id;
    }
}