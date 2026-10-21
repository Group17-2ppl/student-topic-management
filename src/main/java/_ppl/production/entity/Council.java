package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "councils")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Council {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 255)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "registration_round_id", nullable = false)
    private RegistrationRound registrationRound;

    @Column(nullable = false, length = 30)
    private String status;

    @OneToMany(
            mappedBy = "council",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    @Builder.Default
    private List<CouncilMember> members = new ArrayList<>();

    @OneToMany(
            mappedBy = "council",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    @Builder.Default
    private List<CouncilTopic> topics = new ArrayList<>();
}