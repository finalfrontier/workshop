#!/bin/bash

CHANGEFILE="$(pwd)/changes.txt"

echo -n "" >"$CHANGEFILE"

function fetch_submodule_changes
{
    OLDDIR="$(pwd)"
    NEWDIR="$1"
    NAME="$2"

    echo "# Searching for changes to ${NAME}..."

    cd "$NEWDIR"

    OLDHEAD="$(git rev-parse HEAD)"

    git fetch origin
    git submodule update

    NEWHEAD="$(git rev-parse origin/master)"

    if [ "$OLDHEAD" != "$NEWHEAD" ]
    then
        echo "# Change to ${NAME} found."

        REMOTE="$(git remote -v | sed ':a;N;$!ba;s/[ \t]/\n/g' | grep -E 'https://github.com/finalfrontier/[a-z]+' | head -1)"
        LONGURL="${REMOTE}/compare/${OLDHEAD}...${NEWHEAD}"
       
        SHORTURL="$(curl -i http://git.io/ -F "url=${LONGURL}" | grep 'Location: ' | sed 's/Location: //')"

        echo "${NAME} changes: ${SHORTURL}" >>"$CHANGEFILE"

        git rev-list "HEAD..origin/master" --reverse "--format=format:* %s" \
            | grep -Ev "(Merge branch)|(^commit [a-f0-9]{32})" \
            >>"$CHANGEFILE"

        echo "" >>"$CHANGEFILE"

        git merge origin/master
    else
        echo "# No change to ${NAME} since last update."
    fi

    cd "$OLDDIR"
}

fetch_submodule_changes "./addon/gamemodes/finalfrontier" "Gamemode"
fetch_submodule_changes "./addon/maps" "Map"
fetch_submodule_changes "./addon/materials" "Material"

if [ -z "$(cat ${CHANGEFILE})" ]
then
    echo "# No changes found, aborting..."
    exit 1
fi

echo "# Submodule change(s) detected, committing..."

cat "$CHANGEFILE"

git add "addon/*"
git commit -m "$(cat ${CHANGEFILE})"
git push origin master

gmad create -folder "./addon/" -out "./finalfrontier.gma"

gmpublish update -addon "./finalfrontier.gma" -id "282752490" -changes "$(cat ${CHANGEFILE})"

exit 0


