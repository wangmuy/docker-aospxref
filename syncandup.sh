#!/bin/sh
set -ex
[ -z "$AOSP_BRANCH" ] && \
echo "need AOSP_BRANCH env. e.g: android-4.4.4_r2.0.1" && exit 1
[ -z "$AOSP_URL" ] && \
echo "need AOSP_URL env. e.g: https://android.googlesource.com/platform/manifest" && exit 1
[ -z "$OPENGROK_PORT" ] && \
echo "need OPENGROK_PORT env. e.g: 9000" && exit 1

mydir=$(cd $(dirname $0) && pwd -P)

$mydir/sync.sh
$mydir/opengrok.sh
