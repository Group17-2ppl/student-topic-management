package _ppl.production.repository;

import _ppl.production.entity.CouncilMember;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CouncilMemberRepository
        extends JpaRepository<CouncilMember, Long> {

    List<CouncilMember> findByCouncilId(
            Long councilId
    );

    long countByCouncilId(
            Long councilId
    );

    long countByCouncilIdAndRole(
            Long councilId,
            String role
    );

    boolean existsByCouncilIdAndLecturerId(
            Long councilId,
            Long lecturerId
    );

    List<CouncilMember> findByLecturerId(Long lecturerId);

    Optional<CouncilMember> findByCouncilIdAndLecturerId(
            Long councilId,
            Long lecturerId
    );
}