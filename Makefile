ENGINE ?= podman
IMAGE   = mathlibre-c:v0.2
NAME    = mathlibre-c_v0.2
WORKDIR = /work
HOSTNAME = mathlibre

.PHONY: build run shell stop rm clean size logs

build:
	$(ENGINE) build -t $(IMAGE) .

RUN_OPTS = -it --rm \
	--name $(NAME) \
	--hostname $(HOSTNAME) \
	--userns=keep-id \
	-u $(shell id -u):$(shell id -g) \
	-e DISPLAY=$(DISPLAY) \
	-e XAUTHORITY=$(XAUTHORITY) \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-v $(XAUTHORITY):$(XAUTHORITY):ro \
	-v $(PWD):$(WORKDIR):Z \
	-w $(WORKDIR)

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

