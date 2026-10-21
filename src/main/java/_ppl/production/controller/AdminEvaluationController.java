package _ppl.production.controller;

import _ppl.production.service.CouncilEvaluationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/evaluations")
@RequiredArgsConstructor
public class AdminEvaluationController {

    private final CouncilEvaluationService evaluationService;

    @PostMapping("/publish/{councilTopicId}")
    public String publish(
            @PathVariable Long councilTopicId,
            RedirectAttributes redirectAttributes
    ) {

        try {

            evaluationService.publishResult(
                    councilTopicId
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Công bố kết quả thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/admin/councils";
    }
}