#!/bin/bash
# update (git pull or otherwise) a project

if [ ! -f ./util.sh ]; then
    echo "Please re-run from the folder with $REPOS"
    exit 1
fi
. ./util.sh

function help {
    echo "Update a project (git pull) from the public repository"
    echo " Usage: $0 [project]"
    echo " Valid projects are:"
    for p in $VALID_PROJECTS; do echo $p; done
}

# Check command line
PROJECT=$1
HELP_AND_EXIT=0
if [ -z $1 ]; then
    HELP_AND_EXIT=1
else
    check_if_valid_project $PROJECT
    if [ $? != 0 ]; then
        HELP_AND_EXIT=1
        echo "$PROJECT is not a valid project"
    fi
fi
if [ $HELP_AND_EXIT == 1 ]; then
    help
    exit 1
fi

# Get the repository (but mostly REPO_TYPE)
set_REPOSITORY $PROJECT
if [ $? != 0 ]; then
    echo "Error getting repository for $PROJECT"
    exit 1
fi

# Get clone command
if [ $REPO_TYPE == 'git' ]; then
    CMD="cd $PROJECT && git pull"
else
    echo "Unknown repository type '$REPO_TYPE'"
    exit 1
fi

# Clone it
echo "Updating $PROJECT"
echo $CMD
$CMD

