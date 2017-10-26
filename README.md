Helper scripts for syncing and setting up AOSP cross reference.

Require kylemanna/aosp and scue/docker-opengrok docker images.

Usage:
edit env-test:
```bash
AOSP_BRANCH=android-8.0.0_r4
AOSP_URL=git://mirrors.ustc.edu.cn/aosp/platform/manifest
AOSP_BASEDIR=/home/myname/myaosp
OPENGROK_PORT=9001
```

```text
sudo sh -c 'env `cat env-test` ./syncandup.sh'
```

The above script will download aosp 8.0.0_r4 repo and setup a opengrok site on port 9001.

Visit xref site at http://127.0.0.1:9001
