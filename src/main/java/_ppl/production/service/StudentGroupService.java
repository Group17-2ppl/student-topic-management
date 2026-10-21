package _ppl.production.service;

import _ppl.production.entity.GroupMember;
import _ppl.production.entity.StudentGroup;

import java.util.List;
import java.util.Optional;

public interface StudentGroupService {

    StudentGroup createGroup(
            Long leaderStudentId,
            String groupName
    );

    Optional<StudentGroup> findById(Long id);

    Optional<StudentGroup> findByStudentId(
            Long studentId
    );

    List<GroupMember> findMembers(Long groupId);

    GroupMember addMember(
            Long groupId,
            Long studentId
    );

    void removeMember(
            Long groupId,
            Long studentId
    );

    void deleteGroup(
            Long groupId,
            Long studentId
    );
}