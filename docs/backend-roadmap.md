# Backend roadmap

## Milestone 1 - Foundation

- Spring Boot application and local MySQL
- Health endpoint
- Shared API error format and validation
- Database migrations (initial schema added in `V1__create_core_schema.sql`)

## Milestone 2 - Core accounts

- Registration and login
- JWT authentication
- User and creator profiles
- Creator-verification workflow

## Milestone 3 - Learning content

- Reel creation, retrieval, and deletion
- Video and optional PDF upload through an object-storage provider
- Hashtags, subject categories, and feed pagination

## Milestone 4 - Engagement

- Likes, comments, saves, follows, and notifications
- Search across creators, hashtags, subjects, and reels

## Data ownership

Videos and PDFs belong in object storage (for example, Cloudinary or Amazon S3). MySQL stores only URLs, file metadata, and application data.
