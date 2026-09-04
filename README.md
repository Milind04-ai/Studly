# Studly

Studly is a micro-learning platform where learners can watch short educational videos, save study resources, and follow verified creators.

## Project structure

- `backend/` - Spring Boot REST API and MySQL integration
- `docs/` - API contracts, database design, and team documentation

## Run the backend locally

1. Install Java 21 and Docker Desktop.
2. Copy `backend/.env.example` to `backend/.env` and change the password values.
3. From the repository root, start MySQL:

   ```bash
   docker compose --env-file backend/.env up -d mysql
   ```

4. From `backend/`, start the API:

   ```bash
   mvn spring-boot:run
   ```

5. Confirm it is running at `http://localhost:8080/api/v1/health`.

Never commit `.env` files, passwords, API keys, videos, or PDFs.
