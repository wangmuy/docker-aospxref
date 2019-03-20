#!/bin/sh
#DEBUG=echo
unset SUDO && [ "$(id -u)" != "0" ] && SUDO=sudo
# If in docker group, no sudo needed
if id -nG | grep -qw docker; then
  SUDO=
fi
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

myName="opengrok-$AOSP_BRANCH"
container="$(${SUDO} docker ps -aq -f name=${myName})"
if [ -n "$SUDO" ]; then
  echo "Requring sudo privilege to run docker..."
fi

if [ -n "$container" ]; then
$SUDO $DEBUG docker start -a $container
else
$SUDO $DEBUG docker run -it --name opengrok-$AOSP_BRANCH \
    -v $aospDir:/src \
    -v $opengrokDir:/data \
    -p $myport:8080 \
    scue/docker-opengrok
fi
