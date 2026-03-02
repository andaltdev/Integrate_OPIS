---
name: opis-java-build
description: Build Java/Gradle OPIS projects. Use when compiling Java code, creating JAR files, running Gradle tasks, or troubleshooting build issues. Covers Spring Boot services and connector libraries.
allowed-tools: Bash, Read, Glob, Grep
---

# OPIS Java/Gradle Build Skill

## Quick Reference

### Build Commands
```bash
./gradlew clean build        # Full build with tests
./gradlew assemble           # Build JARs only (no tests)
./gradlew test               # Run offline tests
./gradlew allTests           # Run all tests including integration
./gradlew jacocoTestReport   # Generate coverage report
./gradlew sonarqube          # Run SonarQube analysis
```

### Project Structure
```
<service>/
├── build.gradle
├── gradle.properties
├── settings.gradle
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │       ├── application.yml
│   │       └── application-{env}.yml
│   └── test/
│       └── java/
└── build/
    ├── libs/           # JAR files
    └── reports/        # Test & coverage reports
```

## OPIS Java Services

| Service | Description | Port |
|---------|-------------|------|
| opis-ips | Integration Processing Service | 8080 |
| opis-cds-agent | Cloud Data Service Agent | 8081 |
| opis-ui-service | UI Backend REST API | 8082 |
| opis-boomi-api | Boomi Platform API | 8083 |
| opis-availability-tests | Service monitoring | - |

## Common Build Issues

### Dependency Resolution
If dependencies fail to resolve:
```bash
./gradlew build --refresh-dependencies
```

### Memory Issues
Increase heap in `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx5120m
```

### Artifactory Authentication
Credentials are in `~/.gradle/gradle.properties`:
```properties
ARTIFACTORY_USER=your-email
ARTIFACTORY_PASSWORD=your-token
ARTIFACTORY_URL=https://artifactory.play.intapp.com
```

## Multi-Module Builds (opis-connector-all)

Build specific connector:
```bash
./gradlew :opis-connector-<name>:build
```

List all subprojects:
```bash
./gradlew projects
```

## Spring Boot Profiles

- `dev,local` - Local development
- `dev` - Development environment
- `qa` - QA environment
- `prod` - Production

Run with profile:
```bash
java -jar build/libs/app.jar --spring.profiles.active=dev,local
```

For detailed Spring Boot configuration, see [spring-boot-config.md](spring-boot-config.md).
