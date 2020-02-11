REPO_HUB = looploy
NAME = nginx
VERSION = 1.17.1
TAGNAME = $(VERSION)
DEBUG_BUILD = no
NGINX_VERSION = $(NAME)-$(VERSION)
#include ENVAR

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	SED_OPTION = 
endif
ifeq ($(UNAME_S),Darwin)
	SED_OPTION = ''
endif

.PHONY: all build push test tag_latest release ssh

all: build docs

test: make_build_args
	echo $(VERSION)

define colorecho
      @tput setaf 6
      @echo $1
      @tput sgr0
endef

NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m
OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)

make_build_args:
	    @$(shell echo "$(OK_COLOR) ----- Build Environment ----- \n $(NO_COLOR)" >&2)\
			$(shell echo "" > BUILD_ARGS) \
				$(foreach V, \
					$(sort $(.VARIABLES)), \
					$(if  \
						$(filter-out environment% default automatic, $(origin $V) ), \
							$($V=$($V)) \
						$(if $(filter-out "SHELL" "%_COLOR" "%_STRING" "MAKE%" "colorecho" ".DEFAULT_GOAL" "CURDIR", "$V" ),  \
							$(shell echo '$(OK_COLOR)  $V=$(WARN_COLOR)$($V) $(NO_COLOR) ' >&2;) \
							$(shell echo "--build-arg $V=$($V)  " >> BUILD_ARGS)\
						)\
					)\
				)


changeconfig:
		@CONTAINER_ID=$(shell docker run -d $(REPO_HUB)/$(NAME):$(TAGNAME)) ;\
		 echo "COPY TO [$$CONTAINER_ID]" ;\
		 docker cp "files/." "$$CONTAINER_ID":/ ;\
		 docker exec -it "$$CONTAINER_ID" sh -c "echo `date +%Y-%m-%d:%H:%M:%S` > /.made_day" ;\
		 echo "COMMIT [$$CONTAINER_ID]" ;\
		 docker commit -m "Change config `date`" "$$CONTAINER_ID" $(REPO_HUB)/$(NAME):$(TAGNAME) ;\
		 echo "STOP [$$CONTAINER_ID]" ;\
		 docker stop "$$CONTAINER_ID" ;\
		 echo "CLEAN UP [$$CONTAINER_ID]" ;\
		 docker rm "$$CONTAINER_ID"

build:  make_build_args
		sed -i $(SED_OPTION) "s/$(REPO_HUB)\/$(NAME).*/$(REPO_HUB)\/$(NAME):$(VERSION)/g" docker-compose_grpc.yml	
		sed -i $(SED_OPTION) "s/$(REPO_HUB)\/$(NAME).*/$(REPO_HUB)\/$(NAME):$(VERSION)/g" docker-compose.yml
		docker build --no-cache --rm=true  $(shell cat BUILD_ARGS)  -t $(REPO_HUB)/$(NAME):$(TAGNAME) .

push:
		# docker tag  $(NAME):$(VERSION) $(REPO)/$(NAME):$(TAGNAME)
		docker push $(REPO_HUB)/$(NAME):$(TAGNAME)

prod:
		docker tag $(REPO_HUB)/$(NAME):$(TAGNAME)  $(REPO_HUB)/$(NAME):$(VERSION)
		docker push $(REPO_HUB)/$(NAME):$(VERSION)

push_hub:
		#docker tag  $(NAME):$(VERSION) $(REPO_HUB)/$(NAME):$(VERSION)
		docker push $(REPO_HUB)/$(NAME):$(TAGNAME)

tag_latest:
		docker tag  $(REPO)/$(NAME):$(TAGNAME) $(REPO)/$(NAME):latest
		docker push $(REPO)/$(NAME):latest

build_hub:
		echo "TRIGGER_KEY" ${TRIGGERKEY}
		git add .
		git commit -m "$(NAME):$(VERSION) by Makefile"
		git tag -a "$(VERSION)" -m "$(VERSION) by Makefile"
		git push origin --tags
		curl -H "Content-Type: application/json" --data '{"build": true,"source_type": "Tag", "source_name": "$(VERSION)"}' -X POST https://registry.hub.docker.com/u/${REPO_HUB}/${NAME}/trigger/${TRIGGERKEY}/

init:
		git init
		git add .
		git commit -m "first commit"
		git remote add origin git@repo.theloop.co.kr:jinwoo/$(NAME).git
		git push -u origin master
bash:
	docker run -e NODE_CONTAINER_NAME=20.20.4.90 -p 9000:9000 -p 7100:7100  -it --rm $(REPO_HUB)/$(NAME):$(TAGNAME) bash

docs:
	@$(shell ./makeMarkDown.sh)
