package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "topics")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Topic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Integer maxStudents;

    @Column(nullable = false, length = 30)
    private String status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private Lecturer createdBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "registration_round_id", nullable = false)
    private RegistrationRound registrationRound;

    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Registration> registrations = new ArrayList<>();

    @OneToMany(mappedBy = "topic", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Assignment> assignments = new ArrayList<>();

    @OneToMany(
            mappedBy = "topic",
            cascade = CascadeType.ALL
    )
    @Builder.Default
    private List<CouncilTopic> councilTopics =
            new ArrayList<>();
}