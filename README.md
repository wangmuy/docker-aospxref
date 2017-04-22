Helper scripts for syncing and setting up AOSP cross reference.

Require kylemanna/aosp and scue/docker-opengrok docker images.

Usage:
edit env-test:
```bash
AOSP_BRANCH=android-7.0.0_r1
AOSP_URL=https://aosp.tuna.tsinghua.edu.cn/platform/manifest
AOSP_BASEDIR=~/myaosp
OPENGROK_PORT=9001
```

```text
sudo sh -c 'env `cat env-test` ./syncandup.sh'
```

The above script will download aosp 7.0.0_r1 repo and setup a opengrok site on port 9001.

Visit xref site at http://127.0.0.1:9001
