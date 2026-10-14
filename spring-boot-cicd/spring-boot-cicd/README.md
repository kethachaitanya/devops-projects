# Spring Boot Advanced CI/CD Challenge Project

This project keeps the same structure as the uploaded Spring Boot CI/CD project:

```text
spring-boot-app/
spring-boot-app-manifests/
Argo CD/
README.md
```

It contains intentional CI/CD problems. Run the Jenkins pipeline, fix the first failure, commit, run again, and continue until the full release succeeds.

## Before Running

Replace these placeholders:

```text
YOUR_DOCKERHUB_USER
YOUR_GITHUB_USER
YOUR_REPO_NAME
YOUR_SONARQUBE_HOST
```

Create Jenkins credentials:

```text
docker-cred     Docker Hub username/password
github          GitHub token
sonarqube       SonarQube token
```

Install or provide these tools on the Jenkins agent:

```text
docker
trivy
kubectl
argocd
```

Make scripts executable on Linux/Jenkins:

```bash
chmod +x java-maven-sonar-argocd-helm-k8s/scripts/*.sh
```

## Failure Roadmap

### Challenge 01: Maven Test Failure

Broken file:

```text
spring-boot-app/src/test/java/com/abhishek/StartApplicationTest.java
```

Expected failure:

```text
Build and Unit Test stage fails.
Docker image is not built.
GitOps update is not attempted.
```

Fix:

```text
Correct the failing assertion.
```

### Challenge 02: SonarQube Quality Gate

Files involved:

```text
spring-boot-app/sonar-project.properties
spring-boot-app/src/main/java/com/abhishek/ChallengeQualityIssue.java
```

Expected failure:

```text
Quality Gate stage fails if your SonarQube gate requires coverage or blocks new code issues.
```

Fix:

```text
Add useful unit tests, improve the quality issue, or tune the Quality Gate policy.
```

Also configure this SonarQube webhook:

```text
http://YOUR_JENKINS_URL/sonarqube-webhook/
```

### Challenge 03: Trivy Image Security Failure

Broken file:

```text
spring-boot-app/Dockerfile
```

Expected failure:

```text
Scan Docker Image stage fails on HIGH or CRITICAL vulnerabilities.
```

Fix:

```text
Replace the old base image with a safer Java 11 runtime image.
Example: eclipse-temurin:11-jre-alpine
```

### Challenge 04: GitOps Manifest Update Failure

Broken file:

```text
spring-boot-app/JenkinsFile
```

Broken setting:

```text
MANIFEST_FILE = "${PROJECT_DIR}/spring-boot-app-manifests/deployment-wrong.yml"
```

Expected failure:

```text
Update GitOps Manifest stage fails because the manifest path is wrong.
```

Fix:

```text
Change deployment-wrong.yml to deployment.yml.
```

### Challenge 05: Failed Kubernetes Rollout and Rollback

Broken file:

```text
spring-boot-app-manifests/deployment.yml
```

Broken setting:

```text
readinessProbe.path = /healthz
livenessProbe.path = /healthz
```

Expected failure:

```text
Kubernetes rollout fails because the Spring Boot app serves /, not /healthz.
The rollback script reverts the last GitOps commit.
```

Fix:

```text
Change both probe paths from /healthz to /.
```

### Challenge 06: Webhook Automation

GitHub webhook:

```text
Payload URL: http://YOUR_JENKINS_URL/github-webhook/
Content type: application/json
Event: push
```

Expected behavior:

```text
One GitHub push triggers one Jenkins build.
Concurrent builds are disabled.
Only main branch updates the GitOps manifest.
```

## Success Criteria

You are done when:

```text
Maven build passes.
SonarQube Quality Gate passes.
Trivy scan passes.
Docker image is pushed.
GitOps manifest is updated.
Argo CD syncs the app.
Kubernetes rollout becomes healthy.
```
