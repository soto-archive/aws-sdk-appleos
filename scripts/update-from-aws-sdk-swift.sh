#!/bin/sh

set -eux

doesRemoteExist() {
    remote_name=$1
    remotes=$(git remote)
    for r in $remotes; do
        if [ "$remote_name" = "$r" ]; then
            echo "true"
            return
        fi
    done
    echo "false"
}


remote_exists=$(doesRemoteExist upstream)
if [ "$remote_exists" = "false" ]; then
    echo "Create upstream remote"
    git remote add upstream https://github.com/swift-aws/aws-sdk-swift-core.git
    git remote set-url --push upstream nopush
fi

echo "Fetch from upstream"
git fetch upstream

echo "Update master"
git checkout master
git rebase upstream/appleos

swift test

#git push
