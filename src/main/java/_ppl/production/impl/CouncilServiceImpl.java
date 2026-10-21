package _ppl.production.impl;

import _ppl.production.entity.Council;
import _ppl.production.entity.CouncilMember;
import _ppl.production.entity.CouncilTopic;
import _ppl.production.entity.Lecturer;
import _ppl.production.entity.RegistrationRound;
import _ppl.production.entity.Topic;
import _ppl.production.repository.*;
import _ppl.production.service.CouncilService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CouncilServiceImpl implements CouncilService {

    private final CouncilRepository councilRepository;
    private final CouncilMemberRepository councilMemberRepository;
    private final CouncilTopicRepository councilTopicRepository;
    private final LecturerRepository lecturerRepository;
    private final RegistrationRoundRepository registrationRoundRepository;
    private final TopicRepository topicRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Council> findAll() {
        return councilRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Council> findById(Long id) {
        return councilRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Council> findByRegistrationRoundId(
            Long registrationRoundId
    ) {
        return councilRepository.findByRegistrationRoundId(
                registrationRoundId
        );
    }

    @Override
    @Transactional(readOnly = true)
    public List<Council> findByStatus(String status) {
        return councilRepository.findByStatus(status);
    }

    @Override
    public Council save(Council council) {

        if (council.getName() == null ||
                council.getName().isBlank()) {

            throw new RuntimeException(
                    "Tên hội đồng không được để trống"
            );
        }

        if (council.getRegistrationRound() == null ||
                council.getRegistrationRound().getId() == null) {

            throw new RuntimeException(
                    "Vui lòng chọn đợt đăng ký"
            );
        }

        RegistrationRound round =
                registrationRoundRepository.findById(
                        council.getRegistrationRound().getId()
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đợt đăng ký"
                        ));

        if (!"KLTN".equalsIgnoreCase(round.getType())) {
            throw new RuntimeException(
                    "Chỉ được tạo hội đồng cho đợt KLTN"
            );
        }

        if (council.getStatus() == null ||
                council.getStatus().isBlank()) {

            council.setStatus("DRAFT");
        }

        if (!"DRAFT".equalsIgnoreCase(council.getStatus())) {
            throw new RuntimeException(
                    "Hội đồng mới phải ở trạng thái DRAFT"
            );
        }

        council.setRegistrationRound(round);

        return councilRepository.save(council);
    }

    @Override
    public Council update(
            Long id,
            Council council
    ) {

        Council existing =
                councilRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                ));

        if (!"DRAFT".equalsIgnoreCase(existing.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được sửa hội đồng ở trạng thái DRAFT"
            );
        }

        if (council.getName() == null ||
                council.getName().isBlank()) {

            throw new RuntimeException(
                    "Tên hội đồng không được để trống"
            );
        }

        if (council.getRegistrationRound() == null ||
                council.getRegistrationRound().getId() == null) {

            throw new RuntimeException(
                    "Vui lòng chọn đợt đăng ký"
            );
        }

        RegistrationRound round =
                registrationRoundRepository.findById(
                        council.getRegistrationRound().getId()
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đợt đăng ký"
                        ));

        if (!"KLTN".equalsIgnoreCase(round.getType())) {
            throw new RuntimeException(
                    "Chỉ được tạo hội đồng cho đợt KLTN"
            );
        }

        existing.setName(council.getName());
        existing.setRegistrationRound(round);

        return councilRepository.save(existing);
    }

    @Override
    public void deleteById(Long id) {

        Council council =
                councilRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                ));

        if (!"DRAFT".equalsIgnoreCase(council.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được xóa hội đồng ở trạng thái DRAFT"
            );
        }

        councilRepository.delete(council);
    }

    @Override
    public void addMember(
            Long councilId,
            Long lecturerId,
            String role
    ) {

        Council council =
                councilRepository.findById(councilId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                ));

        Lecturer lecturer =
                lecturerRepository.findById(lecturerId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy giảng viên"
                                ));

        if (!"DRAFT".equalsIgnoreCase(council.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được thêm thành viên khi hội đồng ở trạng thái DRAFT"
            );
        }

        if (role == null || role.isBlank()) {
            throw new RuntimeException(
                    "Vai trò thành viên không được để trống"
            );
        }

        String normalizedRole =
                role.trim().toUpperCase();

        if (!"PRESIDENT".equals(normalizedRole) &&
                !"SECRETARY".equals(normalizedRole) &&
                !"MEMBER".equals(normalizedRole)) {

            throw new RuntimeException(
                    "Vai trò thành viên không hợp lệ"
            );
        }

        long memberCount =
                councilMemberRepository.countByCouncilId(
                        councilId
                );

        if (memberCount >= 5) {
            throw new RuntimeException(
                    "Hội đồng chỉ được tối đa 5 giảng viên"
            );
        }

        boolean lecturerExists =
                councilMemberRepository
                        .existsByCouncilIdAndLecturerId(
                                councilId,
                                lecturerId
                        );

        if (lecturerExists) {
            throw new RuntimeException(
                    "Giảng viên này đã có trong hội đồng"
            );
        }

        long roleCount =
                councilMemberRepository
                        .countByCouncilIdAndRole(
                                councilId,
                                normalizedRole
                        );

        if ("PRESIDENT".equals(normalizedRole) &&
                roleCount >= 1) {

            throw new RuntimeException(
                    "Hội đồng chỉ có một Chủ tịch"
            );
        }

        if ("SECRETARY".equals(normalizedRole) &&
                roleCount >= 1) {

            throw new RuntimeException(
                    "Hội đồng chỉ có một Thư ký"
            );
        }

        if ("MEMBER".equals(normalizedRole) &&
                roleCount >= 3) {

            throw new RuntimeException(
                    "Hội đồng chỉ được tối đa 3 thành viên"
            );
        }

        CouncilMember member =
                CouncilMember.builder()
                        .council(council)
                        .lecturer(lecturer)
                        .role(normalizedRole)
                        .build();

        councilMemberRepository.save(member);
    }

    @Override
    public void removeMember(Long memberId) {

        CouncilMember member =
                councilMemberRepository.findById(memberId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy thành viên hội đồng"
                                ));

        if (!"DRAFT".equalsIgnoreCase(
                member.getCouncil().getStatus())) {

            throw new RuntimeException(
                    "Chỉ được xóa thành viên khi hội đồng ở trạng thái DRAFT"
            );
        }

        councilMemberRepository.delete(member);
    }

    @Override
    public void assignTopic(
            Long councilId,
            Long topicId
    ) {

        Council council =
                councilRepository.findById(councilId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                ));

        Topic topic =
                topicRepository.findById(topicId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy đề tài"
                                ));

        if (!"DRAFT".equalsIgnoreCase(council.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được phân công đề tài khi hội đồng ở trạng thái DRAFT"
            );
        }

        if (!"OPEN".equalsIgnoreCase(topic.getStatus())) {
            throw new RuntimeException(
                    "Chỉ được đưa đề tài đã công bố vào hội đồng"
            );
        }

        Long councilRoundId =
                council.getRegistrationRound().getId();

        Long topicRoundId =
                topic.getRegistrationRound().getId();

        if (!councilRoundId.equals(topicRoundId)) {
            throw new RuntimeException(
                    "Đề tài không thuộc cùng đợt đăng ký với hội đồng"
            );
        }

        if (councilTopicRepository.existsByCouncilIdAndTopicId(
                councilId,
                topicId
        )) {

            throw new RuntimeException(
                    "Đề tài đã có trong hội đồng"
            );
        }

        if (councilTopicRepository.existsByTopicId(topicId)) {
            throw new RuntimeException(
                    "Đề tài này đã được phân vào một hội đồng khác"
            );
        }

        CouncilTopic councilTopic =
                CouncilTopic.builder()
                        .council(council)
                        .topic(topic)
                        .build();

        councilTopicRepository.save(councilTopic);
    }

    @Override
    public void removeTopic(Long councilTopicId) {

        CouncilTopic councilTopic =
                councilTopicRepository.findById(
                        councilTopicId
                ).orElseThrow(() ->
                        new RuntimeException(
                                "Không tìm thấy đề tài trong hội đồng"
                        ));

        if (!"DRAFT".equalsIgnoreCase(
                councilTopic.getCouncil().getStatus())) {

            throw new RuntimeException(
                    "Chỉ được xóa đề tài khi hội đồng ở trạng thái DRAFT"
            );
        }

        councilTopicRepository.delete(councilTopic);
    }

    @Override
    public Council activate(Long id) {

        Council council =
                councilRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                ));

        if (!"DRAFT".equalsIgnoreCase(council.getStatus())) {
            throw new RuntimeException(
                    "Chỉ có thể kích hoạt hội đồng từ trạng thái DRAFT"
            );
        }

        long memberCount =
                councilMemberRepository.countByCouncilId(id);

        long presidentCount =
                councilMemberRepository
                        .countByCouncilIdAndRole(
                                id,
                                "PRESIDENT"
                        );

        long secretaryCount =
                councilMemberRepository
                        .countByCouncilIdAndRole(
                                id,
                                "SECRETARY"
                        );

        List<CouncilTopic> topics =
                councilTopicRepository.findByCouncilId(id);

        if (memberCount < 3) {
            throw new RuntimeException(
                    "Hội đồng phải có ít nhất 3 giảng viên"
            );
        }

        if (memberCount > 5) {
            throw new RuntimeException(
                    "Hội đồng không được quá 5 giảng viên"
            );
        }

        if (presidentCount != 1) {
            throw new RuntimeException(
                    "Hội đồng phải có đúng 1 Chủ tịch"
            );
        }

        if (secretaryCount != 1) {
            throw new RuntimeException(
                    "Hội đồng phải có đúng 1 Thư ký"
            );
        }

        if (topics.isEmpty()) {
            throw new RuntimeException(
                    "Hội đồng phải có ít nhất 1 đề tài"
            );
        }

        council.setStatus("ACTIVE");

        return councilRepository.save(council);
    }

    @Override
    public Council complete(Long id) {

        Council council =
                councilRepository.findById(id)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy hội đồng"
                                )
                        );

        if (!"ACTIVE".equalsIgnoreCase(council.getStatus())) {

            throw new RuntimeException(
                    "Chỉ có thể hoàn thành hội đồng đang ACTIVE"
            );
        }

        List<CouncilTopic> topics =
                councilTopicRepository.findByCouncilId(id);

        if (topics.isEmpty()) {

            throw new RuntimeException(
                    "Hội đồng chưa có đề tài"
            );
        }

        for (CouncilTopic councilTopic : topics) {

            if (!"PUBLISHED".equalsIgnoreCase(
                    councilTopic.getResultStatus()
            )) {

                throw new RuntimeException(
                        "Chưa công bố kết quả cho đề tài: "
                                + councilTopic.getTopic().getTitle()
                );
            }
        }

        council.setStatus("COMPLETED");

        return councilRepository.save(council);
    }
}