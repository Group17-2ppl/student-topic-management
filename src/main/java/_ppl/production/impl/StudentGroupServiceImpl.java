package _ppl.production.impl;

import _ppl.production.entity.GroupMember;
import _ppl.production.entity.Student;
import _ppl.production.entity.StudentGroup;
import _ppl.production.repository.GroupMemberRepository;
import _ppl.production.repository.StudentGroupRepository;
import _ppl.production.repository.StudentRepository;
import _ppl.production.service.StudentGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class StudentGroupServiceImpl
        implements StudentGroupService {

    private final StudentGroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;
    private final StudentRepository studentRepository;

    @Override
    public StudentGroup createGroup(
            Long leaderStudentId,
            String groupName
    ) {

        if (leaderStudentId == null) {
            throw new RuntimeException(
                    "Không xác định được sinh viên"
            );
        }

        if (groupName == null || groupName.trim().isEmpty()) {
            throw new RuntimeException(
                    "Tên nhóm không được để trống"
            );
        }

        Student leader =
                studentRepository.findById(leaderStudentId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy sinh viên"
                                )
                        );

        if (groupMemberRepository
                .existsByStudentId(leaderStudentId)) {

            throw new RuntimeException(
                    "Sinh viên đã thuộc một nhóm khác"
            );
        }

        StudentGroup group =
                StudentGroup.builder()
                        .name(groupName.trim())
                        .leader(leader)
                        .build();

        StudentGroup saved =
                groupRepository.save(group);

        GroupMember leaderMember =
                GroupMember.builder()
                        .group(saved)
                        .student(leader)
                        .role("LEADER")
                        .build();

        groupMemberRepository.save(leaderMember);

        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<StudentGroup> findById(Long id) {

        return groupRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<StudentGroup> findByStudentId(
            Long studentId
    ) {

        return groupMemberRepository
                .findByStudentId(studentId)
                .map(GroupMember::getGroup);
    }

    @Override
    @Transactional(readOnly = true)
    public List<GroupMember> findMembers(
            Long groupId
    ) {

        return groupMemberRepository
                .findByGroupId(groupId);
    }

    @Override
    public GroupMember addMember(
            Long groupId,
            Long studentId
    ) {

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

        long memberCount =
                groupMemberRepository
                        .countByGroupId(groupId);

        if (memberCount >= 3) {

            throw new RuntimeException(
                    "Nhóm chỉ được tối đa 3 thành viên"
            );
        }

        // BR16
        if (groupMemberRepository
                .existsByStudentId(studentId)) {

            throw new RuntimeException(
                    "Sinh viên đã thuộc một nhóm"
            );
        }

        GroupMember member =
                GroupMember.builder()
                        .group(group)
                        .student(student)
                        .role("MEMBER")
                        .build();

        return groupMemberRepository.save(member);
    }

    @Override
    public void removeMember(
            Long groupId,
            Long studentId
    ) {

        StudentGroup group =
                groupRepository.findById(groupId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy nhóm"
                                )
                        );

        if (group.getLeader() == null
                || group.getLeader().getId() == null
                || group.getLeader().getId()
                .equals(studentId)) {

            throw new RuntimeException(
                    "Không thể xóa trưởng nhóm"
            );
        }

        GroupMember member =
                groupMemberRepository
                        .findByGroupIdAndStudentId(
                                groupId,
                                studentId
                        )
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Sinh viên không thuộc nhóm"
                                )
                        );

        groupMemberRepository.delete(member);
    }

    @Override
    public void deleteGroup(
            Long groupId,
            Long studentId
    ) {

        StudentGroup group =
                groupRepository.findById(groupId)
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "Không tìm thấy nhóm"
                                )
                        );

        if (group.getLeader() == null
                || !group.getLeader().getId()
                .equals(studentId)) {

            throw new RuntimeException(
                    "Chỉ trưởng nhóm mới được giải tán nhóm"
            );
        }

        groupRepository.delete(group);
    }
}