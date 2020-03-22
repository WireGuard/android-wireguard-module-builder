## Android WireGuard Module Builder

This builds [WireGuard](https://www.wireguard.com/) modules for various Android kernels.

### Adding your phone's kernel

1. Create a directory in `kernels/` if it doesn't already exist.

2. Add a corresponding `manifest.xml`, with versions based on stable non-moving tags and refs.

3. Add a `do.bash` with minimal commands for conducting the build.

4. Add a `version-hashes.txt` containing the output of `printf '%s|%s\n' "$(sha256sum < /proc/version | cut -d ' ' -f 1)" "$(cat /proc/version)"` from your phone.

Note that if a kernel directory already exists that is compatible (i.e. the module loads and works) with your phone's kernel, simply skip to step 4 and append the line.

### Building

Build all kernels:

```
$ ./build-all.bash
```

Build just one:

```
$ ./build-one.bash crosshatch
```

### Downloading

These are built, signed, and uploaded to [the WireGuard download server](https://download.wireguard.com/android-module/). They can automatically be used by the [WireGuard app](https://play.google.com/store/apps/details?id=com.wireguard.android):

![WireGuard app downloading and inserting kernel module](https://data.zx2c4.com/wireguard-android-download-kernel-module.gif)
