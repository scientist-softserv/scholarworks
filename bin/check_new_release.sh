#!/bin/bash

# Replace these with your own GitHub username and repository name
GITHUB_USER="csuscholarworks"
REPO_NAME="scholarworks"
API_URL="https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/releases"

if [ -z "$1" ] | [ -z "$2" ]; then
  echo "Usage: ./check_new_release.sh (dev|prod) (ir|da). Argument not found"
  exit 1
fi

if [ "$1" == "dev" ] ; then
  # Get the latest pre-release tag from the GitHub API
  LATEST_TAG=$(curl --silent $API_URL | jq -r ".[] | select(.prerelease==true) | select(.tag_name | startswith(\"$2\")) | .tag_name" | head -1)
elif [ "$1" == "prod" ] ; then
  # Get the latest release tag from the GitHub API
  LATEST_TAG=$(curl --silent $API_URL | jq -r ".[] | select(.prerelease==false) | select(.tag_name | startswith(\"$2\")) | .tag_name" | head -1)
else
  echo "Usage: ./check_new_release.sh (dev|prod). Argument not recognized"
  exit 1
fi
echo "Latest tag is ${LATEST_TAG}"

# Check if the tag exists
if [ -z "$LATEST_TAG" ]; then
  echo "Error: No release tags found."
  exit 1
fi

# Get the current checked-out tag
CURRENT_TAG=$(git describe --tags --abbrev=0)

# Check if the current tag matches the latest tag
if [ "$LATEST_TAG" == "$CURRENT_TAG" ]; then
  echo "Already on the latest release tag: $LATEST_TAG"
  exit 0
else
  echo "Found new release tag: $LATEST_TAG"
  echo "Checking out the new tag..."

  # Fetch the latest tags from the remote repository
  git fetch --tags origin

  # Check out the latest tag
  git checkout $LATEST_TAG

  # Show the current checked-out tag
  echo "Now on tag: $(git describe --tags --abbrev=0)"

  echo "Running bundler"
  bundle install
  echo "Running migrations and assets"
  bundle exec rails db:migrate
  bundle exec rails assets:precompile
  echo "Restarting processes"
  systemctl restart httpd
fi
