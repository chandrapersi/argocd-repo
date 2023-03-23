#!/bin/bash

set -e

APPSET_FILES=applicationsets/development/appset.yaml
CLUSTER_CONFIG_FILES=configurations/development/cluster-config.yaml
CODE_BRANCH=code
CONFIGURATION_BRANCH=configuration
DEBUG=true
# TRAVIS_REPO_SLUG=Rohita83/argocd-repo

function initGlobal() {
    export cluster_config_file appset_files codeBranch configurationBranch
    codeBranch=${CODE_BRANCH:?}
    configurationBranch=${CONFIGURATION_BRANCH:?}
    cluster_config_file="${CLUSTER_CONFIG_FILES:?}"
    appset_files="${APPSET_FILES:?}"
}

function echoIt() {
  if [[ -n $DEBUG ]]; then
    echo "$@"
  fi
}

function updateTargetRevisionInAppset() {
    mkdir gitSpace
    cd gitSpace
    git clone --branch "${configurationBranch}" "https://${GIT_TOKEN:?}@github.com/${TRAVIS_REPO_SLUG}.git"
    cd ./*
    # skip non-code commits
    gitlog=$(git log --pretty=oneline "${TRAVIS_COMMIT}~1..${TRAVIS_COMMIT}")
    echo "gitlog = $gitlog"
}

function all() {

  echoIt "trace: TRAVIS_TAG=${TRAVIS_TAG} TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST} TRAVIS_BRANCH=${TRAVIS_BRANCH} TRAVIS_COMMIT=${TRAVIS_COMMIT}"
  echoIt "trace: TRAVIS_COMMIT_MESSAGE=${TRAVIS_COMMIT_MESSAGE} TRAVIS_JOB_NAME=${TRAVIS_JOB_NAME}"
  echoIt "TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}"

  initGlobal
  # # Executed after PR has been merged
  # if [[ -z ${TRAVIS_TAG}  &&  ${TRAVIS_PULL_REQUEST} == "false" && ${TRAVIS_BRANCH} == "${codeBranch}" ]]; then
  #   updateTargetRevisionInAppset
  #   exit 0
  # fi
}

# execute arguments
"$@"
