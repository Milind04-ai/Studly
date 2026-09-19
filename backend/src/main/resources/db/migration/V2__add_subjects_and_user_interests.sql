CREATE TABLE subjects (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    description VARCHAR(500) NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_subjects_name (name),
    UNIQUE KEY uk_subjects_slug (slug)
);

CREATE TABLE reel_subjects (
    reel_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reel_id, subject_id),
    KEY idx_reel_subjects_subject (subject_id, reel_id),
    CONSTRAINT fk_reel_subjects_reel
        FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE,
    CONSTRAINT fk_reel_subjects_subject
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

CREATE TABLE user_subjects (
    user_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    interest_level TINYINT UNSIGNED NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, subject_id),
    CONSTRAINT chk_user_subjects_interest_level
        CHECK (interest_level BETWEEN 1 AND 5),
    CONSTRAINT fk_user_subjects_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_subjects_subject
        FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);