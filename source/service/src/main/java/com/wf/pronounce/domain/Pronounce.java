package com.wf.pronounce.domain;

import java.io.Serializable;
import java.time.ZonedDateTime;
import javax.validation.constraints.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

/**
 * A Pronounce.
 */
@Table("pronounce")
public class Pronounce implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column("id")
    private Long id;

    @NotNull(message = "must not be null")
    @Column("employee_id")
    private String employeeId;

    @Column("first_name")
    private String firstName;

    @Column("last_name")
    private String lastName;

    @Column("preferred_name")
    private String preferredName;

    @Column("phonetics")
    private String phonetics;

    @Column("country")
    private String country;

    @Column("language")
    private String language;

    @Column("pronoun")
    private String pronoun;

    @Column("pronunciation")
    private byte[] pronunciation;

    @Column("pronunciation_content_type")
    private String pronunciationContentType;

    @Column("created_user")
    private String createdUser;

    @Column("created_date")
    private ZonedDateTime createdDate;

    @Column("updated_user")
    private String updatedUser;

    @Column("updated_date")
    private ZonedDateTime updatedDate;

    @Column("is_active")
    private Boolean isActive;

    // jhipster-needle-entity-add-field - JHipster will add fields here

    public Long getId() {
        return this.id;
    }

    public Pronounce id(Long id) {
        this.setId(id);
        return this;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmployeeId() {
        return this.employeeId;
    }

    public Pronounce employeeId(String employeeId) {
        this.setEmployeeId(employeeId);
        return this;
    }

    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    public String getFirstName() {
        return this.firstName;
    }

    public Pronounce firstName(String firstName) {
        this.setFirstName(firstName);
        return this;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    public Pronounce lastName(String lastName) {
        this.setLastName(lastName);
        return this;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPreferredName() {
        return this.preferredName;
    }

    public Pronounce preferredName(String preferredName) {
        this.setPreferredName(preferredName);
        return this;
    }

    public void setPreferredName(String preferredName) {
        this.preferredName = preferredName;
    }

    public String getPhonetics() {
        return this.phonetics;
    }

    public Pronounce phonetics(String phonetics) {
        this.setPhonetics(phonetics);
        return this;
    }

    public void setPhonetics(String phonetics) {
        this.phonetics = phonetics;
    }

    public String getCountry() {
        return this.country;
    }

    public Pronounce country(String country) {
        this.setCountry(country);
        return this;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getLanguage() {
        return this.language;
    }

    public Pronounce language(String language) {
        this.setLanguage(language);
        return this;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getPronoun() {
        return this.pronoun;
    }

    public Pronounce pronoun(String pronoun) {
        this.setPronoun(pronoun);
        return this;
    }

    public void setPronoun(String pronoun) {
        this.pronoun = pronoun;
    }

    public byte[] getPronunciation() {
        return this.pronunciation;
    }

    public Pronounce pronunciation(byte[] pronunciation) {
        this.setPronunciation(pronunciation);
        return this;
    }

    public void setPronunciation(byte[] pronunciation) {
        this.pronunciation = pronunciation;
    }

    public String getPronunciationContentType() {
        return this.pronunciationContentType;
    }

    public Pronounce pronunciationContentType(String pronunciationContentType) {
        this.pronunciationContentType = pronunciationContentType;
        return this;
    }

    public void setPronunciationContentType(String pronunciationContentType) {
        this.pronunciationContentType = pronunciationContentType;
    }

    public String getCreatedUser() {
        return this.createdUser;
    }

    public Pronounce createdUser(String createdUser) {
        this.setCreatedUser(createdUser);
        return this;
    }

    public void setCreatedUser(String createdUser) {
        this.createdUser = createdUser;
    }

    public ZonedDateTime getCreatedDate() {
        return this.createdDate;
    }

    public Pronounce createdDate(ZonedDateTime createdDate) {
        this.setCreatedDate(createdDate);
        return this;
    }

    public void setCreatedDate(ZonedDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getUpdatedUser() {
        return this.updatedUser;
    }

    public Pronounce updatedUser(String updatedUser) {
        this.setUpdatedUser(updatedUser);
        return this;
    }

    public void setUpdatedUser(String updatedUser) {
        this.updatedUser = updatedUser;
    }

    public ZonedDateTime getUpdatedDate() {
        return this.updatedDate;
    }

    public Pronounce updatedDate(ZonedDateTime updatedDate) {
        this.setUpdatedDate(updatedDate);
        return this;
    }

    public void setUpdatedDate(ZonedDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }

    public Boolean getIsActive() {
        return this.isActive;
    }

    public Pronounce isActive(Boolean isActive) {
        this.setIsActive(isActive);
        return this;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    // jhipster-needle-entity-add-getters-setters - JHipster will add getters and setters here

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Pronounce)) {
            return false;
        }
        return id != null && id.equals(((Pronounce) o).id);
    }

    @Override
    public int hashCode() {
        // see https://vladmihalcea.com/how-to-implement-equals-and-hashcode-using-the-jpa-entity-identifier/
        return getClass().hashCode();
    }

    // prettier-ignore
    @Override
    public String toString() {
        return "Pronounce{" +
            "id=" + getId() +
            ", employeeId='" + getEmployeeId() + "'" +
            ", firstName='" + getFirstName() + "'" +
            ", lastName='" + getLastName() + "'" +
            ", preferredName='" + getPreferredName() + "'" +
            ", phonetics='" + getPhonetics() + "'" +
            ", country='" + getCountry() + "'" +
            ", language='" + getLanguage() + "'" +
            ", pronoun='" + getPronoun() + "'" +
            ", pronunciation='" + getPronunciation() + "'" +
            ", pronunciationContentType='" + getPronunciationContentType() + "'" +
            ", createdUser='" + getCreatedUser() + "'" +
            ", createdDate='" + getCreatedDate() + "'" +
            ", updatedUser='" + getUpdatedUser() + "'" +
            ", updatedDate='" + getUpdatedDate() + "'" +
            ", isActive='" + getIsActive() + "'" +
            "}";
    }
}
