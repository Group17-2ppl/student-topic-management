package _ppl.production.controller;

import _ppl.production.entity.Student;
import _ppl.production.entity.User;
import _ppl.production.service.StudentService;
import _ppl.production.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/students")
@RequiredArgsConstructor
public class    StudentController {

    private final StudentService studentService;
    private final UserService userService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "students",
                studentService.findAll()
        );

        return "admin/students/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute("student", new Student());
        model.addAttribute("users", userService.findAll());

        return "admin/students/form";
    }

    @PostMapping("/create")
    public String create(
            @ModelAttribute Student student,
            @RequestParam Long userId
    ) {

        User user = userService.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy user"
                        ));

        student.setUser(user);

        studentService.save(student);

        return "redirect:/admin/students";
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            Model model
    ) {

        Student student = studentService.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy sinh viên"
                        ));

        model.addAttribute("student", student);
        model.addAttribute("users", userService.findAll());

        return "admin/students/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,
            @ModelAttribute Student student,
            @RequestParam Long userId
    ) {

        User user = userService.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy user"
                        ));

        student.setUser(user);

        studentService.update(id, student);

        return "redirect:/admin/students";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {

        studentService.deleteById(id);

        return "redirect:/admin/students";
    }
}