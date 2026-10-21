package _ppl.production.repository;

import _ppl.production.entity.CouncilEvaluation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CouncilEvaluationRepository
        extends JpaRepository<CouncilEvaluation, Long> {

    List<CouncilEvaluation> findByCouncilTopicId(Long councilTopicId);

    Optional<CouncilEvaluation> findByCouncilTopicIdAndCouncilMemberId(
            Long councilTopicId,
            Long councilMemberId
    );

    long countByCouncilTopicId(Long councilTopicId);

}