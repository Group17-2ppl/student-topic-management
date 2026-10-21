package _ppl.production.impl;

import _ppl.production.entity.Council;
import _ppl.production.entity.CouncilEvaluation;
import _ppl.production.entity.RegistrationRound;
import _ppl.production.entity.CouncilMember;
import _ppl.production.entity.CouncilTopic;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.repository.CouncilEvaluationRepository;
import _ppl.production.repository.CouncilMemberRepository;
import _ppl.production.repository.CouncilTopicRepository;
import _ppl.production.service.CouncilEvaluationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CouncilEvaluationServiceImpl
        implements CouncilEvaluationService {

    private final CouncilEvaluationRepository evaluationRepository;
    private final CouncilTopicRepository councilTopicRepository;
    private final CouncilMemberRepository councilMemberRepository;
    private final AssignmentRepository assignmentRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CouncilEvaluation> findAll() {
        return evaluationRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<CouncilEvaluation> findById(Long id) {
        return evaluationRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CouncilEvaluation> findByCouncilTopicId(
            Long councilTopicId
    ) {
        return evaluationRepository
                .findByCouncilTopicId(councilTopicId);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<CouncilEvaluation> findByCouncilTopicAndMember(
            Long councilTopicId,
            Long councilMemberId
    ) {
        return evaluationRepository
                .findByCouncilTopicIdAndCouncilMemberId(
                        councilTopicId,
                        councilMemberId
                );
    }

    @Override
    public CouncilEvaluation evaluate(
            Long councilTopicId,
            Long councilMemberId,
            Double score,
            String comment
    ) {

        if (councilTopicId == null) {
            throw new RuntimeException(
                    "Không xác định được đề tài trong hội đồng"
            );
        }

        if (councilMemberId == null) {
            throw new RuntimeException(
                    "Không xác định được thành viên hội đồng"
            );
        }

        if (score == null) {
            throw new RuntimeException(
                    "Điểm không được để trống"
            );
        }

        if (score < 0 || score > 10) {
            throw new RuntimeException(
                    "Điểm phải nằm trong khoảng từ 0 đến 10"
            );
        }

        CouncilTopic councilTopic =
                councilTopicRepository.findById(councilTopicId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đề tài trong hội đồng"
                                )
                        );

        CouncilMember councilMember =
                councilMemberRepository.findById(councilMemberId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy thành viên hội đồng"
                                )
                        );

        Council council =
                councilTopic.getCouncil();

        if (council == null) {
            throw new RuntimeException(
                    "Đề tài chưa thuộc hội đồng"
            );
        }

        if (!"ACTIVE".equalsIgnoreCase(
                council.getStatus()
        )) {

            throw new RuntimeException(
                    "Chỉ được nhập điểm khi hội đồng đang hoạt động"
            );
        }

        if (councilMember.getCouncil() == null
                || councilMember.getCouncil().getId() == null
                || !councilMember.getCouncil().getId()
                .equals(council.getId())) {

            throw new RuntimeException(
                    "Giảng viên không được phân công chấm đề tài này"
            );
        }

        if (councilMember.getLecturer() == null
                || councilMember.getLecturer().getId() == null) {

            throw new RuntimeException(
                    "Thành viên hội đồng chưa liên kết với giảng viên"
            );
        }

        Long lecturerId =
                councilMember.getLecturer().getId();

        String role = councilMember.getRole();

        if (role == null || role.isBlank()) {
            throw new RuntimeException(
                    "Thành viên hội đồng chưa được phân công quyền"
            );
        }

        role = role.trim().toUpperCase();

        if (!"PRESIDENT".equals(role)
                && !"SECRETARY".equals(role)
                && !"MEMBER".equals(role)) {

            throw new RuntimeException(
                    "Quyền của thành viên hội đồng không hợp lệ"
            );
        }

        RegistrationRound round =
                councilTopic.getTopic().getRegistrationRound();
        boolean isGvpb = assignmentRepository
                .existsByTopicIdAndLecturerIdAndRole(
                        councilTopic.getTopic().getId(),
                        lecturerId,
                        "GVPB"
                );
        if (isGvpb && round != null &&
                ("TLCN".equalsIgnoreCase(round.getType()) ||
                        "KLTN".equalsIgnoreCase(round.getType()))) {
            if (round.getGvpbDeadlineAt() == null) {
                throw new RuntimeException(
                        "Đợt đăng ký chưa cấu hình hạn GVPB nộp điểm"
                );
            }
            if (LocalDateTime.now().isAfter(round.getGvpbDeadlineAt())) {
                throw new RuntimeException(
                        "Đã quá hạn GVPB nộp điểm"
                );
            }
        }

        boolean isSupervisor =
                assignmentRepository
                        .existsByTopicIdAndLecturerIdAndRole(
                                councilTopic.getTopic().getId(),
                                lecturerId,
                                "GVHD"
                        );

        if (isSupervisor) {

            throw new RuntimeException(
                    "Giảng viên hướng dẫn không được chấm đề tài mình hướng dẫn"
            );
        }

        if ("PUBLISHED".equalsIgnoreCase(
                councilTopic.getResultStatus()
        )) {

            throw new RuntimeException(
                    "Kết quả đã được công bố, không thể thay đổi điểm"
            );
        }

        Optional<CouncilEvaluation> existing =
                evaluationRepository
                        .findByCouncilTopicIdAndCouncilMemberId(
                                councilTopicId,
                                councilMemberId
                        );

        CouncilEvaluation evaluation;

        if (existing.isPresent()) {

            evaluation = existing.get();

            evaluation.setScore(score);

            evaluation.setComment(
                    comment == null
                            ? null
                            : comment.trim()
            );

        } else {

            evaluation =
                    CouncilEvaluation.builder()
                            .councilTopic(councilTopic)
                            .councilMember(councilMember)
                            .score(score)
                            .comment(
                                    comment == null
                                            ? null
                                            : comment.trim()
                            )
                            .build();
        }

        CouncilEvaluation saved =
                evaluationRepository.save(evaluation);

        if (isGradingComplete(councilTopicId)) {

            Double finalScore =
                    calculateFinalScore(councilTopicId);

            councilTopic.setFinalScore(finalScore);
            councilTopic.setResultStatus("READY");

            councilTopicRepository.save(councilTopic);
        }

        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public Double calculateFinalScore(
            Long councilTopicId
    ) {

        councilTopicRepository.findById(councilTopicId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài trong hội đồng"
                        )
                );

        List<CouncilEvaluation> evaluations =
                evaluationRepository
                        .findByCouncilTopicId(councilTopicId);

        if (evaluations.isEmpty()) {

            throw new RuntimeException(
                    "Đề tài chưa có đánh giá"
            );
        }

        double total = 0;

        for (CouncilEvaluation evaluation :
                evaluations) {

            if (evaluation.getScore() == null) {

                throw new RuntimeException(
                        "Có đánh giá chưa nhập điểm"
                );
            }

            total += evaluation.getScore();
        }

        double finalScore =
                total / evaluations.size();

        return Math.round(
                finalScore * 100.0
        ) / 100.0;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isGradingComplete(
            Long councilTopicId
    ) {

        CouncilTopic councilTopic =
                councilTopicRepository.findById(
                        councilTopicId
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài trong hội đồng"
                        )
                );

        Council council =
                councilTopic.getCouncil();

        if (council == null) {

            throw new RuntimeException(
                    "Đề tài chưa thuộc hội đồng"
            );
        }

        List<CouncilMember> members =
                councilMemberRepository
                        .findByCouncilId(council.getId());

        if (members.isEmpty()) {
            return false;
        }

        long evaluationCount =
                evaluationRepository
                        .countByCouncilTopicId(
                                councilTopicId
                        );

        return evaluationCount == members.size();
    }

    @Override
    public void prepareResult(
            Long councilTopicId
    ) {

        CouncilTopic councilTopic =
                councilTopicRepository.findById(
                        councilTopicId
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài trong hội đồng"
                        )
                );

        if (!"ACTIVE".equalsIgnoreCase(
                councilTopic.getCouncil().getStatus()
        )) {

            throw new RuntimeException(
                    "Hội đồng không ở trạng thái đang hoạt động"
            );
        }

        if ("PUBLISHED".equalsIgnoreCase(
                councilTopic.getResultStatus()
        )) {

            throw new RuntimeException(
                    "Kết quả đã được công bố"
            );
        }

        if (!isGradingComplete(councilTopicId)) {

            throw new RuntimeException(
                    "Chưa đủ đánh giá của tất cả thành viên hội đồng"
            );
        }

        Double finalScore =
                calculateFinalScore(councilTopicId);

        councilTopic.setFinalScore(finalScore);
        councilTopic.setResultStatus("READY");

        councilTopicRepository.save(councilTopic);
    }

    @Override
    public void publishResult(
            Long councilTopicId
    ) {

        CouncilTopic councilTopic =
                councilTopicRepository.findById(
                        councilTopicId
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài trong hội đồng"
                        )
                );

        if ("PUBLISHED".equalsIgnoreCase(
                councilTopic.getResultStatus()
        )) {

            throw new RuntimeException(
                    "Kết quả đã được công bố trước đó"
            );
        }

        if (!"READY".equalsIgnoreCase(
                councilTopic.getResultStatus()
        )) {

            throw new RuntimeException(
                    "Kết quả chưa sẵn sàng để công bố"
            );
        }

        if (!isGradingComplete(councilTopicId)) {

            throw new RuntimeException(
                    "Chưa hoàn tất phản biện và chấm điểm"
            );
        }

        Double finalScore =
                calculateFinalScore(councilTopicId);

        councilTopic.setFinalScore(finalScore);

        councilTopic.setResultStatus(
                "PUBLISHED"
        );

        councilTopic.setPublishedAt(
                LocalDateTime.now()
        );

        councilTopicRepository.save(councilTopic);
    }

    @Override
    public void deleteById(Long id) {

        CouncilEvaluation evaluation =
                evaluationRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đánh giá"
                                )
                        );

        CouncilTopic councilTopic =
                evaluation.getCouncilTopic();

        if ("PUBLISHED".equalsIgnoreCase(
                councilTopic.getResultStatus()
        )) {

            throw new RuntimeException(
                    "Kết quả đã được công bố, không thể xóa đánh giá"
            );
        }

        evaluationRepository.delete(evaluation);
    }
}