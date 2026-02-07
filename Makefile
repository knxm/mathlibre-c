ENGINE ?= podman
IMAGE   = openxm:v0.1
NAME    = openxm_v0.1
WORKDIR = /work
HOSTNAME = mathlibre
PLATFORM ?= linux/amd64

UNAME_S := $(shell uname -s)

# OSの判定
ifeq ($(UNAME_S),Linux)
        DISPLAY ?= :0
        XSOCK ?= /tmp/.X11-unix
        XVOL ?= -v $(XSOCK):$(XSOCK):rw
else ifeq ($(UNAME_S),Darwin)
        DISPLAY = host.docker.internal:0
        XSOCK ?=
        XVOL ?=
endif

XAUTHORITY ?= $(HOME)/.Xauthority

UID := $(shell id -u)
GID := $(shell id -g)

RUN_OPTS = -it --rm \
	--name $(NAME) \
	--hostname $(HOSTNAME) \
	--userns=keep-id \
        --platform=$(PLATFORM) \
	-u $(UID):$(GID) \
	-e DISPLAY=$(DISPLAY) \
	-e XAUTHORITY=$(XAUTHORITY) \
        $(XVOL) \
	-v $(PWD):$(WORKDIR):Z \
	-w $(WORKDIR) \


# XAUTHORITY が実在する時だけマウント
#ifneq ($(wildcard $(XAUTHORITY)),)
	RUN_OPTS += -e XAUTHORITY=$(XAUTHORITY) -v $(XAUTHORITY):$(XAUTHORITY):ro
#endif

.PHONY: build run shell stop rm clean size logs

build:
	$(ENGINE) build --platform=$(PLATFORM) -t $(IMAGE) .


run:
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) openxm fep asir

shell:
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) bash

stop:
	-$(ENGINE) stop $(NAME)

rm:
	-$(ENGINE) rm $(NAME)

clean:
	$(ENGINE) rmi $(IMAGE)

size:
	$(ENGINE) image inspect $(IMAGE) | jq '.[0].Size'

logs:
	$(ENGINE) logs $(NAME)

