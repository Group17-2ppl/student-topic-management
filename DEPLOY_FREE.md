# Free deployment notes

## Important security note
The original `application.properties` contained a hard-coded database password. This prepared copy replaces it with environment variables. Rotate that database password if it has ever been pushed to GitHub or shared in an archive. Removing it from the current file does not remove it from Git history.

## Required environment variables
Set these in the hosting provider's service settings; do not put real credentials in GitHub:

- `DB_URL`: `jdbc:mysql://HOST:PORT/DATABASE?sslMode=REQUIRED&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8`
- `DB_USERNAME`: username provided by the cloud MySQL service
- `DB_PASSWORD`: password provided by the cloud MySQL service
- `PORT`: usually supplied automatically by the hosting provider; the Dockerfile defaults to `10000`

Use the exact hostname, port, and database name supplied by your MySQL provider. Confirm its TLS/SSL connection requirements before deployment.

## Deploy with Docker on Render
1. Push this source folder to a GitHub repository. Do not upload `.git`, `.idea`, `target`, or a real `.env` file.
2. In Render, create **New + → Web Service**, connect the repository, and choose **Docker** as the runtime.
3. Set the four environment variables above in the service's Environment settings. For Render, the service can use its assigned `PORT`; the Dockerfile defaults to `10000` if not set.
4. Deploy and inspect the build/runtime logs.
5. Test the public URL, login, JSP pages, file upload, and database persistence.

## Notes
- A free web instance may sleep when idle and take time to wake.
- Free database availability and limits vary by provider and may change. Keep a local database backup before importing data.
- `spring.jpa.hibernate.ddl-auto=update` may create/update tables but does not migrate existing local records. Export and import your schema/data separately.
- The project uses JSP and an executable WAR; verify that the Docker build and runtime work before sharing the URL with your lecturer.
