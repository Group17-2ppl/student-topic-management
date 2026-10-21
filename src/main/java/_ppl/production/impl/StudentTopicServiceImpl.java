package _ppl.production.impl;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.GroupMember;
import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;
import _ppl.production.repository.AssignmentRepository;
import _ppl.production.repository.GroupMemberRepository;
import _ppl.production.repository.RegistrationRepository;
import _ppl.production.service.StudentService;
import _ppl.production.service.StudentTopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StudentTopicServiceImpl
        implements StudentTopicService {

    private final StudentService studentService;
    private final GroupMemberRepository groupMemberRepository;
    private final RegistrationRepository registrationRepository;
    private final AssignmentRepository assignmentRepository;

    @Override
    public Optional<Student> findStudentByUsername(
            String username
    ) {

        if (username == null ||
                username.trim().isEmpty()) {

            return Optional.empty();
        }

        return studentService.findByUsername(username);
    }

    @Override
    public Optional<Registration> findMyRegistration(
            Long studentId
    ) {

        if (studentId == null) {
            return Optional.empty();
        }

        return groupMemberRepository
                .findByStudentId(studentId)
                .map(GroupMember::getGroup)
                .flatMap(group ->
                        registrationRepository
                                .findTopByGroupIdOrderByRegisteredAtDesc(group.getId())
                );
    }

    @Override
    public List<GroupMember> findGroupMembers(
            Long groupId
    ) {

        if (groupId == null) {
            return List.of();
        }

        return groupMemberRepository
                .findByGroupId(groupId);
    }

    @Override
    public List<Assignment> findSupervisors(
            Long topicId
    ) {

        if (topicId == null) {
            return List.of();
        }

        return assignmentRepository
                .findByTopicIdAndRole(
                        topicId,
                        "GVHD"
                );
    }
}