ENGINE ?= podman
IMAGE   = mathlibre-c:v0.2
NAME    = mathlibre-c_v0.2
WORKDIR = /work

.PHONY: build run shell stop rm clean size logs

build:
	$(ENGINE) build -t $(IMAGE) .

run:
	$(ENGINE) run -it --rm \
		--name $(NAME) \
                --userns=keep-id \
                -u $(shell id -u):$(shell id -g) \
		-v $(PWD):$(WORKDIR):Z \
		-w $(WORKDIR) \
		$(IMAGE) bash

shell:
	$(ENGINE) exec -it $(NAME) bash

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

