package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
        name = "council_topics",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_council_topic",
                        columnNames = {"council_id", "topic_id"}
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CouncilTopic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "council_id", nullable = false)
    private Council council;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(name = "final_score")
    private Double finalScore;

    @Column(name = "result_status", nullable = false, length = 30)
    @Builder.Default
    private String resultStatus = "DRAFT";

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    @OneToMany(
            mappedBy = "councilTopic",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    @Builder.Default
    private List<CouncilEvaluation> evaluations = new ArrayList<>();
}