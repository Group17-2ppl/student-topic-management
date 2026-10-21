package _ppl.production.controller;

import _ppl.production.entity.User;
import _ppl.production.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @PostMapping("/register")
    public String register(
            @ModelAttribute User user,
            Model model) {

        try {

            authService.register(user);

            return "redirect:/login?registered=true";

        } catch (RuntimeException e) {

            model.addAttribute(
                    "error",
                    e.getMessage()
            );

            return "register";
        }
    }
}