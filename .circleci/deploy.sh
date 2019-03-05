#!/bin/sh

DIR=$(dirname "$0")

cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo -t hugo-learn-theme

echo "Updating gh-pages branch"
git config --global user.email $GH_EMAIL
git config --global user.name $GH_NAME
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

echo "Push Update"
git push -f
