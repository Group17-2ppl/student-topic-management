package _ppl.production.controller;

import _ppl.production.entity.Lecturer;
import _ppl.production.entity.Topic;
import _ppl.production.service.DepartmentService;
import _ppl.production.service.LecturerService;
import _ppl.production.service.RegistrationRoundService;
import _ppl.production.service.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/topics")
@RequiredArgsConstructor
public class TopicController {

    private final TopicService topicService;
    private final LecturerService lecturerService;
    private final RegistrationRoundService registrationRoundService;
    private final DepartmentService departmentService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "topics",
                topicService.findOpenTopics()
        );

        return "topics/list";
    }

    @GetMapping("/open")
    public String openTopics(Model model) {

        model.addAttribute(
                "topics",
                topicService.findOpenTopics()
        );

        return "topics/list";
    }

    @GetMapping("/search")
    public String search(
            @RequestParam(required = false) String keyword,
            Model model
    ) {

        model.addAttribute(
                "topics",
                topicService.search(keyword)
        );

        model.addAttribute(
                "keyword",
                keyword
        );

        return "topics/list";
    }

    @GetMapping("/{id}")
    public String detail(
            @PathVariable Long id,
            Model model
    ) {

        Topic topic = topicService.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        model.addAttribute(
                "topic",
                topic
        );

        return "topics/detail";
    }

    @GetMapping("/create")
    public String createForm(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model
    ) {

        Lecturer lecturer = getCurrentLecturer(userDetails);

        model.addAttribute(
                "topic",
                new Topic()
        );

        model.addAttribute(
                "registrationRounds",
                registrationRoundService.findByStatus(
                        "TOPIC_SUBMISSION"
                )
        );

        model.addAttribute(
                "departments",
                departmentService.findAll()
        );

        model.addAttribute(
                "currentDepartment",
                lecturer.getDepartment()
        );

        return "topics/form";
    }

    @PostMapping("/create")
    public String create(
            @ModelAttribute Topic topic,
            @RequestParam Long registrationRoundId,
            @RequestParam Long departmentId,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer = getCurrentLecturer(userDetails);

            topicService.create(
                    topic,
                    lecturer.getId(),
                    registrationRoundId,
                    departmentId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Tạo đề tài thành công. Đề tài đang chờ Trưởng khoa duyệt."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/topics";
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model
    ) {

        Lecturer lecturer = getCurrentLecturer(userDetails);

        Topic topic = topicService.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        checkOwner(topic, lecturer);

        model.addAttribute(
                "topic",
                topic
        );

        model.addAttribute(
                "departments",
                departmentService.findAll()
        );

        model.addAttribute(
                "registrationRounds",
                registrationRoundService.findByStatus(
                        "TOPIC_SUBMISSION"
                )
        );

        return "topics/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,
            @ModelAttribute Topic topic,
            @RequestParam Long departmentId,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer = getCurrentLecturer(userDetails);

            topicService.update(
                    id,
                    topic,
                    lecturer.getId(),
                    departmentId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Cập nhật đề tài thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/topics";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer = getCurrentLecturer(userDetails);

            Topic topic = topicService.findById(id)
                    .orElseThrow(() ->
                            new RuntimeException(
                                    "Không tìm thấy đề tài"
                            ));

            checkOwner(topic, lecturer);

            topicService.deleteById(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa đề tài."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/topics";
    }

    private Lecturer getCurrentLecturer(
            UserDetails userDetails
    ) {

        return lecturerService
                .findByUsername(userDetails.getUsername())
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy thông tin giảng viên"
                        ));
    }

    private void checkOwner(
            Topic topic,
            Lecturer lecturer
    ) {

        if (topic.getCreatedBy() == null ||
                !topic.getCreatedBy()
                        .getId()
                        .equals(lecturer.getId())) {

            throw new RuntimeException(
                    "Bạn không có quyền thao tác với đề tài này"
            );
        }
    }
}