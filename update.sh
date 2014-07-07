#!/bin/bash

cd "./addon/gamemodes/finalfrontier"

git pull origin master

cd "../../maps"

git pull origin master

cd "../materials"

git pull origin master

cd "../../"

if [ -n "$(git status -s | grep -E "^ *M +addon/")" ]
then
    echo ""
    echo "# Submodule change(s) detected, committing..."
    echo ""

    git add "addon/*"
    git commit -m "Updated submodules"
    git push origin master

    gmad create -folder "./addon/" -out "./finalfrontier.gma"

    HASH="$(git rev-parse HEAD)"
    gmpublish update -addon "./finalfrontier.gma" -id "282752490" -changes "Updated to commit https://github.com/finalfrontier/workshop/commit/${HASH}"
else
    echo ""
    echo "# No changes found, aborting..."
    echo ""
fi
