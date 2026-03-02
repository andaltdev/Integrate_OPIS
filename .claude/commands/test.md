---
name: test
description: Run tests for an OPIS project
---

Run tests for the specified OPIS project. Automatically detects project type.

**Usage:** `/test <project-name>` or `/test` (for current directory)

**Arguments:** $ARGUMENTS

1. Navigate to the project directory
2. Detect project type and run appropriate tests:
   - **Gradle projects**: `./gradlew test` (offline tests)
   - **opis-web**: `npm test`
   - **opis-process-reporting-widget**: `npm test`
3. Parse and report test results:
   - Total tests run
   - Passed / Failed / Skipped counts
   - List any failed tests with error messages
4. Suggest fixes for failing tests if applicable
