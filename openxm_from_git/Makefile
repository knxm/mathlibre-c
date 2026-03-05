ENGINE     ?= podman
REGISTRY   ?= ghcr.io
OWNER      ?= knxm
APP_NAME   ?= openxm_from_git
TAG        ?= latest
HOSTNAME   ?= mathlibre
HOST_WORKDIR := $(CURDIR)/work
WORKDIR    := /work

UNAME_S := $(shell uname -s)
UNAME_R := $(shell uname -r)

UID := $(shell id -u)
GID := $(shell id -g)
PWD := $(shell pwd)

# アーキテクチャの自動取得
ARCH := $(shell uname -m)

# ホストのアーキテクチャに応じて PLATFORM を設定
ifeq ($(ARCH),x86_64)
	ARCH_TAB := amd64
	PLATFORM := linux/amd64
else 
# macOS (Apple Silicon) 
	ARCH_TAG := arm64
	PLATFORM := linux/arm64
endif

# デフォルト値を設定（判定に失敗した場合のフォールバック）
PLATFORM ?= linux/amd64
TAG := $(ARCH_TAG)-latest
IMAGE := $(REGISTRY)/$(OWNER)/$(APP_NAME):$(TAG)

# ------------------------
# Initialize X11
# ------------------------
X11_DISPLAY :=
XVOL :=
XAUTH :=
XAUTHVOL :=

# ------------------------
# Linux / WSLg
# ------------------------
ifeq ($(UNAME_S),Linux)
	# WSLg 
	ifneq (,$(findstring microsoft,$(UNAME_R)))
		X11_DISPLAY := :0
		XVOL := -v /tmp/.X11-unix:/tmp/.X11-unix:rw
	else
		# Native Linux
		X11_DISPLAY := :0
		XAUTH := -e XAUTHORITY=$(XAUTHORITY)
		XVOL := -v /tmp/.X11-unix:/tmp/.X11-unix:rw
		XAUTHVOL := -v $(XAUTHORITY):$(XAUTHORITY):ro
	endif
endif

# ------------------------
# macOS + XQuartz
# ------------------------
ifeq ($(UNAME_S),Darwin)
	X11_DISPLAY := host.docker.internal:0
	XVOL :=
endif

# ------------------------
# run options
# ------------------------
RUN_OPTS = \
	-it --rm \
	--name $(APP_NAME) \
	--hostname $(HOSTNAME) \
	--userns=keep-id \
	--platform=$(PLATFORM) \
	-u $(UID):$(GID) \
	-e DISPLAY=$(X11_DISPLAY) \
	$(XAUTH) \
	$(XVOL) \
	$(XAUTHVOL) \
	-v "$(HOST_WORKDIR):$(WORKDIR)" \
	-w $(WORKDIR)

# ------------------------
# targets
# ------------------------
.PHONY: run shell pull clean size build push

run: pull
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) openxm asir

shell: pull
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) bash

pull:
	$(ENGINE) pull --platform=$(PLATFORM) $(IMAGE)

clean:
	$(ENGINE) rmi $(IMAGE)

size:
	$(ENGINE) image inspect $(IMAGE) | jq '.[0].Size'

# for maintainer
build:
	$(ENGINE) build --platform=$(PLATFORM) -t $(IMAGE) .

push:
	$(ENGINE) push $(IMAGE)
