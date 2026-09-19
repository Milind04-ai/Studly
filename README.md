# Studly

An application for converting your scrolling habit to a skillful learning.

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

4. Check that MySQL is running:

```bash
docker compose ps
```

The `studly-mysql` container should be running and healthy.

5. Start the Spring Boot backend:

```bash
cd backend
mvn spring-boot:run
```

The backend runs on:

```text
http://localhost:8080/api/v1
```

6. Test the health endpoint:

```powershell
Invoke-RestMethod http://localhost:8080/api/v1/health
```

Expected response:

```text
service    timestamp                    status
-------    ---------                    ------
studly-api <timestamp>                  ok

```
