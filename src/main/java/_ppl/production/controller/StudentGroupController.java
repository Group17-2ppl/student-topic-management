package _ppl.production.controller;

import _ppl.production.entity.Student;
import _ppl.production.entity.StudentGroup;
import _ppl.production.repository.StudentRepository;
import _ppl.production.service.StudentGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/student/group")
@RequiredArgsConstructor
public class StudentGroupController {

    private final StudentRepository studentRepository;
    private final StudentGroupService groupService;

    @GetMapping
    public String group(
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

                return "student/group";
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
                    "members",
                    groupService.findMembers(
                            studentGroup.getId()
                    )
            );

            model.addAttribute(
                    "currentStudent",
                    student
            );

            boolean isLeader =
                    studentGroup.getLeader()
                            .getId()
                            .equals(student.getId());

            model.addAttribute(
                    "isLeader",
                    isLeader
            );

            return "student/group";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/";
        }
    }

    @PostMapping("/create")
    public String create(
            @RequestParam String groupName,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student student =
                    getCurrentStudent(userDetails);

            groupService.createGroup(
                    student.getId(),
                    groupName
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Tạo nhóm thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/student/group";
    }

    @PostMapping("/members/add")
    public String addMember(
            @RequestParam Long studentId,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student currentStudent =
                    getCurrentStudent(userDetails);

            StudentGroup group =
                    groupService
                            .findByStudentId(
                                    currentStudent.getId()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Bạn chưa có nhóm"
                                    )
                            );

            if (!group.getLeader()
                    .getId()
                    .equals(currentStudent.getId())) {

                throw new RuntimeException(
                        "Chỉ trưởng nhóm mới được thêm thành viên"
                );
            }

            groupService.addMember(
                    group.getId(),
                    studentId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Thêm thành viên thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/student/group";
    }

    @PostMapping("/members/remove")
    public String removeMember(
            @RequestParam Long studentId,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Student currentStudent =
                    getCurrentStudent(userDetails);

            StudentGroup group =
                    groupService
                            .findByStudentId(
                                    currentStudent.getId()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Bạn chưa có nhóm"
                                    )
                            );

            if (!group.getLeader()
                    .getId()
                    .equals(currentStudent.getId())) {

                throw new RuntimeException(
                        "Chỉ trưởng nhóm mới được xóa thành viên"
                );
            }

            groupService.removeMember(
                    group.getId(),
                    studentId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã xóa thành viên khỏi nhóm."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/student/group";
    }

    @PostMapping("/delete")
    public String deleteGroup(
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
                                            "Bạn chưa có nhóm"
                                    )
                            );

            groupService.deleteGroup(
                    group.getId(),
                    student.getId()
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Đã giải tán nhóm."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/student/group";
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
                                "Tài khoản chưa được liên kết với sinh viên"
                        )
                );
    }
}