---
name: review
description: Review recent code changes for quality and security
---

Review recent code changes in the specified project or current directory.

**Usage:** `/review <project-name>` or `/review` (for current directory)

**Arguments:** $ARGUMENTS

1. Navigate to the project directory
2. Run `git diff HEAD~1` to see recent changes (or `git diff` for uncommitted changes)
3. Analyze changes against OPIS coding standards:

**For Java/Spring Boot code:**
- Proper Spring annotations usage
- Constructor injection (not field injection)
- No hardcoded credentials
- Input validation on REST endpoints
- Proper exception handling
- DTOs for API layer

**For TypeScript/React code:**
- Proper TypeScript types (no unnecessary `any`)
- Functional components with hooks
- Proper cleanup in useEffect
- Accessible components

**For all code:**
- Security issues (OWASP Top 10)
- Code clarity and naming
- Potential bugs or edge cases

4. Output review summary with:
   - Critical issues (must fix)
   - Warnings (should fix)
   - Suggestions (nice to have)
   - Positive observations
