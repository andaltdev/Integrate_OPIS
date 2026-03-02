---
name: pull-all
description: Pull latest changes for all OPIS repositories
---

Pull the latest changes from remote for all OPIS git repositories.

1. List all directories in `/Users/andreya/Projects/Integrate_OPIS/`
2. For each directory that is a git repository:
   - Show the repository name
   - Run `git pull`
   - Report status (up to date, updated, conflicts)
3. Summarize results at the end:
   - Total repositories processed
   - Successfully updated
   - Any that need attention (conflicts, local changes)
