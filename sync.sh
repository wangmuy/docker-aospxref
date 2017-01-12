#!/bin/bash
#
# Test script file that maps itself into a docker container and runs
#
# Example invocation:
#
# $ AOSP_VOL=$PWD/build ./sync-kitkat.sh
#
set -ex

[ -z "$AOSP_BRANCH" ] && \
echo "need AOSP_BRANCH env. e.g: android-4.4.4_r2.0.1" && exit 1
[ -z "$AOSP_URL" ] && \
echo "need AOSP_URL env. e.g: https://android.googlesource.com/platform/manifest" && exit 1
[ -z "$AOSP_BASEDIR" ] && \
echo "no AOSP_BASEDIR env, using current dir" && destBaseDir=$(pwd -P) \
|| destBaseDir=$AOSP_BASEDIR

mydir=$(cd $(dirname $0) && pwd -P)

if [ "$1" = "docker" ]; then
    repo init --depth 1 -u "$AOSP_URL" -b "$AOSP_BRANCH"

    # Use default sync '-j' value embedded in manifest file to be polite
    repo sync
    retval=$?

    echo "repo sync returned: $retval"
    exit $retval
else
    aosp_url="https://raw.githubusercontent.com/kylemanna/docker-aosp/master/utils/aosp"
    args="run.sh docker"
    export AOSP_EXTRA_ARGS="-v $mydir/$(basename $0):/usr/local/bin/run.sh:ro -v $mydir/repo:/usr/local/bin/repo:ro"
    export AOSP_VOL=$destBaseDir/$AOSP_BRANCH
#    export AOSP_IMAGE="kylemanna/aosp:4.4-kitkat"

    [ -n "$AOSP_URL" ] && AOSP_EXTRA_ARGS+=" -e AOSP_URL=$AOSP_URL"
    [ -n "$AOSP_BRANCH" ] && AOSP_EXTRA_ARGS+=" -e AOSP_BRANCH=$AOSP_BRANCH"

    #
    # Try to invoke the aosp wrapper with the following priority:
    #
    # 1. If AOSP_BIN is set, use that
    # 2. If aosp is found in the shell $PATH
    # 3. Grab it from the web
    #
    if [ -n "$AOSP_BIN" ]; then
        echo $AOSP_BIN $args
    elif [ -x "$mydir/aosp" ]; then
        $mydir/aosp $args
    elif [ -n "$(type -P aosp)" ]; then
        echo aosp $args
    else
        if [ -n "$(type -P curl)" ]; then
            bash <(curl -s $aosp_url) $args
        elif [ -n "$(type -P wget)" ]; then
            bash <(wget -q $aosp_url -O -) $args
        else
            echo "Unable to run the aosp binary"
        fi
    fi
fi
