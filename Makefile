.PHONY: help ps build build-prod start fresh fresh-prod stop restart destroy \
	cache cache-clear migrate migrate migrate-fresh tests tests-html

CONTAINER_PHP=api
CONTAINER_REDIS=redis
CONTAINER_DATABASE=database

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

auth: # authenticate with AWS ECR
	aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 608900566080.dkr.ecr.ap-southeast-1.amazonaws.com

build-push:
	make build
	make push

build: #build base image
	docker build -t my-laravel-base-image .

push: # puth the base image
	docker tag my-laravel-base-image:latest 608900566080.dkr.ecr.ap-southeast-1.amazonaws.com/my-laravel-base-image:latest
	docker push 608900566080.dkr.ecr.ap-southeast-1.amazonaws.com/my-laravel-base-image:latest