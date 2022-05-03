# armbian Clockworkpi DevTerm A06

Current based on [v22.02](https://github.com/armbian/build/tree/042cdbd6a3e157aaaf8b1d81865c78f45dafbbf4) `042cdbd6a3e157aaaf8b1d81865c78f45dafbbf4`

## Spec

- SoC: [RK3399](https://www.rock-chips.com/a/en/products/RK33_Series/2016/0419/758.html)
- RAM: 4GB LPDDR4
- PMIC: [AXP228](http://www.x-powers.com/index.php/Info/product_detail/article_id/31)
- SoC PMIC: [Rockchip RK808](https://rockchip.fr/RK808%20datasheet%20V1.4.pdf)
- Codec: [Everest ES8388](http://www.everest-semi.com/pdf/ES8388%20DS.pdf)
- WiFi / BT Module: [CDW-20U5622-02](https://forum.armbian.com/applications/core/interface/file/attachment.php?id=8205&key=909d40f6587ada0294f3451d3858839b)
- microSD Card / emmc
- microHDMI
- 3x USB2.0

## Project structure

```text
├── config                               Packages repository configurations
│   ├── targets.conf                     Board build target configuration
│   ├── boards                           Board configurations
│   ├── kernel                           Kernel build configurations per family
│   └── sources                          Kernel and u-boot sources locations and scripts
├── packages                             Support scripts, binary blobs, packages
│   └── bsp                              Scripts and configs overlay for rootfs
├── patch                                Collection of patches
│   ├── kernel                           Linux kernel patches
|   |   └── family-branch                Per kernel family and branch
│   ├── misc                             Linux kernel packaging patches
│   └── u-boot                           Universal boot loader patches
|       └── u-boot-rockchip64            For entire kernel family
└── userpatches                          User: configuration patching area
    ├── customize-image.sh               User: script will execute just before closing the image
    └── overlay                          Directory on host is bind-mounted to /tmp/overlay in chroot
```

## Build

Build options:

```bash
./compile.sh  BOARD=clockworkpi-a06 BRANCH=current RELEASE=bullseye BUILD_MINIMAL=no BUILD_DESKTOP=yes KERNEL_ONLY=no KERNEL_CONFIGURE=no DESKTOP_ENVIRONMENT=xfce DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base DESKTOP_APPGROUPS_SELECTED="browsers chat desktop_tools editors internet multimedia office programming remote_desktop" COMPRESS_OUTPUTIMAGE=sha,gpg,img
```

Default build script will build all packages and images:

- Account
  - user: `cpi`
  - password: `cpi`
  - root user password: `root`
- Package:
  - `xfce4-power-manager`
  - `WiringPi`

## Acknoledgements

- [korneliuszo/devterm-printer](https://github.com/korneliuszo/devterm-printer)
- [maxfierke/linux-clockworkpi-a06](https://github.com/maxfierke/linux-clockworkpi-a06)
- [maxfierke/clockworkpi-a06-post-install](https://github.com/maxfierke/clockworkpi-a06-post-install)

## Deps

[apt](https://github.com/libreclockworkpi/packages)
