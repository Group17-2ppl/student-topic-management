package _ppl.production.impl;

import _ppl.production.entity.Registration;
import _ppl.production.entity.RegistrationRound;
import _ppl.production.entity.Student;
import _ppl.production.entity.StudentGroup;
import _ppl.production.entity.Topic;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.repository.StudentGroupRepository;
import _ppl.production.repository.StudentRepository;
import _ppl.production.repository.TopicRepository;
import _ppl.production.service.RegistrationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class RegistrationServiceImpl
        implements RegistrationService {

    private final RegistrationRepository registrationRepository;
    private final StudentRepository studentRepository;
    private final StudentGroupRepository groupRepository;
    private final TopicRepository topicRepository;

    @Override
    public List<Registration> findAll() {
        return registrationRepository.findAll();
    }

    @Override
    public List<Registration> findPending() {
        return registrationRepository.findByStatus("PENDING");
    }

    @Override
    public List<Registration> findByGroupId(
            Long groupId
    ) {
        return registrationRepository
                .findByGroupId(groupId);
    }

    @Override
    public List<Registration> findByTopicId(
            Long topicId
    ) {
        return registrationRepository
                .findByTopicId(topicId);
    }

    @Override
    public Optional<Registration> findById(
            Long id
    ) {
        return registrationRepository.findById(id);
    }

    @Override
    public Registration register(
            Long groupId,
            Long studentId,
            Long topicId
    ) {

        if (groupId == null) {
            throw new RuntimeException(
                    "Không xác định được nhóm"
            );
        }

        if (studentId == null) {
            throw new RuntimeException(
                    "Không xác định được sinh viên"
            );
        }

        if (topicId == null) {
            throw new RuntimeException(
                    "Không xác định được đề tài"
            );
        }

        StudentGroup group =
                groupRepository.findById(groupId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy nhóm"
                                )
                        );

        Student student =
                studentRepository.findById(studentId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy sinh viên"
                                )
                        );

        if (group.getLeader() == null ||
                !group.getLeader()
                        .getId()
                        .equals(student.getId())) {

            throw new RuntimeException(
                    "Chỉ trưởng nhóm mới được đăng ký đề tài"
            );
        }

        Topic topic =
                topicRepository.findById(topicId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đề tài"
                                )
                        );

        if (!"OPEN".equalsIgnoreCase(
                topic.getStatus()
        )) {

            throw new RuntimeException(
                    "Đề tài hiện không mở đăng ký"
            );
        }

        RegistrationRound round =
                topic.getRegistrationRound();

        if (round == null) {

            throw new RuntimeException(
                    "Đề tài chưa thuộc đợt đăng ký"
            );
        }


        if (!"STUDENT_REGISTRATION"
                .equalsIgnoreCase(
                        round.getStatus()
                )) {

            throw new RuntimeException(
                    "Hiện không trong giai đoạn sinh viên đăng ký"
            );
        }

        LocalDateTime now =
                LocalDateTime.now();

        if (round.getRegistrationStartAt() == null ||
                round.getRegistrationEndAt() == null) {

            throw new RuntimeException(
                    "Đợt đăng ký chưa cấu hình thời gian"
            );
        }

        if (now.isBefore(
                round.getRegistrationStartAt()
        ) ||
                now.isAfter(
                        round.getRegistrationEndAt()
                )) {

            throw new RuntimeException(
                    "Đã hết thời gian đăng ký đề tài"
            );
        }

        boolean hasActiveRegistration =
                registrationRepository
                        .existsByGroupIdAndStatusIn(
                                groupId,
                                List.of(
                                        "PENDING",
                                        "APPROVED"
                                )
                        );

        if (hasActiveRegistration) {

            throw new RuntimeException(
                    "Nhóm đã đăng ký một đề tài"
            );
        }

        boolean exists =
                registrationRepository
                        .existsByGroupIdAndTopicId(
                                groupId,
                                topicId
                        );

        if (exists) {

            throw new RuntimeException(
                    "Nhóm đã đăng ký đề tài này"
            );
        }

        long currentGroups =
                registrationRepository
                        .countByTopicIdAndStatus(
                                topicId,
                                "APPROVED"
                        );

        if (topic.getMaxStudents() != null &&
                currentGroups >=
                        topic.getMaxStudents()) {

            throw new RuntimeException(
                    "Đề tài đã đủ số lượng nhóm"
            );
        }

        Registration registration =
                Registration.builder()
                        .group(group)
                        .topic(topic)
                        .status("PENDING")
                        .build();

        return registrationRepository
                .save(registration);
    }

    @Override
    public Registration approve(
            Long id
    ) {

        Registration registration =
                registrationRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy yêu cầu đăng ký"
                                )
                        );


        if (!"PENDING".equalsIgnoreCase(
                registration.getStatus()
        )) {

            throw new RuntimeException(
                    "Yêu cầu này đã được xử lý"
            );
        }


        Topic topic =
                registration.getTopic();

        long currentGroups =
                registrationRepository
                        .countByTopicIdAndStatus(
                                topic.getId(),
                                "APPROVED"
                        );

        if (topic.getMaxStudents() != null &&
                currentGroups >=
                        topic.getMaxStudents()) {

            throw new RuntimeException(
                    "Đề tài đã đủ số lượng nhóm"
            );
        }


        registration.setStatus("APPROVED");

        return registrationRepository
                .save(registration);
    }

    @Override
    public Registration reject(
            Long id
    ) {

        Registration registration =
                registrationRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy yêu cầu đăng ký"
                                )
                        );


        if (!"PENDING".equalsIgnoreCase(
                registration.getStatus()
        )) {

            throw new RuntimeException(
                    "Yêu cầu này đã được xử lý"
            );
        }


        registration.setStatus("REJECTED");

        return registrationRepository
                .save(registration);
    }

    @Override
    public void deleteById(
            Long id,
            Long studentId
    ) {

        Registration registration =
                registrationRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đăng ký"
                                )
                        );


        StudentGroup group =
                registration.getGroup();


        if (group.getLeader() == null ||
                !group.getLeader()
                        .getId()
                        .equals(studentId)) {

            throw new RuntimeException(
                    "Chỉ trưởng nhóm mới có quyền xóa đăng ký"
            );
        }


        if (!"PENDING".equalsIgnoreCase(
                registration.getStatus()
        )) {

            throw new RuntimeException(
                    "Chỉ được xóa đăng ký đang chờ duyệt"
            );
        }


        registrationRepository
                .delete(registration);
    }
}