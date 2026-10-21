package _ppl.production.impl;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.Registration;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.service.LecturerSubmissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LecturerSubmissionServiceImpl
        implements LecturerSubmissionService {

    private final AssignmentRepository assignmentRepository;
    private final RegistrationRepository registrationRepository;

    @Override
    public List<Assignment> findAssignedTopics(Long lecturerId) {

        if (lecturerId == null) {
            throw new RuntimeException(
                    "Không xác định được giảng viên"
            );
        }

        return assignmentRepository
                .findByLecturerId(lecturerId);
    }

    @Override
    public List<Registration> findApprovedRegistrations(
            Long lecturerId,
            Long topicId
    ) {

        if (lecturerId == null) {
            throw new RuntimeException(
                    "Không xác định được giảng viên"
            );
        }

        if (topicId == null) {
            throw new RuntimeException(
                    "Không xác định được đề tài"
            );
        }

        /*
         * Kiểm tra giảng viên có được phân công
         * cho đề tài này hay không.
         */
        boolean assigned =
                assignmentRepository
                        .findByLecturerId(lecturerId)
                        .stream()
                        .anyMatch(assignment ->
                                assignment.getTopic() != null
                                        && assignment.getTopic()
                                        .getId()
                                        .equals(topicId)
                        );

        if (!assigned) {
            throw new RuntimeException(
                    "Bạn không được phân công cho đề tài này"
            );
        }

        List<Registration> registrations =
                registrationRepository
                        .findByTopicId(topicId);

        List<Registration> approved =
                new ArrayList<>();

        for (Registration registration :
                registrations) {

            if ("APPROVED".equalsIgnoreCase(
                    registration.getStatus()
            )) {
                approved.add(registration);
            }
        }

        return approved;
    }
}