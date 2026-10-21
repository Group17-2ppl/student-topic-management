package _ppl.production.service;

import _ppl.production.entity.CouncilEvaluation;

import java.util.List;
import java.util.Optional;

public interface CouncilEvaluationService {

    List<CouncilEvaluation> findAll();

    Optional<CouncilEvaluation> findById(Long id);

    List<CouncilEvaluation> findByCouncilTopicId(Long councilTopicId);

    Optional<CouncilEvaluation> findByCouncilTopicAndMember(
            Long councilTopicId,
            Long councilMemberId
    );

    CouncilEvaluation evaluate(
            Long councilTopicId,
            Long councilMemberId,
            Double score,
            String comment
    );

    Double calculateFinalScore(Long councilTopicId);

    boolean isGradingComplete(Long councilTopicId);

    void prepareResult(Long councilTopicId);

    void publishResult(Long councilTopicId);

    void deleteById(Long id);
}