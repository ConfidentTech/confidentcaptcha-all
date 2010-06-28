#!/bin/bash
# update (git pull or otherwise) a project

if [ ! -f ./util.sh ]; then
    echo "Please re-run from the folder with $REPOS"
    exit 1
fi
. ./util.sh

for PROJECT in $VALID_PROJECTS; do
    ./update_project.sh $PROJECT
    if [ $? != 0 ]; then exit $?; fi
    echo
done
