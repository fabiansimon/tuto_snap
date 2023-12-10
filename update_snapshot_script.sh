#!/bin/bash

if [ $# < 2 ]; then
	echo "Usage: $0 <repository> <interval in seconds>"
	exit 1
fi

while true; do
	echo "Running TutoSnap"

	DIRECTORY=$1
	INTERVAL=$2 
	TIMESTAMP=$(date +%s)
	SNAPSHOT_BRANCH="ttsnaps"
	CURRENT_BRANCH=$(git branch --show-current)

	# Navigate to right repository
	cd ~/$DIRECTORY

	# DEBUG MODE
	# echo "DEBUG CHANGES" >> DEBUG.txt

	# Git actions
	git add .

	git commit -m "ttsnp_${TIMESTAMP}"

	# Check if SNAPSHOT BRANCH is already created
	EXISTING_BRANCH=$(git ls-remote --heads origin ${SNAPSHOT_BRANCH})

	if [[ -z ${EXISTING_BRANCH} ]]; then
		git checkout -b $SNAPSHOT_BRANCH
	else
		git checkout $SNAPSHOT_BRANCH
	fi

	git merge -X theirs --no-ff -m "________" -

	if [[ -z ${EXISTING_BRANCH} ]]; then
		git push --set-upstream origin $SNAPSHOT_BRANCH --force
	else
		git push --force
	fi

	git checkout -

	git reset --soft HEAD~1

	echo "Snapshot taken and committed to $SNAPSHOT_BRANCH"

	# git add .
	# git commit -m <message>
	# git checkout <branch>
	# git merge -X theirs --no-ff -m <timestamp message> -
	# git push (--set-upstream origin <branch>
	# git checkout -
	# git reset --soft HEAD~1

	sleep $INTERVAL
done

