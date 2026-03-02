---
name: status
description: Show git status for all OPIS repositories
---

Show the git status summary for all OPIS repositories.

1. List all directories in `/Users/andreya/Projects/Integrate_OPIS/`
2. For each git repository, show:
   - Repository name
   - Current branch
   - Status: clean, modified files, untracked files, ahead/behind remote
3. Present results in a table format:

| Repository | Branch | Status |
|------------|--------|--------|
| opis-ips | master | Clean |
| opis-web | feature/x | 3 modified |

4. Highlight any repositories that need attention:
   - Uncommitted changes
   - Behind remote
   - On non-default branch
