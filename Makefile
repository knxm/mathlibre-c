ENGINE ?= podman
IMAGE   = mathlibre-c:v0.3
NAME    = mathlibre-c_v0.3
WORKDIR = /work
HOSTNAME = mathlibre

DISPLAY ?= :0
XAUTHORITY ?= $(HOME)/.Xauthority

UNAME_S := $(shell uname -s 2>/dev/null || echo Unknown)

# OSごとの調整
ifeq ($(UNAME_S),Darwin)
        # macOS (XQuartz + Podman machine)
	X11_SOCK = /tmp/.X11-unix
	PLATFORM = --platform=linux/amd64
else
        # Linux / WSL2
	X11_SOCK = /tmp/.X11-unix
	PLATFORM =
endif

RUN_OPTS = -it --rm \
	--name $(NAME) \
	--hostname $(HOSTNAME) \
	--userns=keep-id \
	-u $(shell id -u):$(shell id -g) \
	-e DISPLAY=$(DISPLAY) \
	-e XAUTHORITY=$(XAUTHORITY) \
        -v $(X11_SOCK):/tmp/.X11-unix:ro \
	-v $(PWD):$(WORKDIR):Z \
	-w $(WORKDIR)


# XAUTHORITY が実在する時だけマウント
ifneq ($(wildcard $(XAUTHORITY)),)
	RUN_OPTS += -e XAUTHORITY=$(XAUTHORITY) -v $(XAUTHORITY):$(XAUTHORITY):ro
endif

.PHONY: build run shell stop rm clean size logs

build:
	$(ENGINE) build -t $(IMAGE) .


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

