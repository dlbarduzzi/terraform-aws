config/init:
	docker compose --project-directory ./infra run --rm terraform -chdir=config init

config/fmt:
	docker compose --project-directory ./infra run --rm terraform -chdir=config fmt

config/validate:
	docker compose --project-directory ./infra run --rm terraform -chdir=config validate

config/apply:
	docker compose --project-directory ./infra run --rm terraform -chdir=config apply
