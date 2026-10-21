package _ppl.production.impl;

import _ppl.production.entity.Lecturer;
import _ppl.production.entity.RegistrationRound;
import _ppl.production.entity.Topic;
import _ppl.production.repository.LecturerRepository;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.repository.RegistrationRoundRepository;
import _ppl.production.repository.TopicRepository;
import _ppl.production.service.TopicService;
import _ppl.production.entity.Department;
import _ppl.production.repository.DepartmentRepository;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.entity.Assignment;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class TopicServiceImpl implements TopicService {

    private final TopicRepository topicRepository;
    private final LecturerRepository lecturerRepository;
    private final RegistrationRoundRepository registrationRoundRepository;
    private final RegistrationRepository registrationRepository;
    private final DepartmentRepository departmentRepository;
    private final AssignmentRepository assignmentRepository;

    @Override
    public List<Topic> findAll() {
        return topicRepository.findAll();
    }

    @Override
    public List<Topic> findOpenTopics() {
        return topicRepository.findByStatus("OPEN");
    }

    @Override
    public List<Topic> findPending() {
        return topicRepository.findByStatus("PENDING");
    }

    @Override
    public List<Topic> findByLecturerId(Long lecturerId) {
        return topicRepository.findByCreatedById(lecturerId);
    }

    @Override
    public List<Topic> findByRegistrationRoundId(Long registrationRoundId) {
        return topicRepository.findByRegistrationRoundId(registrationRoundId);
    }

    @Override
    public List<Topic> search(String keyword) {

        if (keyword == null || keyword.isBlank()) {
            return findOpenTopics();
        }

        return topicRepository
                .findByTitleContainingIgnoreCase(keyword)
                .stream()
                .filter(topic ->
                        "OPEN".equalsIgnoreCase(topic.getStatus()))
                .toList();
    }

    @Override
    public Optional<Topic> findById(Long id) {
        return topicRepository.findById(id);
    }

    @Override
    public Topic create(
            Topic topic,
            Long lecturerId,
            Long registrationRoundId,
            Long departmentId
    ) {

        Lecturer lecturer = lecturerRepository
                .findById(lecturerId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy giảng viên"
                        ));

        RegistrationRound round = registrationRoundRepository
                .findById(registrationRoundId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đợt đăng ký"
                        ));

        Department department = departmentRepository
                .findById(departmentId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy khoa/bộ môn"
                        ));

        if (lecturer.getDepartment() == null) {
            throw new RuntimeException(
                    "Giảng viên chưa được phân vào khoa/bộ môn"
            );
        }

        if (!lecturer.getDepartment()
                .getId()
                .equals(department.getId())) {

            throw new RuntimeException(
                    "Giảng viên không được tạo đề tài thuộc khoa/bộ môn khác"
            );
        }

        LocalDateTime now = LocalDateTime.now();

        if (!"TOPIC_SUBMISSION".equalsIgnoreCase(
                round.getStatus())) {

            throw new RuntimeException(
                    "Hiện không trong thời gian giảng viên đăng ký đề tài"
            );
        }

        if (now.isBefore(round.getTopicStartAt()) ||
                now.isAfter(round.getTopicEndAt())) {

            throw new RuntimeException(
                    "Đã hết thời gian đăng ký đề tài"
            );
        }

        if (topic.getTitle() == null ||
                topic.getTitle().isBlank()) {

            throw new RuntimeException(
                    "Tên đề tài không được để trống"
            );
        }

        if (topic.getDescription() == null ||
                topic.getDescription().isBlank()) {

            throw new RuntimeException(
                    "Nội dung đề tài không được để trống"
            );
        }

        if (topic.getMaxStudents() == null ||
                topic.getMaxStudents() <= 0) {

            throw new RuntimeException(
                    "Số lượng sinh viên tối đa phải lớn hơn 0"
            );
        }

        topic.setCreatedBy(lecturer);
        topic.setRegistrationRound(round);
        topic.setDepartment(department);
        topic.setStatus("PENDING");

        Topic savedTopic = topicRepository.save(topic);

        Assignment supervisor = Assignment.builder()
                .topic(savedTopic)
                .lecturer(lecturer)
                .role("GVHD")
                .build();
        assignmentRepository.save(supervisor);

        return savedTopic;
    }

    @Override
    public Topic update(
            Long id,
            Topic topic,
            Long lecturerId,
            Long departmentId
    ) {

        Topic existing = topicRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        if (existing.getCreatedBy() == null ||
                !existing.getCreatedBy()
                        .getId()
                        .equals(lecturerId)) {

            throw new RuntimeException(
                    "Bạn không có quyền sửa đề tài này"
            );
        }

        if (!"PENDING".equalsIgnoreCase(
                existing.getStatus())) {

            throw new RuntimeException(
                    "Chỉ được sửa đề tài đang chờ duyệt"
            );
        }

        Lecturer lecturer = lecturerRepository
                .findById(lecturerId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy giảng viên"
                        ));

        Department department = departmentRepository
                .findById(departmentId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy khoa/bộ môn"
                        ));

        if (lecturer.getDepartment() == null ||
                !lecturer.getDepartment()
                        .getId()
                        .equals(department.getId())) {

            throw new RuntimeException(
                    "Giảng viên không được chọn khoa/bộ môn khác"
            );
        }

        if (topic.getTitle() == null ||
                topic.getTitle().isBlank()) {

            throw new RuntimeException(
                    "Tên đề tài không được để trống"
            );
        }

        if (topic.getDescription() == null ||
                topic.getDescription().isBlank()) {

            throw new RuntimeException(
                    "Nội dung đề tài không được để trống"
            );
        }

        if (topic.getMaxStudents() == null ||
                topic.getMaxStudents() <= 0) {

            throw new RuntimeException(
                    "Số lượng sinh viên tối đa phải lớn hơn 0"
            );
        }

        existing.setTitle(topic.getTitle());
        existing.setDescription(topic.getDescription());
        existing.setMaxStudents(topic.getMaxStudents());
        existing.setDepartment(department);

        return topicRepository.save(existing);
    }

    @Override
    public Topic approve(Long id) {

        Topic topic = topicRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        if (!"PENDING".equalsIgnoreCase(
                topic.getStatus())) {

            throw new RuntimeException(
                    "Chỉ có thể duyệt đề tài đang chờ duyệt"
            );
        }

        if (assignmentRepository.countByTopicIdAndRole(topic.getId(), "GVHD") < 1) {
            throw new RuntimeException(
                    "Đề tài phải có ít nhất một giảng viên hướng dẫn trước khi duyệt"
            );
        }

        topic.setStatus("APPROVED");

        return topicRepository.save(topic);
    }

    @Override
    public Topic reject(Long id) {

        Topic topic = topicRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        if (!"PENDING".equalsIgnoreCase(
                topic.getStatus())) {

            throw new RuntimeException(
                    "Chỉ có thể từ chối đề tài đang chờ duyệt"
            );
        }

        topic.setStatus("REJECTED");

        return topicRepository.save(topic);
    }

    @Override
    public Topic publish(Long id) {

        Topic topic = topicRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài"
                        ));

        if (!"APPROVED".equalsIgnoreCase(
                topic.getStatus())) {

            throw new RuntimeException(
                    "Chỉ có thể công bố đề tài đã được duyệt"
            );
        }

        if (assignmentRepository.countByTopicIdAndRole(topic.getId(), "GVHD") < 1) {
            throw new RuntimeException(
                    "Đề tài phải có ít nhất một giảng viên hướng dẫn trước khi công bố"
            );
        }

        topic.setStatus("OPEN");

        return topicRepository.save(topic);
    }

    @Override
    public void deleteById(Long id) {
        topicRepository.deleteById(id);
    }

    @Override
    public List<Topic> findApproved() {
        return topicRepository.findByStatus("APPROVED");
    }

    @Override
    public List<Topic> findTopicsWithApprovedRegistration() {

        return topicRepository
                .findByStatus("OPEN")
                .stream()
                .filter(topic ->
                        registrationRepository
                                .countByTopicIdAndStatus(
                                        topic.getId(),
                                        "APPROVED"
                                ) > 0
                )
                .peek(topic -> {
                    if (topic.getDepartment() != null) {
                        topic.getDepartment().getName();
                    }
                    if (topic.getCreatedBy() != null &&
                            topic.getCreatedBy().getUser() != null) {
                        topic.getCreatedBy().getUser().getFullName();
                    }
                    topic.getAssignments().size();
                })
                .toList();
    }
}