package _ppl.production.impl;

import _ppl.production.entity.CouncilTopic;
import _ppl.production.entity.Registration;
import _ppl.production.repository.CouncilTopicRepository;
import _ppl.production.repository.GroupMemberRepository;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.service.StudentResultService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StudentResultServiceImpl
        implements StudentResultService {

    private final RegistrationRepository registrationRepository;
    private final GroupMemberRepository groupMemberRepository;
    private final CouncilTopicRepository councilTopicRepository;

    @Override
    public List<Registration> findStudentRegistrations(
            Long studentId
    ) {

        if (studentId == null) {
            throw new RuntimeException(
                    "Không xác định được sinh viên"
            );
        }

        return groupMemberRepository
                .findByStudentId(studentId)
                .map(member ->
                        registrationRepository
                                .findByGroupId(
                                        member.getGroup().getId()
                                )
                )
                .orElse(List.of());
    }

    @Override
    public Optional<CouncilTopic> findPublishedResult(
            Long topicId
    ) {

        if (topicId == null) {
            return Optional.empty();
        }

        return councilTopicRepository
                .findByTopicIdAndResultStatus(
                        topicId,
                        "PUBLISHED"
                );
    }
}