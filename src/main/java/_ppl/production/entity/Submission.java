package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(
        name = "submissions",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_submission_registration",
                        columnNames = {"registration_id"}
                )
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Submission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "registration_id",
            nullable = false,
            unique = true
    )
    private Registration registration;

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "submitted_at", nullable = false)
    private LocalDateTime submittedAt;

    @Column(nullable = false, length = 30)
    @Builder.Default
    private String status = "SUBMITTED";

    @PrePersist
    protected void onCreate() {
        submittedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        submittedAt = LocalDateTime.now();
    }
}