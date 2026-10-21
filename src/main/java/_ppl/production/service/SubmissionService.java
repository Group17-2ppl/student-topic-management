package _ppl.production.service;

import _ppl.production.entity.Submission;

import java.util.Optional;

public interface SubmissionService {

    Optional<Submission> findByRegistrationId(Long registrationId);

    Submission submit(
            Long registrationId,
            Long studentId,
            String fileName,
            String filePath,
            String description
    );

    Submission update(
            Long registrationId,
            Long studentId,
            String fileName,
            String filePath,
            String description
    );
}