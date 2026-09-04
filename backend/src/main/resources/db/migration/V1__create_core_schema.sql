CREATE TABLE users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(254) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    bio VARCHAR(500) NULL,
    profile_image_url VARCHAR(2048) NULL,
    role ENUM('LEARNER', 'CREATOR', 'ADMIN') NOT NULL DEFAULT 'LEARNER',
    account_status ENUM('ACTIVE', 'SUSPENDED', 'DELETED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_username (username),
    UNIQUE KEY uk_users_email (email)
);

CREATE TABLE creator_verifications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    qualification VARCHAR(255) NOT NULL,
    institution VARCHAR(255) NULL,
    proof_document_url VARCHAR(2048) NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    reviewed_by BIGINT NULL,
    reviewed_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_creator_verifications_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_creator_verifications_reviewer FOREIGN KEY (reviewed_by) REFERENCES users(id)
);

CREATE TABLE reels (
    id BIGINT NOT NULL AUTO_INCREMENT,
    creator_id BIGINT NOT NULL,
    caption VARCHAR(2200) NULL,
    video_url VARCHAR(2048) NOT NULL,
    thumbnail_url VARCHAR(2048) NULL,
    duration_seconds SMALLINT UNSIGNED NOT NULL,
    visibility ENUM('PUBLIC', 'FOLLOWERS_ONLY', 'PRIVATE') NOT NULL DEFAULT 'PUBLIC',
    status ENUM('PROCESSING', 'PUBLISHED', 'REJECTED', 'DELETED') NOT NULL DEFAULT 'PROCESSING',
    view_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_reels_feed (status, visibility, created_at),
    KEY idx_reels_creator (creator_id, created_at),
    CONSTRAINT chk_reels_duration CHECK (duration_seconds BETWEEN 1 AND 90),
    CONSTRAINT fk_reels_creator FOREIGN KEY (creator_id) REFERENCES users(id)
);

CREATE TABLE reel_documents (
    id BIGINT NOT NULL AUTO_INCREMENT,
    reel_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(2048) NOT NULL,
    file_size_bytes BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_reel_documents_reel (reel_id),
    CONSTRAINT fk_reel_documents_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE
);

CREATE TABLE hashtags (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_hashtags_name (name)
);

CREATE TABLE reel_hashtags (
    reel_id BIGINT NOT NULL,
    hashtag_id BIGINT NOT NULL,
    PRIMARY KEY (reel_id, hashtag_id),
    CONSTRAINT fk_reel_hashtags_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE,
    CONSTRAINT fk_reel_hashtags_hashtag FOREIGN KEY (hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE
);

CREATE TABLE follows (
    follower_id BIGINT NOT NULL,
    following_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    CONSTRAINT chk_follows_not_self CHECK (follower_id <> following_id),
    CONSTRAINT fk_follows_follower FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_follows_following FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE reel_likes (
    user_id BIGINT NOT NULL,
    reel_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, reel_id),
    CONSTRAINT fk_reel_likes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_reel_likes_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE
);

CREATE TABLE reel_saves (
    user_id BIGINT NOT NULL,
    reel_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, reel_id),
    CONSTRAINT fk_reel_saves_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_reel_saves_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE
);

CREATE TABLE comments (
    id BIGINT NOT NULL AUTO_INCREMENT,
    reel_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    parent_comment_id BIGINT NULL,
    body VARCHAR(1000) NOT NULL,
    status ENUM('VISIBLE', 'HIDDEN', 'DELETED') NOT NULL DEFAULT 'VISIBLE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_comments_reel (reel_id, created_at),
    CONSTRAINT fk_comments_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    recipient_id BIGINT NOT NULL,
    actor_id BIGINT NULL,
    type ENUM('FOLLOW', 'LIKE', 'COMMENT', 'SYSTEM') NOT NULL,
    reel_id BIGINT NULL,
    comment_id BIGINT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_notifications_recipient (recipient_id, is_read, created_at),
    CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_notifications_actor FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_notifications_reel FOREIGN KEY (reel_id) REFERENCES reels(id) ON DELETE CASCADE,
    CONSTRAINT fk_notifications_comment FOREIGN KEY (comment_id) REFERENCES comments(id) ON DELETE CASCADE
);
