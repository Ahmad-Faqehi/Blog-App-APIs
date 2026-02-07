# Blog Application Backend
A RESTful API for creating, reading and managing the posts/blogs. Developed using SpringBoot this REST api provides fast and secure access to anything you need. Documentation provided below.

## Built with
- [Spring Boot](https://spring.io/)
- [Maven](https://maven.apache.org/)
- [JPA](https://spring.io/projects/spring-data-jpa)
- [Hibernate](https://hibernate.org/)
- [MySQL](https://www.mysql.com/)

## Overview
Users should be able to create posts, Each post should have a category/topic tagged to it. Signup & login functionality of users along with password hashing. Pagination and sorting on posts. Users should be able to fetch the posts for other users or can view all the post of a particular topic. Data validation on create/update endpoints.

## Features Include
- Posts CRUD
- Users CRUD
- Category CRUD
- Comments on posts CRUD
- Post limiting for pagination
- Post sorting
- Role based authentication
- Custom Exception handling
- JWT authentication
- DTO pattern
- Image upload
- Post searching by keyword
- Role specific API access
- Data Validation using Hibernate validator
- Documentation using Swagger

## ER Diagram
<img src="https://user-images.githubusercontent.com/40179909/184941447-5120b1b6-7e34-42e3-b43e-eccaa7e06f11.jpg" width="700" hspace="60" vspace="60">

---

## Exporting API documentation and Postman collection ✅

If you want a Postman collection (or OpenAPI JSON) to drive the frontend, you can export the project's Swagger/OpenAPI JSON and convert it to a Postman collection.

Two helper scripts are included:

- `scripts/export-openapi.sh` (Bash)
- `scripts/export-openapi.ps1` (PowerShell)

What they do:
- Ensure the app is running (they will try to start the JAR from `target/` if it's not already running)
- Fetch the Swagger JSON from `http://localhost:8080/v2/api-docs`
- Save the JSON to `docs/openapi.json`

How to use:

1. Build the project locally (requires Java 11+):

   ```bash
   mvn -B package -DskipTests
   ```

2. Run the export script (choose one):

   Bash:
   ```bash
   ./scripts/export-openapi.sh
   ```

   PowerShell:
   ```powershell
   ./scripts/export-openapi.ps1
   ```

3. Import `docs/openapi.json` into Postman (Import → File). Or convert to a Postman collection with:

   ```bash
   npx openapi-to-postmanv2 -s docs/openapi.json -o docs/postman_collection.json -p
   ```

Notes:
- The scripts expect the app to run on `http://localhost:8080`. If your app runs on a different port, update the script or set `server.port` in `application.properties`.
- You need Java 11+ to run the built JAR (the project is compiled for Java 11).

**Done:** I generated the OpenAPI JSON and converted it to a Postman collection and saved them in the repository:

- `docs/openapi.json` — OpenAPI (Swagger) JSON exported from the running app (host: `localhost:9090` in my run)
- `docs/postman_collection.json` — Postman collection built from the OpenAPI JSON

If you'd prefer automation, I can still add a GitHub Action that regenerates `docs/openapi.json` on each push and publishes it as a workflow artifact or commits it to the repo.

### Viewing interactive Swagger UI 🔍

When the application is running locally, open:

- `http://localhost:8080/swagger-ui/index.html` (or `http://localhost:9090/swagger-ui/index.html` if your app runs on 9090)

This provides an interactive API explorer where you can try endpoints and see schemas.

---







