package _ppl.production.repository;

import _ppl.production.entity.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AssignmentRepository extends JpaRepository<Assignment, Long> {

    List<Assignment> findByTopicId(Long topicId);

    List<Assignment> findByLecturerId(Long lecturerId);

    List<Assignment> findByTopicIdAndRole(
            Long topicId,
            String role
    );

    boolean existsByTopicIdAndLecturerIdAndRole(
            Long topicId,
            Long lecturerId,
            String role
    );

    long countByTopicIdAndRole(
            Long topicId,
            String role
    );

    long countByTopicId(
            Long topicId
    );
}