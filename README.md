MathLibre-c is a project for building containers with mathematical software.

数学ソフトウェア環境のためのコンテナを開発するプロジェクト

# 必要な環境
- Linux + podman
- Windows + WSL2 + podman
- macOS + Homebrew + qemu + podman

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
 - PowerShell 上で実行
```
wsl --install
```
2. WSL2 を起動後はLinuxと同様

## macOS
1. [Homebrewのインストール/Homebrew](https://brew.sh/)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2.
```
brew install podman qemu
brew install --cask xquartz
```

3. macOSの場合だけ，podman 利用にあたって，最初だけ machine (macOS用Linux) を用意する必要がある．
```
podman machine init
```
```
podman machine start
```
```
exit
```

# コンテナの構築
```
make build
```

# コンテナの利用
```
make run
```
主に収録されているソフトウェアは
- openxm (Risa/Asir)
- vim-tiny
- nano

終了するときは exit

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
quit();
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
quit();
```

コンテナの終了は
```
exit
```

## 注意点
- 既存のエディタで作業したいときは `make run`
- コンテナの shell を利用したいときは `make shell`
- macOS については未完成です。Xの対応ができていません．
- イメージファイルは展開すると約860MB
- 現状では作業場所 work は `make run` もしくは `make shell` したディレクトリ
- root にはなれない．
- パッケージを追加したいときは Containerfile に追加して `make build`
- Homebrew だと gmake かも（未確認）
- macOS だと build でこける．(qemuで対応）

# Reference
Podman : 仮想化コンテナ開発ツール Docker ライクだが，デーモンを必要としない．
https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index

