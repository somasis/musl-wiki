# Building Busybox

busybox makes heavy usage of linux kernel headers, which have a tendency
to clash with userspace. in order to make it build almost "out of the
box", some patches ([1], [2], [3], [4], [5]) are needed
for the kernel headers so that they respect musl's userspace headers in
the same way as glibc's. for convenience, sabotage linux has a
[kernel-headers repo] based on linux 3.12.6 headers for all archs
supported by musl, where those patches are already applied.

note that these headers are "forwards and backwards-compatible"; you
only need newer headers if you need a feature that was added to linux
after 3.12, which cannot be accessed using libc headers.

to compile busybox 1.22.1 allyesconfig, the following config changes are
needed to support musl

```
# CONFIG_EXTRA_COMPAT is not set
# CONFIG_SELINUX is not set
# CONFIG_FEATURE_HAVE_RPC is not set
# CONFIG_WERROR is not set
# CONFIG_FEATURE_SYSTEMD is not set
# CONFIG_FEATURE_VI_REGEX_SEARCH is not set
# CONFIG_PAM is not set
# CONFIG_FEATURE_INETD_RPC is not set
# CONFIG_SELINUXENABLED is not set
# CONFIG_FEATURE_MOUNT_NFS is not set
```

additionally [this patch] for ifplugd is required, if this applet is
desired.

[1]: https://github.com/sabotage-linux/kernel-headers/commit/583dfcafd340ffb749726fa81dcc085b79348bf1
[2]: https://github.com/sabotage-linux/kernel-headers/commit/39ada2dfe837e501eca776f28b7546e742ed9ace
[3]: https://github.com/sabotage-linux/kernel-headers/commit/3cd5b95ad2e9ca7d39e2dffe79f9198a36a0e68e
[4]: https://github.com/sabotage-linux/kernel-headers/commit/4ffbb51f2abfbefa73cbd418f55b20148d04959a
[5]: https://github.com/sabotage-linux/kernel-headers/commit/050805249776a09cfeeb0a43c2b9634e3e8904a5
[kernel-headers repo]: https://github.com/sabotage-linux/kernel-headers
[this patch]: http://lists.busybox.net/pipermail/busybox/2014-January/080391.html
