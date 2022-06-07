# Software development with Rasperry Pi 4 and Debian 11

Turn your Raspberry Pi 4 into software development server with Debian,
PostgreSQL, RabbitMQ and Docker.

## Justification

The scripts behind this repo are ment to quickly turn your Raspberry Pi into
the development server that has up-to-date software installed and ready to
tinker with. Not worrying you break something.

And although Debian is not my "native" distribution it proves to be easy to
work with and runs smoothly on Rpi, offering an abundance of packages to choose
from.

Included are:

- minimal dotfiles with sane defaults,
- shell scripts (`~/.local/bin`) with useful commands.

Currently (May 2022) the scripts include installation of:

- PostgreSQL 14
- RabbitMQ 3.10
- Erlang/OTP 24.3
- Docker 20.10
- pgAdmin via docker

***Note***: the scripts are not "foolproof", the idea is to quickly get the Rpi
set up and running spending the minimal amount of time on this job. The advice
would be to at least skim through their contents before running them. They work
for me, but they don't have to work for you "as-is".

## Step by step installation

### Flash the SD card with the OS image

Download Debian image from [here](https://raspi.debian.net/tested-images).
Those have:

```shell
$ dpkg --print-architecture
arm64
```

which is useful when it commes to the number of packages available "out there".

Use the instructions from [here](https://raspi.debian.net/how-to-image/)
to flash the SD card with the downloaded image, i.e.:

```shell
$ xzcat 20220121_raspi_4_bullseye.img.xz \
    | doas dd of=/dev/mmcblk0 bs=64k oflag=dsync status=progress
```

Insert the SD card into the Raspberry Pi, power it on and log in as `root`, no
password is required at the beginning.

### Set up wifi

Nano `/etc/network/interfaces.d/wlan0` to read:

```text
allow-hotplug wlan0
iface wlan0 inet dhcp
    wpa-ssid <ssid>
    wpa-psk <password>
```

and `ifup wlan0` (or reboot).

### Run installation and configuration scripts

Install `git` to clone this repo using the following commands:

```shell
# apt update
# apt install -y git
# git clone https://github.com/codcod/rpi-debian.git
```
...and `rpi-run-all`:

```shell
# cd rpi
# ./bin/rpi-run-all
# # or call each script individually:
# ./scripts.d/10-system
# # ...
```

## Tips and useful commands when working with Debian and Rpi

Useful apt commands.

- `apt policy erlang-base` - list available versions of a package
- `apt show rabbitmq-server` - detailed info about a package with dependencies
- `ssh-keygen -R host` - remove entries for a host from known_hosts
- `journalctl -u telegraf.service` - see log entries for the user (has to be in
  `adm` group)

Start and stop pgAdmin (it uses a lot of resources and starts up really slowly).

```shell
$ docker start pgadmin
$ docker stop pgadmin
```

Git configuration:

```shell
$ git config --global user.name "<user>"
$ git config --global user.email "<email>"
```

## Create a file in Bash script with no indentations

To create a file from within a Bash script the following technique is quite
common:

```shell
function create_a_file() {
    cat <<EOF > outfile.txt
    Hello
	World!
EOF
}
```

But doing just so will make the resulting file content indented.

To disable indentation in the output file use `cat <<-EOF`, note the minus
sign. And indent with tabs instead of spaces.

If the file has `et` option set, or `expandtab`, just switch it off and
replace spaces with tabs:

```text
:set noet
:retab!
```

You can use `VISUAL MODE` to choose specific lines that should have spaces
replaced.

