#! /usr/bin/env bash

# Defines global settings.

# General
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

# Homebrew
export HOMEBREW_CURL_RETRIES=3

# Repositories
export REPO_DOTFILES=1.1.0

# Applications
export DOCKER_APP_NAME="Docker.app"
export DOCKER_VOLUME_NAME="Docker"

if [[ "$(/usr/bin/arch)" == "arm64" ]]; then
  export DOCKER_APP_URL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
else
  export DOCKER_APP_URL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
fi

# Application Extensions
