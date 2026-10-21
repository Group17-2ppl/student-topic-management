package _ppl.production.service;

import _ppl.production.entity.Topic;

import java.util.List;
import java.util.Optional;

public interface TopicService {

    List<Topic> findAll();

    List<Topic> findOpenTopics();

    List<Topic> findPending();

    List<Topic> findApproved();

    List<Topic> findByLecturerId(Long lecturerId);

    List<Topic> findByRegistrationRoundId(Long registrationRoundId);

    List<Topic> search(String keyword);

    Optional<Topic> findById(Long id);

    Topic create(
            Topic topic,
            Long lecturerId,
            Long registrationRoundId,
            Long departmentId
    );

    Topic update(
            Long id,
            Topic topic,
            Long lecturerId,
            Long departmentId
    );

    Topic approve(Long id);

    Topic reject(Long id);

    Topic publish(Long id);

    void deleteById(Long id);

    List<Topic> findTopicsWithApprovedRegistration();
}