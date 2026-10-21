package _ppl.production.repository;

import _ppl.production.entity.Registration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RegistrationRepository
        extends JpaRepository<Registration, Long> {

    List<Registration> findByStatus(String status);

    List<Registration> findByGroupId(Long groupId);

    Optional<Registration> findTopByGroupIdOrderByRegisteredAtDesc(Long groupId);

    List<Registration> findByTopicId(Long topicId);

    boolean existsByGroupIdAndTopicId(
            Long groupId,
            Long topicId
    );

    boolean existsByGroupIdAndStatusIn(
            Long groupId,
            List<String> statuses
    );

    long countByTopicIdAndStatus(
            Long topicId,
            String status
    );
}