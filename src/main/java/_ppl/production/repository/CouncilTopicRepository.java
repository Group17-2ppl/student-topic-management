package _ppl.production.repository;

import _ppl.production.entity.CouncilTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CouncilTopicRepository
        extends JpaRepository<CouncilTopic, Long> {

    List<CouncilTopic> findByCouncilId(Long councilId);

    @Query("""
            select distinct ct
            from CouncilTopic ct
            join fetch ct.council c
            join fetch ct.topic t
            join CouncilMember cm on cm.council.id = c.id
            where cm.lecturer.id = :lecturerId
              and upper(c.status) = 'ACTIVE'
              and not exists (
                  select a.id
                  from Assignment a
                  where a.topic.id = t.id
                    and a.lecturer.id = :lecturerId
                    and upper(a.role) = 'GVHD'
              )
            order by ct.id desc
            """)
    List<CouncilTopic> findScorableByLecturerId(
            @Param("lecturerId") Long lecturerId
    );


    boolean existsByCouncilIdAndTopicId(
            Long councilId,
            Long topicId
    );

    boolean existsByTopicId(Long topicId);

    List<CouncilTopic> findByTopicId(Long topicId);

    Optional<CouncilTopic> findByTopicIdAndResultStatus(
            Long topicId,
            String resultStatus
    );
}