package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "registrations",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_group_topic",
                        columnNames = {"group_id", "topic_id"}
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Registration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "group_id",
            nullable = false
    )
    private StudentGroup group;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "topic_id",
            nullable = false
    )
    private Topic topic;

    @Column(nullable = false, length = 30)
    private String status;

    @Column(name = "registered_at")
    private LocalDateTime registeredAt;

    @PrePersist
    protected void onCreate() {
        registeredAt = LocalDateTime.now();
    }

    @OneToOne(
            mappedBy = "registration",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private Submission submission;
}