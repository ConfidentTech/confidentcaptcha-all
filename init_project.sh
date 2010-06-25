#!/bin/bash
# initialize (git clone or otherwise) a project

if [ ! -f ./util.sh ]; then
    echo "Please re-run from the folder with $REPOS"
    exit 1
fi
. ./util.sh

function help {
    echo "Initialize a project from the public repository"
    echo " Usage: $0 [project]"
    echo " Valid projects are:"
    for p in $VALID_PROJECTS; do echo $p; done
    echo " Modify $MY_PROJECTS to clone the read-write version of a project"
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

# Get the repository
set_REPOSITORY $PROJECT
if [ $? != 0 ]; then
    echo "Error getting repository for $PROJECT"
    exit 1
fi

# Clear out any existing project
rm -rf $PROJECT
mkdir -p $PROJECT

# Get clone command
if [ $REPO_TYPE == 'git' ]; then
    CMD="git clone $REPOSITORY $PROJECT"
else
    echo "Unknown repository type '$REPO_TYPE'"
    exit 1
fi

# Clone it
if [ $READ_ONLY == 1 ]; then TYPE='read-only'; else TYPE='read-write'; fi
echo "Initilizing $TYPE working copy of $PROJECT"
echo $CMD
$CMD
