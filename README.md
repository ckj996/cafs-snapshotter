# [cafs](https://github.com/ckj996/cafs) snapshotter plugin for [containerd](https://containerd.io)

## Requirements
* kernel >= 4.18
* containerd >= 1.4

## Setup

Add the following lines to `/etc/containerd/config.toml`:

```toml
[proxy_plugins]
  [proxy_plugins.cafs]
    type = "snapshot"
    address = "/run/containerd-cafs-grpc/containerd-cafs-grpc.sock"
```

Then restart containerd:

```bash
sudo systemctl restart containerd.service
```

Finally, execute `cafs-snapshotter` plugin as a separate binary:

```bash
sudo containerd-cafs-grpc \
	/run/containerd-cafs-grpc/containerd-cafs-grpc.sock \
	/var/lib/containerd-cafs-snapshotter/
```

## Usage

```bash
sudo ctr image import --snapshotter cafs debian.tar
sudo ctr run --rm -t --snapshotter cafs docker.io/library/debian:buster debian-1
```

## Project details
cafs-snapshotter is forked from [containerd/fuse-overlayfs-snapshotter](https://github.com/containerd/fuse-overlayfs-snapshotter), licensed under the [Apache 2.0 license](./LICENSE).

**Changes:** it uses cafs (FUSE) and overlayfs to support a content-addressable image format, which is designed for file-level deduplication and lazy loading.

See also:
 * [cafs: Content-addressable Filesystem](https://github.com/ckj996/cafs)
 * [stargz-snapshotter](https://github.com/containerd/stargz-snapshotter)
