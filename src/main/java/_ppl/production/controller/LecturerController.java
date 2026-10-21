package _ppl.production.controller;

import _ppl.production.entity.Lecturer;
import _ppl.production.entity.User;
import _ppl.production.service.LecturerService;
import _ppl.production.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/lecturers")
@RequiredArgsConstructor
public class LecturerController {

    private final LecturerService lecturerService;
    private final UserService userService;

    @GetMapping
    public String list(Model model) {

        model.addAttribute(
                "lecturers",
                lecturerService.findAll()
        );

        return "admin/lecturers/list";
    }

    @GetMapping("/create")
    public String createForm(Model model) {

        model.addAttribute(
                "lecturer",
                new Lecturer()
        );

        model.addAttribute(
                "users",
                userService.findAll()
        );

        return "admin/lecturers/form";
    }

    @PostMapping("/create")
    public String create(
            @ModelAttribute Lecturer lecturer,
            @RequestParam Long userId
    ) {

        User user = userService.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy user"
                        ));

        lecturer.setUser(user);

        lecturerService.save(lecturer);

        return "redirect:/admin/lecturers";
    }

    @GetMapping("/edit/{id}")
    public String editForm(
            @PathVariable Long id,
            Model model
    ) {

        Lecturer lecturer = lecturerService.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy giảng viên"
                        ));

        model.addAttribute("lecturer", lecturer);
        model.addAttribute(
                "users",
                userService.findAll()
        );

        return "admin/lecturers/form";
    }

    @PostMapping("/edit/{id}")
    public String update(
            @PathVariable Long id,
            @ModelAttribute Lecturer lecturer,
            @RequestParam Long userId
    ) {

        User user = userService.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy user"
                        ));

        lecturer.setUser(user);

        lecturerService.update(id, lecturer);

        return "redirect:/admin/lecturers";
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {

        lecturerService.deleteById(id);

        return "redirect:/admin/lecturers";
    }
}