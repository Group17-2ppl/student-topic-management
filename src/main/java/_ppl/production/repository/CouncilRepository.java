package _ppl.production.repository;

import _ppl.production.entity.Council;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CouncilRepository
        extends JpaRepository<Council, Long> {

    List<Council> findByRegistrationRoundId(
            Long registrationRoundId
    );

    List<Council> findByStatus(String status);
}