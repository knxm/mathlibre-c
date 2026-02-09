IMAGE_NAME = sather_v0.2
CONTAINER_NAME = sather_v0.2

build:
	podman build -t $(IMAGE_NAME) -f Containerfile .

run:
	podman run -it --arch i386 --rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

shell:
	podman run -it --rm \
        --arch i386 --name $(CONTAINER_NAME) $(IMAGE_NAME) bash

clean:
	podman rmi $(IMAGE_NAME)
