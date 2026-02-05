FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

USER root

# 基本ツール
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    wget \
    bash \
    locales

RUN wget -qO- https://www.math.kobe-u.ac.jp/deb2/fe-deb2-archive-keyring.gpg \
    | gpg --dearmor -o /usr/share/keyrings/mathkobe.gpg

# 神戸大 Risa/Asir リポジトリの登録
RUN echo "deb [trusted=yes] http://www.math.kobe-u.ac.jp/deb2/ unstable/" \
    > /etc/apt/sources.list.d/asir.list
RUN touch /tmp/i-agree-with-asir-license

# CAS のインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    openxm \
    emacs-nox \
    vim-tiny \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 日本語（任意）
RUN sed -i 's/^# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen
ENV LANG=ja_JP.UTF-8

# 一般ユーザ
RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user
RUN mkdir -p /home/user/work

CMD ["bash"]

