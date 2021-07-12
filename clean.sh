#!/bin/bash

#   Copyright The containerd Authors.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -euo pipefail

CONTAINERD_ROOT=/var/lib/containerd/
SNAPSHOTTER_ROOT=/var/lib/containerd-cafs-snapshotter/
SNAPSHOTTER_SOCKET=/run/containerd-cafs-grpc/containerd-cafs-grpc.sock

function kill_all {
    if [ "${1}" != "" ] ; then
        ps aux | grep "${1}" | grep -v grep | sed -E 's/ +/ /g' | cut -f 2 -d ' ' | xargs -I{} kill -9 {} || true
    fi
}

function cleanup {
    rm -rf "${CONTAINERD_ROOT}"*
    if [ -f "${SNAPSHOTTER_SOCKET}" ] ; then
        rm "${SNAPSHOTTER_SOCKET}"
    fi
    if [ -d "${SNAPSHOTTER_ROOT}snapshots/" ] ; then 
        find "${SNAPSHOTTER_ROOT}snapshots/" \
             -maxdepth 1 -mindepth 1 -type d -exec umount "{}/fs" \;
    fi
    rm -rf "${SNAPSHOTTER_ROOT}"*
}

echo "cleaning up the environment..."
systemctl stop containerd.service

kill_all "containerd-cafs-grpc"
cleanup

systemctl start containerd.service