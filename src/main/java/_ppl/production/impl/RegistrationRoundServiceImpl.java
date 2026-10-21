package _ppl.production.impl;

import _ppl.production.entity.RegistrationRound;
import _ppl.production.entity.Topic;
import _ppl.production.repository.RegistrationRoundRepository;
import _ppl.production.repository.TopicRepository;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.service.RegistrationRoundService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class RegistrationRoundServiceImpl
        implements RegistrationRoundService {

    private final RegistrationRoundRepository registrationRoundRepository;
    private final TopicRepository topicRepository;
    private final AssignmentRepository assignmentRepository;

    @Override
    public List<RegistrationRound> findAll() {
        return registrationRoundRepository.findAll();
    }

    @Override
    public Optional<RegistrationRound> findById(Long id) {
        return registrationRoundRepository.findById(id);
    }

    @Override
    public List<RegistrationRound> findByStatus(String status) {
        return registrationRoundRepository.findByStatus(status);
    }

    @Override
    public RegistrationRound save(RegistrationRound round) {

        if (round.getStatus() == null ||
                round.getStatus().isBlank()) {

            round.setStatus("DRAFT");
        }

        validateRound(round);

        return registrationRoundRepository.save(round);
    }

    @Override
    public RegistrationRound update(
            Long id,
            RegistrationRound round
    ) {

        RegistrationRound existing =
                registrationRoundRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đợt đăng ký"
                                ));

        if (!"DRAFT".equalsIgnoreCase(existing.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được sửa đợt đăng ký ở trạng thái DRAFT"
            );
        }

        existing.setName(round.getName());
        existing.setType(round.getType());
        existing.setDescription(round.getDescription());

        existing.setTopicStartAt(round.getTopicStartAt());
        existing.setTopicEndAt(round.getTopicEndAt());

        existing.setRegistrationStartAt(
                round.getRegistrationStartAt()
        );

        existing.setRegistrationEndAt(
                round.getRegistrationEndAt()
        );

        existing.setGvpbDeadlineAt(
                round.getGvpbDeadlineAt()
        );

        existing.setCouncilDateAt(
                round.getCouncilDateAt()
        );

        validateRound(existing);

        return registrationRoundRepository.save(existing);
    }

    @Override
    public RegistrationRound openTopicSubmission(Long id) {

        RegistrationRound round = getRound(id);

        if (!"DRAFT".equalsIgnoreCase(round.getStatus())) {
            throw new RuntimeException(
                    "Chỉ có thể mở đợt từ trạng thái DRAFT"
            );
        }

        round.setStatus("TOPIC_SUBMISSION");

        return registrationRoundRepository.save(round);
    }

    @Override
    public RegistrationRound openTopicReview(Long id) {

        RegistrationRound round = getRound(id);

        if (!"TOPIC_SUBMISSION".equalsIgnoreCase(
                round.getStatus())) {

            throw new RuntimeException(
                    "Đợt đăng ký chưa ở giai đoạn nhận đề tài"
            );
        }

        round.setStatus("TOPIC_REVIEW");

        return registrationRoundRepository.save(round);
    }

    @Override
    public RegistrationRound publishTopics(Long id) {

        RegistrationRound round = getRound(id);

        if (!"TOPIC_REVIEW".equalsIgnoreCase(
                round.getStatus())) {

            throw new RuntimeException(
                    "Chỉ có thể công bố sau giai đoạn duyệt đề tài"
            );
        }

        List<Topic> approvedTopics =
                topicRepository
                        .findByRegistrationRoundIdAndStatus(
                                id,
                                "APPROVED"
                        );

        for (Topic topic : approvedTopics) {
            if (assignmentRepository.countByTopicIdAndRole(topic.getId(), "GVHD") < 1) {
                throw new RuntimeException(
                        "Đề tài \"" + topic.getTitle() + "\" chưa có giảng viên hướng dẫn"
                );
            }
            topic.setStatus("OPEN");
        }

        topicRepository.saveAll(approvedTopics);

        round.setStatus("STUDENT_REGISTRATION");

        return registrationRoundRepository.save(round);
    }

    @Override
    public RegistrationRound openStudentRegistration(Long id) {

        RegistrationRound round = getRound(id);

        if (!"TOPIC_REVIEW".equalsIgnoreCase(
                round.getStatus())) {

            throw new RuntimeException(
                    "Đợt đăng ký chưa ở giai đoạn duyệt đề tài"
            );
        }

        List<Topic> approvedTopics =
                topicRepository
                        .findByRegistrationRoundIdAndStatus(
                                id,
                                "APPROVED"
                        );

        for (Topic topic : approvedTopics) {
            if (assignmentRepository.countByTopicIdAndRole(topic.getId(), "GVHD") < 1) {
                throw new RuntimeException(
                        "Đề tài \"" + topic.getTitle() + "\" chưa có giảng viên hướng dẫn"
                );
            }
            topic.setStatus("OPEN");
        }

        topicRepository.saveAll(approvedTopics);

        round.setStatus("STUDENT_REGISTRATION");

        return registrationRoundRepository.save(round);
    }

    @Override
    public RegistrationRound close(Long id) {

        RegistrationRound round = getRound(id);

        if ("CLOSED".equalsIgnoreCase(
                round.getStatus())) {

            throw new RuntimeException(
                    "Đợt đăng ký đã đóng"
            );
        }

        round.setStatus("CLOSED");

        return registrationRoundRepository.save(round);
    }

    @Override
    public void deleteById(Long id) {
        RegistrationRound round = getRound(id);

        if (!"DRAFT".equalsIgnoreCase(round.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được xóa đợt đăng ký ở trạng thái DRAFT"
            );
        }

        registrationRoundRepository.delete(round);
    }

    private RegistrationRound getRound(Long id) {

        return registrationRoundRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đợt đăng ký"
                        ));
    }

    private void validateRound(RegistrationRound round) {

        if (round.getName() == null ||
                round.getName().isBlank()) {

            throw new RuntimeException(
                    "Tên đợt đăng ký không được để trống"
            );
        }

        if (round.getType() == null ||
                round.getType().isBlank()) {

            throw new RuntimeException(
                    "Vui lòng chọn loại đợt đăng ký"
            );
        }

        if (!isValidType(round.getType())) {

            throw new RuntimeException(
                    "Loại đợt đăng ký không hợp lệ"
            );
        }

        if (round.getTopicStartAt() == null ||
                round.getTopicEndAt() == null) {

            throw new RuntimeException(
                    "Vui lòng nhập thời gian nhận đề tài"
            );
        }

        if (round.getRegistrationStartAt() == null ||
                round.getRegistrationEndAt() == null) {

            throw new RuntimeException(
                    "Vui lòng nhập thời gian sinh viên đăng ký"
            );
        }

        if (!round.getTopicStartAt()
                .isBefore(round.getTopicEndAt())) {

            throw new RuntimeException(
                    "Thời gian nhận đề tài không hợp lệ"
            );
        }

        if (!round.getRegistrationStartAt()
                .isBefore(round.getRegistrationEndAt())) {

            throw new RuntimeException(
                    "Thời gian sinh viên đăng ký không hợp lệ"
            );
        }

        if (round.getTopicEndAt()
                .isAfter(round.getRegistrationStartAt())) {

            throw new RuntimeException(
                    "Thời gian nhận đề tài phải kết thúc trước hoặc bằng thời gian sinh viên đăng ký"
            );
        }

        validateSpecialDates(round);
    }

    private void validateSpecialDates(
            RegistrationRound round
    ) {

        String type = round.getType().toUpperCase();

        if ("TLCN".equals(type) ||
                "KLTN".equals(type)) {

            if (round.getGvpbDeadlineAt() == null) {
                throw new RuntimeException(
                        "TLCN/KLTN phải có hạn GVPB chấm"
                );
            }

            if (round.getGvpbDeadlineAt()
                    .isBefore(round.getRegistrationEndAt())) {

                throw new RuntimeException(
                        "Hạn GVPB chấm phải sau thời gian sinh viên đăng ký"
                );
            }

        } else {

            round.setGvpbDeadlineAt(null);
        }

        if ("KLTN".equals(type)) {

            if (round.getCouncilDateAt() == null) {
                throw new RuntimeException(
                        "KLTN phải có ngày hội đồng"
                );
            }

            if (round.getCouncilDateAt()
                    .isBefore(round.getRegistrationEndAt())) {

                throw new RuntimeException(
                        "Ngày hội đồng phải sau thời gian sinh viên đăng ký"
                );
            }

        } else {

            round.setCouncilDateAt(null);
        }
    }

    private boolean isValidType(String type) {

        return "MON_HOC".equalsIgnoreCase(type) ||
                "NCKH".equalsIgnoreCase(type) ||
                "TLCN".equalsIgnoreCase(type) ||
                "KLTN".equalsIgnoreCase(type);
    }
}