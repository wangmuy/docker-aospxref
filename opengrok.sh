#!/bin/sh
#DEBUG=echo
set -ex

[ -z "$AOSP_BRANCH" ] && \
echo "need AOSP_BRANCH env. e.g: android-6.0.0_r1" && exit 1

[ -z "$OPENGROK_PORT" ] && \
echo "need OPENGROK_PORT env. e.g: 9000" && exit 1

[ -z "$AOSP_BASEDIR" ] && \
echo "no AOSP_BASEDIR env, using current dir" && destBaseDir=$(pwd -P) \
|| destBaseDir=$AOSP_BASEDIR

myBaseDir=$destBaseDir/$AOSP_BRANCH
aospDir=$myBaseDir/aosp
opengrokDir=$myBaseDir/opengrok_data
myport=$OPENGROK_PORT

[ ! -d $opengrokDir ] && mkdir -p $opengrokDir

$DEBUG docker run -it --name opengrok-$AOSP_BRANCH \
    -v $aospDir:/src \
    -v $opengrokDir:/data \
    -p $myport:8080 \
    scue/docker-opengrok

