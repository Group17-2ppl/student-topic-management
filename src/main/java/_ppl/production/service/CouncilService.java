package _ppl.production.service;

import _ppl.production.entity.Council;

import java.util.List;
import java.util.Optional;

public interface CouncilService {

    List<Council> findAll();

    Optional<Council> findById(Long id);

    List<Council> findByRegistrationRoundId(Long registrationRoundId);

    List<Council> findByStatus(String status);

    Council save(Council council);

    Council update(Long id, Council council);

    void deleteById(Long id);

    Council activate(Long id);

    Council complete(Long id);

    void addMember(
            Long councilId,
            Long lecturerId,
            String role
    );

    void removeMember(Long memberId);

    void assignTopic(
            Long councilId,
            Long topicId
    );

    void removeTopic(Long councilTopicId);
}