package _ppl.production.service;

import _ppl.production.entity.CouncilTopic;
import _ppl.production.entity.Registration;

import java.util.List;
import java.util.Optional;

public interface StudentResultService {

    List<Registration> findStudentRegistrations(Long studentId);

    Optional<CouncilTopic> findPublishedResult(Long topicId);
}