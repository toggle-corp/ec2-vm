#!/bin/bash
set -xe

ROOT_REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function git_pull {
    cd $ROOT_REPO_DIR
    git fetch

    # Check if the local branch is behind the remote branch
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ $LOCAL = $REMOTE ]; then
        echo "Your branch is up to date with the remote."
    else
        git pull
        echo "There is change in remote, please re-run this script"
        exit 1
    fi
}

function vm_setup {
    # Update tc-local-vm repo
    cd $ROOT_REPO_DIR
    git pull

    # Setup ansible
    # -- Install ansible
    $ROOT_REPO_DIR/system/ansible-setup.sh

    # -- Run vm_setup playbook
    ANSIBLE_PLAYBOOKS_DIR="$ROOT_REPO_DIR/system/playbooks"

    ansible-playbook --diff $ANSIBLE_PLAYBOOKS_DIR/sync.yml
    ansible-playbook --diff $ANSIBLE_PLAYBOOKS_DIR/docker-setup.yml
    ansible-playbook --diff $ANSIBLE_PLAYBOOKS_DIR/atuin-install.yml

    cd $ROOT_REPO_DIR
    ./install
}

git_pull
vm_setup
