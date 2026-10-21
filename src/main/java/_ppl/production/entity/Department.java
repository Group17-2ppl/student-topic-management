package _ppl.production.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "departments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String name;

    @Column(unique = true, length = 20)
    private String code;

    @Column(length = 255)
    private String description;

    @OneToMany(mappedBy = "department")
    @Builder.Default
    private List<Lecturer> lecturers = new ArrayList<>();

    @OneToMany(mappedBy = "department")
    @Builder.Default
    private List<Topic> topics = new ArrayList<>();
}