#!make

include .env
export

MAKEFLAGS += --always-make

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

_env:
ifeq ($(wildcard .env),)
	cp .env.dist .env
endif

########################################################################################################################

owner: ## Reset folder owner
	sudo chown --changes -R $$(whoami) ./
	@echo "Success"

check-conflicts: ## Find git conflicts
	@if grep -rn '^<<<\<<<< ' .; then exit 1; fi
	@if grep -rn '^===\====$$' .; then exit 1; fi
	@if grep -rn '^>>>\>>>> ' .; then exit 1; fi
	@echo "All is OK"

check-todos: ## Find TODO's
	@if grep -rn '@TO\DO:' .; then exit 1; fi
	@echo "All is OK"

check-master: ## Check for latest master in current branch
	@git remote update
	@if ! git log --pretty=format:'%H' | grep $$(git log --pretty=format:'%H' -n 1 origin/master) > /dev/null; then exit 1; fi
	@echo "All is OK"

images: _env ## Create a proxy image
	env
	docker build tor --tag $(EGND_TOR_IMAGE)$(IMG_VERSION)
	docker build privoxy --tag $(EGND_PRIVOXY_IMAGE)$(IMG_VERSION)

push: images ## Create a proxy image
	docker push $(EGND_TOR_IMAGE)$(IMG_VERSION)
	docker push $(EGND_PRIVOXY_IMAGE)$(IMG_VERSION)

scan: images  ## Scan proxy image for vulnerabilities
	docker scan --dependency-tree --severity=high $(EGND_TOR_IMAGE)
	docker scan --dependency-tree --severity=high $(EGND_PRIVOXY_IMAGE)

lint: ## Validate Dockerfile
	docker run --rm -i ghcr.io/hadolint/hadolint:latest-alpine < tor/Dockerfile
	docker run --rm -i ghcr.io/hadolint/hadolint:latest-alpine < privoxy/Dockerfile

compose: compose-stop ## Run services
ifeq ($(wildcard docker-compose.override.yml),)
	ln -s docker-compose.build.yml docker-compose.override.yml
endif
	docker-compose up --build --abort-on-container-exit --renew-anon-volumes

compose-stop: _env ## Stop services
	docker-compose down --remove-orphans --volumes
