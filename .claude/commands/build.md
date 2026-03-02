---
name: build
description: Build an OPIS project (Java/Gradle or Node.js)
---

Build the specified OPIS project. Automatically detects project type.

**Usage:** `/build <project-name>` or `/build` (for current directory)

**Arguments:** $ARGUMENTS

1. Navigate to the project directory
2. Detect project type:
   - If `build.gradle` exists: Run `./gradlew clean build`
   - If `package.json` exists: Run `npm install && npm run build`
3. Report build status with any errors
4. For successful builds, show output artifact location
