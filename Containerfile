FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

USER root

# Fundamental tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    wget \
    bash \
    locales

RUN wget -qO- https://www.math.kobe-u.ac.jp/deb2/fe-deb2-archive-keyring.gpg \
    | gpg --dearmor -o /usr/share/keyrings/mathkobe.gpg

# Risa/Asir repository in Kobe University
RUN echo "deb [trusted=yes] http://www.math.kobe-u.ac.jp/deb2/ unstable/" \
    > /etc/apt/sources.list.d/asir.list
RUN touch /tmp/i-agree-with-asir-license

# Install OpenXM
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim-tiny \
    openxm \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# LANG=ja_JP.UTF-8
#RUN sed -i 's/^# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen \
# && locale-gen
#ENV LANG=ja_JP.UTF-8

# Making user
RUN useradd -m -s /bin/bash user
USER user
WORKDIR /home/user
RUN mkdir -p /home/user/work

CMD ["bash"]

