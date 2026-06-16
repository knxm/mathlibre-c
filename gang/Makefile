ENGINE     ?= podman

# -- Target Registry --
REGISTRY   ?= ghcr.io
OWNER      ?= knxm
APP_NAME   ?= gang
TAG        ?= latest
HOSTNAME   ?= mathlibre
IMAGE = $(REGISTRY)/$(OWNER)/$(APP_NAME):$(TAG)
HOST_WORKDIR := $(CURDIR)/work
WORKDIR    := /work

UNAME_S := $(shell uname -s)
UNAME_R := $(shell uname -r)

UID := $(shell id -u)
GID := $(shell id -g)
PWD := $(shell pwd)

PLATFORM ?= linux/amd64

# --- [機能拡張] ソースアーカイブのダウンロードURLの定義 ---
# ※ 実際のアーカイブが置いてある正しいURLに差し替えてください。
GANG_SRC_URL ?= https://web.archive.org/web/20130615154424/http://www.gang.umass.edu/software/download/gangsrc-020918.tar.gz

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
	#--userns=keep-id \
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

run: 
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) openxm asir

shell: 
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) bash

pull:
	$(ENGINE) pull --platform=$(PLATFORM) $(IMAGE)

clean:
	$(ENGINE) rmi $(IMAGE)

size:
	$(ENGINE) image inspect $(IMAGE) | jq '.[0].Size'

# --- [機能拡張] アーカイブが存在しない場合に自動取得するターゲット ---
gangsrc-020918.tar.gz:
	@echo "Source archive not found. Fetching from $(GANG_SRC_URL)..."
	curl -L -o $@ $(GANG_SRC_URL)

# for maintainer
# build ターゲットの依存関係に gangsrc-020918.tar.gz を指定しました
build: gangsrc-020918.tar.gz
	$(ENGINE) build --platform=$(PLATFORM) -t $(IMAGE) .

push:
	$(ENGINE) push $(IMAGE)

