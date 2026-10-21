package _ppl.production.impl;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.Lecturer;
import _ppl.production.entity.Topic;
import _ppl.production.entity.RegistrationRound;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.repository.TopicRepository;
import _ppl.production.service.AssignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class AssignmentServiceImpl
        implements AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final TopicRepository topicRepository;
    private final LecturerRepository lecturerRepository;
    private final RegistrationRepository registrationRepository;

    @Override
    public List<Assignment> findAll() {
        return assignmentRepository.findAll();
    }

    @Override
    public List<Assignment> findByTopicId(Long topicId) {
        return assignmentRepository.findByTopicId(topicId);
    }

    @Override
    public List<Assignment> findByLecturerId(Long lecturerId) {
        return assignmentRepository.findByLecturerId(lecturerId);
    }

    @Override
    public Optional<Assignment> findById(Long id) {
        return assignmentRepository.findById(id);
    }

    @Override
    public Assignment assign(
            Long topicId,
            Long lecturerId,
            String role
    ) {

        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        Lecturer lecturer = lecturerRepository.findById(lecturerId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy giảng viên"
                        ));

        if (role == null || role.isBlank()) {
            throw new RuntimeException(
                    "Vai trò phân công không được để trống"
            );
        }

        String normalizedRole =
                role.trim().toUpperCase();

        if (!"GVHD".equals(normalizedRole) &&
                !"GVPB".equals(normalizedRole)) {

            throw new RuntimeException(
                    "Vai trò phân công không hợp lệ"
            );
        }

        if (!"OPEN".equalsIgnoreCase(topic.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được phân công cho đề tài đã công bố"
            );
        }

        long approvedRegistrations =
                registrationRepository
                        .countByTopicIdAndStatus(
                                topicId,
                                "APPROVED"
                        );

        if (approvedRegistrations <= 0) {
            throw new RuntimeException(
                    "Đề tài chưa có sinh viên được duyệt đăng ký"
            );
        }

        boolean lecturerAlreadyAssigned =
                assignmentRepository
                        .existsByTopicIdAndLecturerIdAndRole(
                                topicId,
                                lecturerId,
                                normalizedRole
                        );

        if (lecturerAlreadyAssigned) {
            throw new RuntimeException(
                    "Giảng viên này đã được phân công với vai trò "
                            + normalizedRole
                            + " cho đề tài"
            );
        }

        String oppositeRole =
                "GVHD".equals(normalizedRole)
                        ? "GVPB"
                        : "GVHD";

        boolean lecturerHasOppositeRole =
                assignmentRepository
                        .existsByTopicIdAndLecturerIdAndRole(
                                topicId,
                                lecturerId,
                                oppositeRole
                        );

        if (lecturerHasOppositeRole) {
            throw new RuntimeException(
                    "Giảng viên này đã được phân công với vai trò "
                            + oppositeRole
                            + " cho đề tài, không thể đồng thời làm "
                            + normalizedRole
            );
        }

        long roleCount =
                assignmentRepository.countByTopicIdAndRole(
                        topicId,
                        normalizedRole
                );

        if ("GVHD".equals(normalizedRole)) {

            if (roleCount >= 2) {
                throw new RuntimeException(
                        "Đề tài đã đủ tối đa 2 giảng viên hướng dẫn"
                );
            }
        }

        else if ("GVPB".equals(normalizedRole)) {

            if (roleCount >= 3) {
                throw new RuntimeException(
                        "Đề tài đã đủ tối đa 3 giảng viên phản biện"
                );
            }
        }

        long totalAssignments =
                assignmentRepository.countByTopicId(topicId);

        if (totalAssignments >= 5) {
            throw new RuntimeException(
                    "Đề tài đã đủ tối đa 5 giảng viên "
                            + "(2 GVHD và 3 GVPB)"
            );
        }

        Assignment assignment =
                Assignment.builder()
                        .topic(topic)
                        .lecturer(lecturer)
                        .role(normalizedRole)
                        .build();

        return assignmentRepository.save(assignment);
    }

    @Override
    public Assignment registerGuidance(
            Long topicId,
            Long lecturerId
    ) {

        Topic topic = topicRepository.findById(topicId)
                .orElseThrow(() ->
                        new RuntimeException("Không tìm thấy đề tài")
                );

        if (!"OPEN".equalsIgnoreCase(topic.getStatus())) {
            throw new RuntimeException(
                    "Chỉ có thể đăng ký hướng dẫn cho đề tài đã công bố"
            );
        }

        long approvedRegistrations =
                registrationRepository.countByTopicIdAndStatus(
                        topicId, "APPROVED"
                );

        if (approvedRegistrations <= 0) {
            throw new RuntimeException(
                    "Đề tài chưa có sinh viên được duyệt đăng ký"
            );
        }

        RegistrationRound round = topic.getRegistrationRound();
        if (round == null) {
            throw new RuntimeException("Đề tài chưa thuộc đợt đăng ký");
        }

        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (round.getRegistrationStartAt() == null ||
                round.getRegistrationEndAt() == null ||
                now.isBefore(round.getRegistrationStartAt()) ||
                now.isAfter(round.getRegistrationEndAt())) {
            throw new RuntimeException(
                    "Hiện không trong thời gian đăng ký hướng dẫn"
            );
        }

        return assign(topicId, lecturerId, "GVHD");
    }

    @Override
    public void deleteById(Long id) {

        if (!assignmentRepository.existsById(id)) {
            throw new RuntimeException(
                    "Không tìm thấy phân công"
            );
        }

        assignmentRepository.deleteById(id);
    }
}