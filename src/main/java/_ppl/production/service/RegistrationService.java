package _ppl.production.service;

import _ppl.production.entity.Registration;

import java.util.List;
import java.util.Optional;

public interface RegistrationService {

    List<Registration> findAll();

    List<Registration> findPending();

    List<Registration> findByGroupId(Long groupId);

    List<Registration> findByTopicId(Long topicId);

    Optional<Registration> findById(Long id);

    Registration register(
            Long groupId,
            Long studentId,
            Long topicId
    );

    Registration approve(Long id);

    Registration reject(Long id);

    void deleteById(
            Long id,
            Long studentId
    );
}