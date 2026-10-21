package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "council_evaluations",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_council_topic_member",
                        columnNames = {"council_topic_id", "council_member_id"}
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CouncilEvaluation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "council_topic_id", nullable = false)
    private CouncilTopic councilTopic;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "council_member_id", nullable = false)
    private CouncilMember councilMember;

    @Column(nullable = false)
    private Double score;

    @Column(columnDefinition = "TEXT")
    private String comment;

    @Column(name = "evaluated_at", nullable = false)
    private LocalDateTime evaluatedAt;

    @PrePersist
    protected void onCreate() {
        evaluatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        evaluatedAt = LocalDateTime.now();
    }
}