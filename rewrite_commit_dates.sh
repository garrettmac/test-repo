#!/bin/bash

# Ensure the repository is clean
if ! git diff-index --quiet HEAD --; then
  echo "Your repository is not clean. Commit or stash your changes before proceeding."
  exit 1
fi

# Fetch the last 4 commit hashes
commits=$(git rev-list -n 4 HEAD)

# Rewriting commit history to set dates to exactly 5 years earlier
git filter-branch --env-filter '
OLD_AUTHOR_DATE=$(git show -s --format=%ai $GIT_COMMIT)
OLD_COMMITTER_DATE=$(git show -s --format=%ci $GIT_COMMIT)

NEW_AUTHOR_DATE=$(gdate -d "$OLD_AUTHOR_DATE - 5 years" "+%Y-%m-%d %H:%M:%S")
NEW_COMMITTER_DATE=$(gdate -d "$OLD_COMMITTER_DATE - 5 years" "+%Y-%m-%d %H:%M:%S")

echo "Commit: $GIT_COMMIT"
echo "OLD_AUTHOR_DATE: $OLD_AUTHOR_DATE"
echo "OLD_COMMITTER_DATE: $OLD_COMMITTER_DATE"
echo "NEW_AUTHOR_DATE: $NEW_AUTHOR_DATE"
echo "NEW_COMMITTER_DATE: $NEW_COMMITTER_DATE"

export GIT_AUTHOR_DATE="$NEW_AUTHOR_DATE"
export GIT_COMMITTER_DATE="$NEW_COMMITTER_DATE"
' -- --all

echo "Rewriting commit history completed. Don't forget to force push to your remote repository."
