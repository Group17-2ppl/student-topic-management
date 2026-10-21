package _ppl.production.controller;

import _ppl.production.entity.CouncilEvaluation;
import _ppl.production.entity.CouncilMember;
import _ppl.production.entity.CouncilTopic;
import _ppl.production.entity.Lecturer;
import _ppl.production.repository.CouncilEvaluationRepository;
import _ppl.production.repository.CouncilMemberRepository;
import _ppl.production.repository.CouncilTopicRepository;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.service.CouncilEvaluationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/lecturer/evaluations")
@RequiredArgsConstructor
public class LecturerEvaluationController {

    private final LecturerRepository lecturerRepository;
    private final CouncilMemberRepository councilMemberRepository;
    private final CouncilTopicRepository councilTopicRepository;
    private final CouncilEvaluationRepository evaluationRepository;
    private final CouncilEvaluationService evaluationService;

    @GetMapping
    public String list(
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Tài khoản chưa được liên kết với giảng viên"
                                    )
                            );

            List<CouncilTopic> topics =
                    councilTopicRepository.findScorableByLecturerId(lecturer.getId());

            model.addAttribute(
                    "topics",
                    topics
            );

            model.addAttribute(
                    "lecturer",
                    lecturer
            );

            return "lecturer/evaluations/list";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/";
        }
    }

    @GetMapping("/topic/{councilTopicId}")
    public String form(
            @PathVariable Long councilTopicId,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy giảng viên"
                                    )
                            );

            CouncilTopic councilTopic =
                    councilTopicRepository
                            .findById(councilTopicId)
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy đề tài trong hội đồng"
                                    )
                            );

            CouncilMember member =
                    councilMemberRepository
                            .findByCouncilIdAndLecturerId(
                                    councilTopic
                                            .getCouncil()
                                            .getId(),
                                    lecturer.getId()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Bạn không phải thành viên của hội đồng này"
                                    )
                            );

            model.addAttribute(
                    "councilTopic",
                    councilTopic
            );

            model.addAttribute(
                    "member",
                    member
            );

            CouncilEvaluation evaluation =
                    evaluationRepository
                            .findByCouncilTopicIdAndCouncilMemberId(
                                    councilTopicId,
                                    member.getId()
                            )
                            .orElse(null);

            model.addAttribute(
                    "evaluation",
                    evaluation
            );

            model.addAttribute(
                    "evaluations",
                    evaluationRepository
                            .findByCouncilTopicId(
                                    councilTopicId
                            )
            );

            return "lecturer/evaluations/form";

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );

            return "redirect:/lecturer/evaluations";
        }
    }

    @PostMapping("/save")
    public String save(
            @RequestParam Long councilTopicId,
            @RequestParam Double score,
            @RequestParam(required = false) String comment,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes
    ) {

        try {

            Lecturer lecturer =
                    lecturerRepository
                            .findByUser_Username(
                                    userDetails.getUsername()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy giảng viên"
                                    )
                            );

            CouncilTopic councilTopic =
                    councilTopicRepository
                            .findById(councilTopicId)
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Không tìm thấy đề tài trong hội đồng"
                                    )
                            );

            CouncilMember member =
                    councilMemberRepository
                            .findByCouncilIdAndLecturerId(
                                    councilTopic
                                            .getCouncil()
                                            .getId(),
                                    lecturer.getId()
                            )
                            .orElseThrow(() ->
                                    new RuntimeException(
                                            "Bạn không được phân công chấm đề tài này"
                                    )
                            );

            evaluationService.evaluate(
                    councilTopicId,
                    member.getId(),
                    score,
                    comment
            );

            redirectAttributes.addFlashAttribute(
                    "success",
                    "Lưu điểm và nhận xét thành công."
            );

        } catch (RuntimeException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage()
            );
        }

        return "redirect:/lecturer/evaluations/topic/"
                + councilTopicId;
    }

}