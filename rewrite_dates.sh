#!/bin/bash

# Ensure git-filter-repo is installed
if ! command -v git-filter-repo &> /dev/null
then
    echo "git-filter-repo could not be found. Please install it using 'pip install git-filter-repo'."
    exit 1
fi

# Rewriting commit history
git filter-repo --commit-callback '
import datetime

commit.author_date = str(
    datetime.datetime.fromtimestamp(commit.author_date) - datetime.timedelta(days=5*365)
)
commit.committer_date = str(
    datetime.datetime.fromtimestamp(commit.committer_date) - datetime.timedelta(days=5*365)
)
'

echo "Rewriting commit history completed. Don't forget to force push to your remote repository."
