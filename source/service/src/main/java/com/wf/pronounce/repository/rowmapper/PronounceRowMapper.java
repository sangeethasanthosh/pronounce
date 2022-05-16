package com.wf.pronounce.repository.rowmapper;

import com.wf.pronounce.domain.Pronounce;
import io.r2dbc.spi.Row;
import java.time.ZonedDateTime;
import java.util.function.BiFunction;
import org.springframework.stereotype.Service;

/**
 * Converter between {@link Row} to {@link Pronounce}, with proper type conversions.
 */
@Service
public class PronounceRowMapper implements BiFunction<Row, String, Pronounce> {

    private final ColumnConverter converter;

    public PronounceRowMapper(ColumnConverter converter) {
        this.converter = converter;
    }

    /**
     * Take a {@link Row} and a column prefix, and extract all the fields.
     * @return the {@link Pronounce} stored in the database.
     */
    @Override
    public Pronounce apply(Row row, String prefix) {
        Pronounce entity = new Pronounce();
        entity.setId(converter.fromRow(row, prefix + "_id", Long.class));
        entity.setEmployeeId(converter.fromRow(row, prefix + "_employee_id", String.class));
        entity.setFirstName(converter.fromRow(row, prefix + "_first_name", String.class));
        entity.setLastName(converter.fromRow(row, prefix + "_last_name", String.class));
        entity.setPreferredName(converter.fromRow(row, prefix + "_preferred_name", String.class));
        entity.setPhonetics(converter.fromRow(row, prefix + "_phonetics", String.class));
        entity.setCountry(converter.fromRow(row, prefix + "_country", String.class));
        entity.setLanguage(converter.fromRow(row, prefix + "_language", String.class));
        entity.setPronoun(converter.fromRow(row, prefix + "_pronoun", String.class));
        entity.setPronunciationContentType(converter.fromRow(row, prefix + "_pronunciation_content_type", String.class));
        entity.setPronunciation(converter.fromRow(row, prefix + "_pronunciation", byte[].class));
        entity.setCreatedUser(converter.fromRow(row, prefix + "_created_user", String.class));
        entity.setCreatedDate(converter.fromRow(row, prefix + "_created_date", ZonedDateTime.class));
        entity.setUpdatedUser(converter.fromRow(row, prefix + "_updated_user", String.class));
        entity.setUpdatedDate(converter.fromRow(row, prefix + "_updated_date", ZonedDateTime.class));
        entity.setIsActive(converter.fromRow(row, prefix + "_is_active", Boolean.class));
        return entity;
    }
}
