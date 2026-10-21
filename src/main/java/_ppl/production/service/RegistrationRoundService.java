package _ppl.production.service;

import _ppl.production.entity.RegistrationRound;

import java.util.List;
import java.util.Optional;

public interface RegistrationRoundService {

    List<RegistrationRound> findAll();

    Optional<RegistrationRound> findById(Long id);

    List<RegistrationRound> findByStatus(String status);

    RegistrationRound save(RegistrationRound round);

    RegistrationRound update(
            Long id,
            RegistrationRound round
    );

    RegistrationRound openTopicSubmission(Long id);

    RegistrationRound openTopicReview(Long id);

    RegistrationRound publishTopics(Long id);

    RegistrationRound openStudentRegistration(Long id);

    RegistrationRound close(Long id);

    void deleteById(Long id);
}