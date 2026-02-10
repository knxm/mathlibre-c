# MathLibre-c

[(English)](./README.md)

MathLibre-c は数学ソフトウェア環境のためのコンテナを開発するプロジェクトです．

## 必要な環境

- Linux + X11 + git + podman
- Linux + Wayland + XWayland + git + podman
- Windows + WSL2 + git + podman
- macOS + Homebrew + qemu + git + podman

のどれか

### Linux

パッケージ git, podman のインストール

```
apt install git podman
```

もしくは

```
dnf install git podman
```

など

### Windows

1. [WSL2のインストール/Microsoft](https://learn.microsoft.com/ja-jp/windows/wsl/install)

- PowerShell 上で実行

```
wsl --install
```

2. WSL2 を起動後はLinuxと同様

### macOS

1. [Homebrewのインストール/Homebrew](https://brew.sh/)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. git, podman のインストール

```
brew install git podman
```

3. イメージはamd64なので，M?等のArm系CPUの場合はqemuが必要．IntelMacは必要なし．

```
brew install qemu
```

4. Xのインストール

```
brew install --cask xquartz
```

5. macOSの場合だけ，podman 利用にあたって，最初だけ machine (macOS用Linux) を用意する必要がある．

```
podman machine init
```

```
podman machine start
```

6. XQuartzの実行

```
open -a xquartz
```

7. Xを用いる際は xhost の接続許可が必要

```
xhost +localhost
```

## mathlibre-c の取得

```bash
git clone https://github.com/knxm/mathlibre-c
```

## ディレクトリ mathlibre-c への移動

```
cd mathlibre-c
```

## コンテナの取得

```
make pull
```

## コンテナの内容

主に収録されているソフトウェアは

- openxm (Risa/Asir)
- vim-tiny

## Risa/Asir の利用

`make run`を実行後に OpenXM プロンプト

```
OpenXM/Risa/Asir-Contrib $Revision$ (20250117), Copyright 2000-2025, OpenXM.org committers
helph(); [html help], ox_help(0); ox_help("keyword"); ox_grep("keyword");
     for help messages (unix version only).
http://www.math.kobe-u.ac.jp/OpenXM/Current/doc/index-doc.html
[2113] 
```

が表示されたら Risa/Asir の命令を入力できる．
コンテナの終了は Risa/Asir の終了命令

```
quit;
```

## shell の利用

`make shell`を実行後に bash プロンプト

```
user@mathlibre:/work$ 
```

が表示される．

Risa/Asir を起動するには

```
openxm fep asir
```

Risa/Asir の終了は

```
quit;
```

shellの終了は

```
exit
```

## コンテナのビルド

パッケージを追加したいときはコンテナイメージをビルドしてカスタマイズしてください．

```
make build
```

## 注意点
- コンテナ名称をopenxmに変更
- 最初に `make pull` でコンテナイメージを ghcr.io から取得
- ホスト側のエディタで作業したいときは `make run`
- コンテナの shell を利用したいときは `make shell`
- イメージファイルは展開すると約860MB
- 現状では作業場所 work は `make run` もしくは `make shell` したディレクトリ
- root にはなれない．
- パッケージを追加したいときは Containerfile に追加して `make build`

## Reference

- [コンテナーの構築、実行、および管理 (docs.redhat.com)](https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index)
