    package _ppl.production.entity;

    import jakarta.persistence.*;
    import lombok.*;

    import java.util.ArrayList;
    import java.util.List;

    @Entity
    @Table(name = "lecturers")
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public class Lecturer {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @OneToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "user_id", unique = true, nullable = false)
        private User user;

        @Column(nullable = false, unique = true, length = 50)
        private String lecturerCode;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "department_id")
        private Department department;

        @Column(length = 255)
        private String specialization;

        @OneToMany(mappedBy = "lecturer", cascade = CascadeType.ALL)
        @Builder.Default
        private List<Assignment> assignments = new ArrayList<>();

        @OneToMany(mappedBy = "createdBy")
        @Builder.Default
        private List<Topic> createdTopics = new ArrayList<>();

        @OneToMany(
                mappedBy = "lecturer",
                cascade = CascadeType.ALL
        )
        @Builder.Default
        private List<CouncilMember> councilMemberships =
                new ArrayList<>();
    }