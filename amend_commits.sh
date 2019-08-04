#!/bin/bash

# Check if commit SHAs are provided
if [ $# -eq 0 ]; then
  echo "Please provide the commit SHAs."
  exit 1
fi

# Ensure the repository is clean
if ! git diff-index --quiet HEAD --; then
  echo "Your repository is not clean. Commit or stash your changes before proceeding."
  exit 1
fi

# Function to adjust commit dates
adjust_commit_date() {
  local commit_sha=$1
  local old_author_date=$(git show -s --format=%ai $commit_sha)
  local old_committer_date=$(git show -s --format=%ci $commit_sha)
  local new_author_date=$(gdate -d "$old_author_date - 5 years" "+%Y-%m-%d %H:%M:%S")
  local new_committer_date=$(gdate -d "$old_committer_date - 5 years" "+%Y-%m-%d %H:%M:%S")

  echo "Processing commit: $commit_sha"
  echo "Old Author Date: $old_author_date"
  echo "Old Committer Date: $old_committer_date"
  echo "New Author Date: $new_author_date"
  echo "New Committer Date: $new_committer_date"

  # Amend the commit with new dates
  GIT_COMMITTER_DATE="$new_committer_date" GIT_AUTHOR_DATE="$new_author_date" git commit --amend --no-edit --date="$new_author_date"
}

# Export function to use in rebase
export -f adjust_commit_date

# Iterate over each provided commit SHA and amend them
for commit_sha in "$@"; do
  git rebase -i --exec "adjust_commit_date $commit_sha" $commit_sha^
done

echo "Amending commits completed. Don't forget to force push to your remote repository."
