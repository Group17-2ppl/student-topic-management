package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "students")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(
            name = "user_id",
            nullable = false,
            unique = true
    )
    private User user;

    @Column(
            name = "student_code",
            nullable = false,
            unique = true,
            length = 20
    )
    private String studentCode;

    @Column(name = "class_name", length = 50)
    private String className;

    @Column(length = 100)
    private String major;

    @OneToMany(
            mappedBy = "student",
            cascade = CascadeType.ALL
    )
    @Builder.Default
    private List<GroupMember> groupMemberships =
            new ArrayList<>();
}