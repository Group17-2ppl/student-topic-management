package _ppl.production.service;

import _ppl.production.entity.Assignment;
import _ppl.production.entity.GroupMember;
import _ppl.production.entity.Registration;
import _ppl.production.entity.Student;

import java.util.List;
import java.util.Optional;

public interface StudentTopicService {

    Optional<Student> findStudentByUsername(String username);

    Optional<Registration> findMyRegistration(Long studentId);

    List<GroupMember> findGroupMembers(Long groupId);

    List<Assignment> findSupervisors(Long topicId);
}