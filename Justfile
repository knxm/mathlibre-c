# -- Variables --
ENGINE       := "podman"
REGISTRY     := "ghcr.io"
OWNER        := "knxm"
APP_NAME     := "openxm"
TAG          := "latest"
HOSTNAME     := "mathlibre"
IMAGE        := REGISTRY + "/" + OWNER + "/" + APP_NAME + ":" + TAG
WORKDIR      := "/work"
PLATFORM     := "linux/amd64"

# 1. OSの判定
OS           := os()
IS_WINDOWS   := if OS == "windows" { "true" } else { "false" }
IS_MACOS     := if OS == "macos" { "true" } else { "false" }
IS_LINUX     := if OS == "linux" { "true" } else { "false" }

# 2. WSLの判定（論理演算子 && を排除し、Linuxの場合のみ評価）
KERNEL_INFO  := if IS_LINUX == "true" { `uname -r` } else { "" }
IS_WSL       := if IS_LINUX == "true" { if KERNEL_INFO =~ "microsoft" { "true" } else { "false" } } else { "false" }

# 3. ユーザー情報（Windowsなら固定値、Unix系ならコマンド実行）
UID          := if IS_WINDOWS == "true" { "1000" } else { `id -u` }
GID          := if IS_WINDOWS == "true" { "1000" } else { `id -g` }

# 4. ホストのワークディレクトリ
HOST_WORKDIR := if IS_WINDOWS == "true" { "work" } else { env_var_or_default("PWD", ".") + "/work" }

# ------------------------
# Initialize X11 & Options
# ------------------------
X11_DISPLAY := if IS_WSL == "true" { ":0" } else if IS_LINUX == "true" { ":0" } else if IS_MACOS == "true" { "host.docker.internal:0" } else { "" }

XVOL        := if IS_LINUX == "true" { "-v /tmp/.X11-unix:/tmp/.X11-unix:rw" } else { "" }

# XAUTHORITY の処理（&& を使わず、Linux かつ 非WSL の場合のみ値を組み立てる）
XAUTH_VAL   := env_var_or_default("XAUTHORITY", "")
XAUTH       := if IS_LINUX == "true" { if IS_WSL == "false" { if XAUTH_VAL != "" { "-e XAUTHORITY=" + XAUTH_VAL } else { "" } } else { "" } } else { "" }
XAUTHVOL    := if IS_LINUX == "true" { if IS_WSL == "false" { if XAUTH_VAL != "" { "-v " + XAUTH_VAL + ":" + XAUTH_VAL + ":ro" } else { "" } } else { "" } } else { "" }

# 共通の実行オプション
RUN_OPTS    := "-it --rm --name " + APP_NAME + " --hostname " + HOSTNAME + " --userns=keep-id --platform=" + PLATFORM + " -u " + UID + ":" + GID + " -e DISPLAY=" + X11_DISPLAY + " " + XAUTH + " " + XVOL + " " + XAUTHVOL + " -v " + HOST_WORKDIR + ":" + WORKDIR + " -w " + WORKDIR

# ------------------------
# Recipes
# ------------------------

default: run

run:
    {{ENGINE}} run {{RUN_OPTS}} {{IMAGE}} openxm asir

shell:
    {{ENGINE}} run {{RUN_OPTS}} {{IMAGE}} bash

pull:
    {{ENGINE}} pull --platform={{PLATFORM}} {{IMAGE}}

clean:
    {{ENGINE}} rmi {{IMAGE}}

size:
    {{ENGINE}} image inspect {{IMAGE}} | jq '.[0].Size'

build:
    {{ENGINE}} build --platform={{PLATFORM}} -t {{IMAGE}} .

push:
    {{ENGINE}} push {{IMAGE}}
