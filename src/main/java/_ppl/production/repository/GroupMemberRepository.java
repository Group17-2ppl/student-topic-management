package _ppl.production.repository;

import _ppl.production.entity.GroupMember;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface GroupMemberRepository
        extends JpaRepository<GroupMember, Long> {

    List<GroupMember> findByGroupId(Long groupId);

    Optional<GroupMember> findByStudentId(Long studentId);

    Optional<GroupMember> findByGroupIdAndStudentId(
            Long groupId,
            Long studentId
    );

    boolean existsByStudentId(Long studentId);

    long countByGroupId(Long groupId);
}