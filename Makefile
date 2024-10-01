app/run:
	@go run ./cmd/demo

app/lint:
	@golangci-lint run -c ./.golangci.yaml ./...

app/test:
	@go test ./... --cover --coverprofile=coverage.out

app/test/report: test
	@go tool cover -html=coverage.out

app/docker/run:
	@docker compose up

app/docker/build:
	@docker compose up --build

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
