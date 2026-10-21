package _ppl.production.controller;

import _ppl.production.entity.Student;
import _ppl.production.entity.StudentGroup;
import _ppl.production.repository.StudentRepository;
import _ppl.production.service.RegistrationService;
import _ppl.production.service.StudentGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/registrations")
@RequiredArgsConstructor
public class RegistrationController {

    private final RegistrationService registrationService;

    private final StudentRepository studentRepository;

    private final StudentGroupService groupService;

    @GetMapping
    public String list(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);

            var group =
                    groupService.findByStudentId(
                            student.getId()
                    );

            if (group.isEmpty()) {

                model.addAttribute(
                        "hasGroup",
                        false
                );

                model.addAttribute(
                        "registrations",
                        java.util.Collections.emptyList()
                );

                return "registrations/list";
            }


            StudentGroup studentGroup =
                    group.get();


            model.addAttribute(
                    "hasGroup",
                    true
            );

            model.addAttribute(
                    "group",
                    studentGroup
            );

            model.addAttribute(
                    "isLeader",
                    studentGroup.getLeader()
                            .getId()
                            .equals(student.getId())
            );

            model.addAttribute(
                    "registrations",
                    registrationService
                            .findByGroupId(
                                    studentGroup.getId()
                            )
            );

            return "registrations/list";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

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

            Student student =
                    getCurrentStudent(userDetails);


            StudentGroup group =
                    groupService
                            .findByStudentId(
                                    student.getId()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Bạn chưa có nhóm. Hãy tạo hoặc tham gia nhóm trước."
                                    )
                            );


            registrationService.register(
                    group.getId(),
                    student.getId(),
                    topicId
            );


            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đăng ký đề tài thành công! Vui lòng chờ duyệt."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }


        return "redirect:/topics/" + topicId;
    }

    @GetMapping("/pending")
    public String pending(
            Model model
    ) {

        model.addAttribute(
                "registrations",
                registrationService.findPending()
        );

        return "admin/registrations/pending";
    }

    @PostMapping("/approve/{id}")
    public String approve(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationService.approve(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã duyệt yêu cầu đăng ký."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/registrations/pending";
    }

    @PostMapping("/reject/{id}")
    public String reject(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            registrationService.reject(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã từ chối yêu cầu đăng ký."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/registrations/pending";
    }

    @PostMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);


            registrationService.deleteById(
                    id,
                    student.getId()
            );


            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa đăng ký."
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