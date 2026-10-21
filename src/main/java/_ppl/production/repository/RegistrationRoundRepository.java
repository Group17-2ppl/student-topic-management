package _ppl.production.repository;

import _ppl.production.entity.RegistrationRound;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RegistrationRoundRepository
        extends JpaRepository<RegistrationRound, Long> {

    List<RegistrationRound> findByStatus(String status);

    Optional<RegistrationRound> findByName(String name);

    boolean existsByName(String name);
}