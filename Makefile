config/init:
	docker compose --project-directory ./infra run --rm terraform -chdir=config init

config/fmt:
	docker compose --project-directory ./infra run --rm terraform -chdir=config fmt

config/validate:
	docker compose --project-directory ./infra run --rm terraform -chdir=config validate

config/apply:
	docker compose --project-directory ./infra run --rm terraform -chdir=config apply

deploy/init:
	docker compose --project-directory ./infra run --rm terraform -chdir=deploy init

deploy/fmt:
	docker compose --project-directory ./infra run --rm terraform -chdir=deploy fmt

deploy/validate:
	docker compose --project-directory ./infra run --rm terraform -chdir=deploy validate
