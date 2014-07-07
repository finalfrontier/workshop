#!/bin/bash

cd "./addon/gamemodes/finalfrontier"

git pull origin master

cd "../../maps"

git pull origin master

cd "../materials"

git pull origin master

cd "../../"



HASH="$(git rev-parse HEAD)"

echo "update -addon \"./finalfrontier.gma\" -id \"282752490\" -changes \"Updated to version https://github.com/finalfrontier/workshop/commit/${HASH}\""
#gmpublish.exe update -addon "./finalfrontier.gma" -id "282752490" -changes "Updated to version https://github.com/finalfrontier/workshop/commit/$HASH"
