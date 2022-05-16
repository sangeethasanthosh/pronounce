package com.wf.pronounce.service;

import com.wf.pronounce.domain.Pronounce;
import com.wf.pronounce.repository.PronounceRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

/**
 * Service Implementation for managing {@link Pronounce}.
 */
@Service
@Transactional
public class PronounceService {

    private final Logger log = LoggerFactory.getLogger(PronounceService.class);

    private final PronounceRepository pronounceRepository;

    public PronounceService(PronounceRepository pronounceRepository) {
        this.pronounceRepository = pronounceRepository;
    }

    /**
     * Save a pronounce.
     *
     * @param pronounce the entity to save.
     * @return the persisted entity.
     */
    public Mono<Pronounce> save(Pronounce pronounce) {
        log.debug("Request to save Pronounce : {}", pronounce);



        return pronounceRepository.save(pronounce);
    }

    /**
     * Update a pronounce.
     *
     * @param pronounce the entity to save.
     * @return the persisted entity.
     */
    public Mono<Pronounce> update(Pronounce pronounce) {
        log.debug("Request to save Pronounce : {}", pronounce);
        return pronounceRepository.save(pronounce);
    }

    /**
     * Partially update a pronounce.
     *
     * @param pronounce the entity to update partially.
     * @return the persisted entity.
     */
    public Mono<Pronounce> partialUpdate(Pronounce pronounce) {
        log.debug("Request to partially update Pronounce : {}", pronounce);

        return pronounceRepository
            .findById(pronounce.getId())
            .map(existingPronounce -> {
                if (pronounce.getEmployeeId() != null) {
                    existingPronounce.setEmployeeId(pronounce.getEmployeeId());
                }
                if (pronounce.getFirstName() != null) {
                    existingPronounce.setFirstName(pronounce.getFirstName());
                }
                if (pronounce.getLastName() != null) {
                    existingPronounce.setLastName(pronounce.getLastName());
                }
                if (pronounce.getPreferredName() != null) {
                    existingPronounce.setPreferredName(pronounce.getPreferredName());
                }
                if (pronounce.getPhonetics() != null) {
                    existingPronounce.setPhonetics(pronounce.getPhonetics());
                }
                if (pronounce.getCountry() != null) {
                    existingPronounce.setCountry(pronounce.getCountry());
                }
                if (pronounce.getLanguage() != null) {
                    existingPronounce.setLanguage(pronounce.getLanguage());
                }
                if (pronounce.getPronoun() != null) {
                    existingPronounce.setPronoun(pronounce.getPronoun());
                }
                if (pronounce.getPronunciation() != null) {
                    existingPronounce.setPronunciation(pronounce.getPronunciation());
                }
                if (pronounce.getPronunciationContentType() != null) {
                    existingPronounce.setPronunciationContentType(pronounce.getPronunciationContentType());
                }
                if (pronounce.getCreatedUser() != null) {
                    existingPronounce.setCreatedUser(pronounce.getCreatedUser());
                }
                if (pronounce.getCreatedDate() != null) {
                    existingPronounce.setCreatedDate(pronounce.getCreatedDate());
                }
                if (pronounce.getUpdatedUser() != null) {
                    existingPronounce.setUpdatedUser(pronounce.getUpdatedUser());
                }
                if (pronounce.getUpdatedDate() != null) {
                    existingPronounce.setUpdatedDate(pronounce.getUpdatedDate());
                }
                if (pronounce.getIsActive() != null) {
                    existingPronounce.setIsActive(pronounce.getIsActive());
                }

                return existingPronounce;
            })
            .flatMap(pronounceRepository::save);
    }

    /**
     * Get all the pronounces.
     *
     * @param pageable the pagination information.
     * @return the list of entities.
     */
    @Transactional(readOnly = true)
    public Flux<Pronounce> findAll(Pageable pageable) {
        log.debug("Request to get all Pronounces");
        return pronounceRepository.findAllBy(pageable);
    }

    /**
     * Returns the number of pronounces available.
     * @return the number of entities in the database.
     *
     */
    public Mono<Long> countAll() {
        return pronounceRepository.count();
    }

    /**
     * Get one pronounce by id.
     *
     * @param id the id of the entity.
     * @return the entity.
     */
    @Transactional(readOnly = true)
    public Mono<Pronounce> findOne(Long id) {
        log.debug("Request to get Pronounce : {}", id);
        return pronounceRepository.findById(id);
    }

    /**
     * Delete the pronounce by id.
     *
     * @param id the id of the entity.
     * @return a Mono to signal the deletion
     */
    public Mono<Void> delete(Long id) {
        log.debug("Request to delete Pronounce : {}", id);
        return pronounceRepository.deleteById(id);
    }
}
