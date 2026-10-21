package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "registration_rounds")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationRound {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, length = 30)
    private String type;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private LocalDateTime topicStartAt;

    @Column(nullable = false)
    private LocalDateTime topicEndAt;

    @Column(nullable = false)
    private LocalDateTime registrationStartAt;

    @Column(nullable = false)
    private LocalDateTime registrationEndAt;

    @Column
    private LocalDateTime gvpbDeadlineAt;

    @Column
    private LocalDateTime councilDateAt;

    @Column(nullable = false, length = 30)
    private String status;

    @OneToMany(mappedBy = "registrationRound")
    @Builder.Default
    private List<Topic> topics = new ArrayList<>();

    @OneToMany(mappedBy = "registrationRound")
    @Builder.Default
    private List<Council> councils = new ArrayList<>();
}