package _ppl.production.service;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.Registration;

import java.util.List;

public interface LecturerSubmissionService {

    List<Assignment> findAssignedTopics(Long lecturerId);

    List<Registration> findApprovedRegistrations(
            Long lecturerId,
            Long topicId
    );
}