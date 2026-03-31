# MathLibre-c

[(English)](./README.md)

MathLibre-c は数学ソフトウェア環境のためのコンテナを開発するプロジェクトです．

Windowsユーザは WSL2 をインストールすることで Linux 環境を構築できます．macOSユーザは Homebrew をインストールすることで Unix のツール群をパッケージで利用できます．

コンテナを利用するためには make git podman の3つのパッケージを
Linux(Unix)環境にインストールしてください．

以後，make コマンドだけで Risa/Asir(OpenXM)を利用できます．

## コンテナの説明
- mathlibre-c
 - 標準環境 amd64 debパッケージ，コンテナサイズ859MB
- mathlibre-c/openxm_from_git
 - amd64/arm64 対応 github からのソースビルド，コンテナサイズ3.92GB
- mathlibre-c/openxm_arch（実験版）
 - amd64 github からのソースビルド，コンテナサイズ5.02GB
- mathlibre-c/openxm_sage（実験版）
 - amd64 debパッケージ，sagemathコンテナに追加，コンテナサイズ4.22GB

## 必要な環境

- Linux + X11 + make + git + podman
- Linux + Wayland + XWayland + make + git + podman
- Windows + WSL2 + make + git + podman
- macOS + Homebrew + qemu + Xquartz + make + git + podman

のどれか

### Linux

パッケージ make, git, podman のインストール

```
sudo apt install make git podman
```

もしくは

```
sudo dnf install make git podman
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
brew install make git podman
```

3. イメージはamd64なので，M1〜M5等のArm系CPUの場合はqemuが必要．IntelMacは必要なし．

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

## コンテナの内容

主に収録されているソフトウェアは

- openxm (Risa/Asir)
- vim-tiny

## Risa/Asir の利用

`make`もしくは`make run`を実行後に OpenXM プロンプト

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
openxm asir
```

Risa/Asir の終了は

```
quit;
```

shellの終了は

```
exit
```

## コンテナイメージの取得

```
make pull
```

## コンテナイメージの削除

コンテナイメージは ~/.local 内に展開されます．
以下の命令でコンテナイメージを削除できます．
```
make clean
```

## コンテナイメージのビルド（開発者向け）

パッケージを追加したいときはContainerfileを編集後，
コンテナイメージをビルドしてカスタマイズしてください．

```
make build
```

## 注意点
- コンテナ名称をopenxmに変更
- ホスト側のエディタで作業したいときは `make`
- コンテナの shell を利用したいときは `make shell`
- イメージファイルは展開すると約860MB
- 作業場所として work ディレクトリが用意されています．	
- root にはなれません．
- パッケージを追加したいときは Containerfile に追加して `make build` で自分だけのコンテナイメージをビルドすることも可能です．

## Reference

- [コンテナーの構築、実行、および管理 (docs.redhat.com)](https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index)
