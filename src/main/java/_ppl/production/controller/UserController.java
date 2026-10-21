package _ppl.production.controller;

import _ppl.production.entity.User;
import _ppl.production.repository.DepartmentRepository;
import _ppl.production.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final DepartmentRepository departmentRepository;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "users",
                userService.findAll()
        );

        return "admin/users/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute(
                "user",
                new User()
        );

        model.addAttribute(
                "departments",
                departmentRepository.findAll()
        );

        return "admin/users/form";
    }

    @PostMapping("/create")
    public String create(
            @ModelAttribute User user,

            @RequestParam(required = false)
            String lecturerCode,

            @RequestParam(required = false)
            Long departmentId,

            @RequestParam(required = false)
            String specialization,

            @RequestParam(required = false)
            String studentCode,

            @RequestParam(required = false)
            String className,

            @RequestParam(required = false)
            String major,

            RedirectAttributes redirectAttributes
    ) {

        try {

            userService.create(
                    user,
                    lecturerCode,
                    departmentId,
                    specialization,
                    studentCode,
                    className,
                    major
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Thêm người dùng thành công."
            );

            return "redirect:/admin/users";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/admin/users/create";
        }
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            User user =
                    userService.findById(id)
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy người dùng"
                                    )
                            );

            model.addAttribute(
                    "user",
                    user
            );

            model.addAttribute(
                    "departments",
                    departmentRepository.findAll()
            );

            if (user.getLecturer() != null) {

                model.addAttribute(
                        "lecturer",
                        user.getLecturer()
                );
            }

            if (user.getStudent() != null) {

                model.addAttribute(
                        "student",
                        user.getStudent()
                );
            }

            return "admin/users/form";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/admin/users";
        }
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,

            @ModelAttribute User user,

            @RequestParam(required = false)
            String lecturerCode,

            @RequestParam(required = false)
            Long departmentId,

            @RequestParam(required = false)
            String specialization,

            @RequestParam(required = false)
            String studentCode,

            @RequestParam(required = false)
            String className,

            @RequestParam(required = false)
            String major,

            RedirectAttributes redirectAttributes
    ) {

        try {

            userService.update(
                    id,
                    user,
                    lecturerCode,
                    departmentId,
                    specialization,
                    studentCode,
                    className,
                    major
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Cập nhật người dùng thành công."
            );

            return "redirect:/admin/users";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/admin/users/edit/" + id;
        }
    }

    @GetMapping("/delete/{id}")
    public String delete(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {

        try {

            userService.deleteById(id);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Xóa người dùng thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/users";
    }
}