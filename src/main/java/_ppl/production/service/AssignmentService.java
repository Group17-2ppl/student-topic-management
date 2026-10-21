package _ppl.production.service;

import _ppl.production.entity.Assignment;

import java.util.List;
import java.util.Optional;

public interface AssignmentService {

    List<Assignment> findAll();

    List<Assignment> findByTopicId(Long topicId);

    List<Assignment> findByLecturerId(Long lecturerId);

    Optional<Assignment> findById(Long id);

    Assignment assign(
            Long topicId,
            Long lecturerId,
            String role
    );

    Assignment registerGuidance(
            Long topicId,
            Long lecturerId
    );

    void deleteById(Long id);
}