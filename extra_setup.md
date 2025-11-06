# Extra Setups For My Thinkpad T480s

## auto-cpufreq

- Download & install the auto-cpufreq package (from aur if you're on arch base distro).

- Add the run script for auto-cpufreq service in `/etc/runit/sv` directory:

  ```#!/bin/sh
  exec /usr/bin/auto-cpufreq --daemon
  ```

## thinkfan

- Download & install the thinkfan package (from aur if you're on arch base distro).

- Add the run script for thinkfan service in `/etc/runit/sv` directory:

  ```#!/bin/sh
  exec /usr/bin/thinkfan -n -c /etc/thinkfan.conf
  ```

- Setup the config in `/etc/thinkfan.conf`:

  ```
  sensors:
    - hwmon: /sys/class/hwmon
      name: coretemp
      indices: [1,2,3,4,5]
    - hwmon: /sys/class/hwmon
      name: thinkpad
      indices: [1,3,4,5,6,7,8]
    - hwmon: /sys/class/hwmon
      name: nvme
      indices: [1,2]
    - hwmon: /sys/class/hwmon
      name: acpitz
      indices: [1]

  fans:
    - tpacpi: /proc/acpi/ibm/fan

  levels:
    - [0, 0, 45]
    - [1, 45, 47]
    - [2, 47, 50]
    - [3, 50, 53]
    - [4, 53, 55]
    - [5, 55, 60]
    - [6, 60, 65]
    - [7, 65, 32767]
  ```

## grub config

- In `/etc/default/grub`:
  ```
  GRUB_TIMEOUT=1
  GRUB_CMDLINE_LINUX_DEFAULT="loglevel=1 nowatchdog quiet udev.log_level=1 thinkpad_acpi.fan_control=1"
  ```
- Run `grub-mkconfig -o /boot/grub/grub.cfg`

## touchpad config

- In `/etc/X11/xorg.conf.d/30-touchpad.conf`:
  ```
  Section "InputClass"
      Identifier "touchpad"
      Driver "libinput"
      MatchIsTouchpad "on"
      Option "Tapping" "on"
      Option "AccelProfile" "adaptive"
      Option "AccelSpeed" "-0.1"
      Option "NaturalScrolling" "false"
      Option "DisableWhileTyping" "true"
  EndSection
  ```

## resolv.conf

- In `/etc/NetworkManager/conf.d/90-dns-none.conf`:
  ```
  [main]
  dns=none
  ```
- Make the `/etc/resolv.conf` unwritable with `chattr +i`

## tty login

- In `/etc/runit/sv/agetty-tty1/run`:
  ```
  exec setsid ${GETTY} --noclear -o '-p -- entropy' --skip-login ${GETTY_ARGS} \
  "${tty}" "${BAUD_RATE}" "${TERM_NAME}"
  ```
