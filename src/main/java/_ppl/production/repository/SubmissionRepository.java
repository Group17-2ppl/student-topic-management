package _ppl.production.repository;

import _ppl.production.entity.Submission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SubmissionRepository
        extends JpaRepository<Submission, Long> {

    Optional<Submission> findByRegistrationId(Long registrationId);

    boolean existsByRegistrationId(Long registrationId);
}