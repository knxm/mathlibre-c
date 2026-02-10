ENGINE     ?= podman
REGISTRY   ?= ghcr.io
OWNER      ?= knxm
NAME       ?= openxm
TAG        ?= latest
HOSTNAME   ?= mathlibre
WORKDIR    ?= /work

IMAGE ?= $(REGISTRY)/$(OWNER)/$(NAME):$(TAG)

UNAME_S := $(shell uname -s)
UNAME_R := $(shell uname -r)

UID := $(shell id -u)
GID := $(shell id -g)
PWD := $(shell pwd)

PLATFORM ?= linux/amd64

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
	--name $(NAME) \
	--hostname $(HOSTNAME) \
	--userns=keep-id \
	--platform=$(PLATFORM) \
	-u $(UID):$(GID) \
	-e DISPLAY=$(X11_DISPLAY) \
	$(XAUTH) \
	$(XVOL) \
	$(XAUTHVOL) \
	-v $(PWD):$(WORKDIR):Z \
	-w $(WORKDIR)

# ------------------------
# targets
# ------------------------
.PHONY: build run shell stop rm clean size logs

build:
	$(ENGINE) build --platform=$(PLATFORM) -t $(IMAGE) .

pull:
	$(ENGINE) pull --platform=$(PLATFORM) $(IMAGE)

run:
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) openxm fep asir

shell:
	$(ENGINE) run $(RUN_OPTS) $(IMAGE) bash

stop:
	$(ENGINE) stop $(NAME)

rm:
	$(ENGINE) rm $(NAME)

clean:
	$(ENGINE) rmi $(IMAGE)

size:
	$(ENGINE) image inspect $(IMAGE) | jq '.[0].Size'

logs:
	$(ENGINE) logs $(NAME)
