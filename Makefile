config/init:
	docker compose --project-directory ./infra run --rm terraform -chdir=config init
