MathLibre-c is a project for building containers with mathematical software.

数学ソフトウェア環境のためのコンテナを開発するプロジェクト

# 必要な環境
- Linux + podman
- Windows + WSL2 + podman
- macOS + Homebrew + podman

のどれか

## Linux
### パッケージ podman のインストール
```
apt install podman
```
もしくは
```
yum install podman
``` 
など

## Windows
1. [WSL2のインストール/Microsoft](https://learn.microsoft.com/ja-jp/windows/wsl/install)
2. WSL2 を起動後はLinuxと同様

## macOS
1. [Homebrewのインストール/Homebrew](https://brew.sh/)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2.
```
brew install podman
```

# Reference
Podman : 仮想化コンテナ開発ツール Docker ライクだが，デーモンを必要としない．
https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index

