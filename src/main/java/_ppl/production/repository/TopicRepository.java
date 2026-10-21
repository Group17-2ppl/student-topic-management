package _ppl.production.repository;

import _ppl.production.entity.Topic;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TopicRepository extends JpaRepository<Topic, Long> {

    List<Topic> findByStatus(String status);

    List<Topic> findByTitleContainingIgnoreCase(String title);

    List<Topic> findByCreatedById(Long lecturerId);

    List<Topic> findByRegistrationRoundId(Long registrationRoundId);

    List<Topic> findByRegistrationRoundIdAndStatus(
            Long registrationRoundId,
            String status
    );
}