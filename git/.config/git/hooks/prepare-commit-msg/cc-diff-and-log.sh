#!/bin/sh

# Inserts useful information as comments for merge commits

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2
SHA1=$3


if [ "$COMMIT_SOURCE" = "merge" ]; then
    echo '# < "ours" (HEAD)' >> "$COMMIT_MSG_FILE"
    echo '# > "theirs" (MERGE_HEAD)' >> "$COMMIT_MSG_FILE"
    echo "#" >> "$COMMIT_MSG_FILE"
    echo "# Merge log" >> "$COMMIT_MSG_FILE"
    git log --oneline --merge --left-right | sed 's/.*/# &/' >> "$COMMIT_MSG_FILE"
    echo "#" >> "$COMMIT_MSG_FILE"
    echo "# Combined Diff" >> "$COMMIT_MSG_FILE"
    git diff | sed 's/.*/# &/' >> "$COMMIT_MSG_FILE"
fi
