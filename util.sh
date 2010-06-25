#!/bin/bash
# Helper functions

REPOSITORIES=repositories.txt
MY_PROJECTS=my_projects.txt

# Check for repository list and set VALID_PROJECTS
if [ ! -f $REPOSITORIES ]; then
    echo "Please re-run from the folder with $REPOSITORIES"
    exit 1
else
    VALID_PROJECTS=`grep -v "^#" repositories.txt | cut -d, -f1 | sort`
fi

# Check if the given project is a valid project
# Sets return value to 0 if valid, non-zero if not valid
function check_if_valid_project {
    echo "$VALID_PROJECTS" | grep --quiet "$PROJECT"
    return $?
}

# Set REPOSITORY to the project URL
# Set READ_ONLY to 1 if it is the read-only repository
# Set REPO_TYPE to the type of repository
function set_REPOSITORY {
    if [ -z $1 ]; then
        echo "set_REPOSITORY takes the project name as a parameter"
        exit 1
    else
        check_if_valid_project $1
        if [ $? != 0 ]; then
            echo "set_REPOSITORY: $1 is not a valid project."
            exit 1
        fi
    fi

    # Read_only or other repo?
    READ_ONLY=1
    if [ -f $MY_PROJECTS ]; then
        grep --quiet "^$1" $MY_PROJECTS
        if [ $? == 0 ]; then
            READ_ONLY=0
        fi
    fi

    # Get the repo type
    REPO_TYPE=`grep "^$1" $REPOSITORIES | head -n1 | cut -d, -f2`

    # Get repo address
    if [ $READ_ONLY == 0 ]; then
        REPOSITORY=`grep "^$1" $REPOSITORIES | head -n1 | cut -d, -f4`
    else
        REPOSITORY=`grep "^$1" $REPOSITORIES | head -n1 | cut -d, -f3`
    fi
    return 0
}

