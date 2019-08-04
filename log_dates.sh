#!/bin/bash

# Ensure the repository is clean
if ! git diff-index --quiet HEAD --; then
  echo "Your repository is not clean. Commit or stash your changes before proceeding."
  exit 1
fi

# Fetch the last 4 commit hashes
commits=$(git rev-list -n 4 HEAD)

# Loop through each commit and print the adjusted committer date
for commit in $commits; do
  COMMITTER_DATE=$(git show -s --format=%ci $commit)
  ADJUSTED_DATE=$(gdate -d "$COMMITTER_DATE - 5 years" "+%Y-%m-%d %H:%M:%S")
  echo "Commit: $commit"
  echo "Original GIT_COMMITTER_DATE: $COMMITTER_DATE"
  echo "Adjusted GIT_COMMITTER_DATE: $ADJUSTED_DATE"
done
