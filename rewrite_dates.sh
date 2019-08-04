#!/bin/bash

# Ensure the repository is clean
if ! git diff-index --quiet HEAD --; then
  echo "Your repository is not clean. Commit or stash your changes before proceeding."
  exit 1
fi

# Logging commit history dates without making any changes
git filter-branch --env-filter '
OLD_AUTHOR_DATE=$(git log -1 --pretty=format:%ai)
OLD_COMMITTER_DATE=$(git log -1 --pretty=format:%ci)
NEW_AUTHOR_DATE=$(date -d "$OLD_AUTHOR_DATE - 5 years" +%Y-%m-%dT%H:%M:%S)
NEW_COMMITTER_DATE=$(date -d "$OLD_COMMITTER_DATE - 5 years" +%Y-%m-%dT%H:%M:%S)

echo "OLD_AUTHOR_DATE: $OLD_AUTHOR_DATE"
echo "OLD_COMMITTER_DATE: $OLD_COMMITTER_DATE"
echo "NEW_AUTHOR_DATE: $NEW_AUTHOR_DATE"
echo "NEW_COMMITTER_DATE: $NEW_COMMITTER_DATE"
' -- --all

echo "Logging commit history dates completed. No changes were made."
