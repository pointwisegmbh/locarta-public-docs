DOCKER = docker
REPO = docker.locarta.co
NAME = docs.locarta.co

GIT_VERSION := $(shell git describe --abbrev=7 --dirty --always --tags)

TAG = $(GIT_VERSION) 

build:
	$(DOCKER) build -t $(NAME) .

push:
	$(DOCKER) push $(REPO)/$(NAME):latest
	$(DOCKER) push $(REPO)/$(NAME):$(TAG)

tag:
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):latest
	$(DOCKER) tag $(NAME) $(REPO)/$(NAME):$(TAG)
run:
	$(DOCKER) run --name $(NAME) -d -p 8080:80 $(NAME)
	
stop:	
	$(DOCKER) rm -f $(NAME)

compile:
	mkdocs build --clean

rm_containers:
	$(DOCKER) ps -aq | xargs $(DOCKER) rm || true

rmi_images:
	$(DOCKER) rmi -f $(NAME) $(REPO)/$(NAME):latest $(REPO)/$(NAME):$(TAG) || true

