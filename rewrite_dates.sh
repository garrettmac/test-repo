#!/bin/bash

# Ensure the repository is clean
if ! git diff-index --quiet HEAD --; then
  echo "Your repository is not clean. Commit or stash your changes before proceeding."
  exit 1
fi

# Rewriting commit history
git filter-branch --env-filter '
OLD_DATE=$(date -d "$GIT_COMMITTER_DATE - 5 years" +%Y-%m-%dT%H:%M:%S)
export GIT_COMMITTER_DATE=$OLD_DATE
export GIT_AUTHOR_DATE=$OLD_DATE
' -- --all

echo "Rewriting commit history completed. Don't forget to force push to your remote repository."
