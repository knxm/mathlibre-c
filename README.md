# MathLibre-c

[(Japanese)](./README.ja.md)

MathLibre-c is a project for building containers for mathematical software environments.

## Requirements

One of the following environments is required:

- Linux + X11 + git + podman
- Linux + Wayland + XWayland + git + podman
- Windows + WSL2 + git + podman
- macOS + Homebrew + qemu + Xquartz + git + podman

### Linux

Install packages

```bash
apt install git podman
```

or

```bash
dnf install git podman
```

etc.

### Windows

1. [How to install Linux on Windows with WSL/Microsoft](https://learn.microsoft.com/en-us/windows/wsl/install)
   Run the following PowerShell:

```powershell
wsl --install
```

2. After starting WSL2, follow the steps as for Linux

### macOS

1. [Install Homebrew/Homebrew](https://brew.sh/)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install packages

```bash
brew install git podman
```

3. The image is for amd64 noso ARM-based CPUs such as M-series Macs, qemu is required. (Not required on Intel Macs.)

```bash
brew install qemu
```

4. Install X

```bash
brew install --cask xquartz
```

5. On macOS, you need to set up a Podman machine (a Linux VM for macOS) once before using podman:

```bash
podman machine init
podman machine start
```

6. Launch XQuartz

```bash
open -a xquartz
```

7. When using X, you need to allow connections with xhost.

```bash
xhost +localhost
```

## Container contents

The main included software is:

- openxm (Risa/Asir)
- vim-tiny

## Use Risa/Asir

After running `make run`, the OpenXM prompt appears:

```text
OpenXM/Risa/Asir-Contrib $Revision$ (20250117), Copyright 2000-2025, OpenXM.org committers
helph(); [html help], ox_help(0); ox_help("keyword"); ox_grep("keyword");
     for help messages (unix version only).
http://www.math.kobe-u.ac.jp/OpenXM/Current/doc/index-doc.html
[2113] 
```

You can then enter Risa/Asir commands.
To exit the container, use the Risa/Asir exit command:

```asir
quit;
```

## Use the shell

After running `make shell`, the bash prompt appears:
```text
user@mathlibre:/work$ 
```

To start Risa/Asir:
```bash
openxm fep asir
```

To exit Risa/Asir:
```asir
quit;
```

To exit the shell:
```bash
exit
```

## Get the container image
```bash
make pull
```

## Build the container image

For adding packages, edit Containerfile and rebuild it.
```bash
make build
```

## Notes

- The container name has been changed to openxm.
- Use `make run` if you want to work with an editor on the host side.
- Use `make shell` if you want to use the container’s shell.
- The image size is about 860 MB when unpacked.
- Currently, the working directory work is the directory where `make run` or `make shell` is executed.
- You cannot become root inside the container.
- To add packages, edit the Containerfile and run `make build`.

## Reference

- [Building, running, and managing containers (docs.redhat.com)](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index)
