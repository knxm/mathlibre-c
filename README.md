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
brew install podman make
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
- git
- emacs-nox
- vim-tiny

終了するときは exit

## Risa/Asir の利用
`make run`を実行後にプロンプト
```
user@mathlibre:/work$
```
が表示されたら
```openxm fep asir```

## 注意点
- プロンプトの@以降はランダムに生成される？
- イメージファイルは展開すると約1GBの容量 
- 現状では作業場所 work は `make run` したディレクトリ
- root にはなれない．
- パッケージを追加したいときは Containerfile に追加して `make build`


# Reference
Podman : 仮想化コンテナ開発ツール Docker ライクだが，デーモンを必要としない．
https://docs.redhat.com/ja/documentation/red_hat_enterprise_linux/10/html/building_running_and_managing_containers/index

