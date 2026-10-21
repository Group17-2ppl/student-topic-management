package _ppl.production.repository;

import _ppl.production.entity.StudentGroup;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentGroupRepository
        extends JpaRepository<StudentGroup, Long> {

}