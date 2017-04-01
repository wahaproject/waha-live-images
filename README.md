# waha-live-images
WahaLinux live images configuration.

**Build a Custom Waha Linux ISO**
- root access is required

Prepare build environment by installing live-build and its requirements with the following command:
```
apt-get install live-build live-config live-config-systemd live-boot isolinux syslinux-common
```

Clone configuration image:
```
git clone https://github.com/wahaproject/waha-live-images.git
```

Now you can start build with by running build.sh script:
```
cd waha-live-images/images && ./build.sh
```
