# terraform-aws

### Getting started

Create an s3 bucket. Use all default configurations but enable bucket versioning. Then, create a dynamodb table with a lock id to manage terraform state.

### Initialize terraform

Authenticate user.

```sh
aws-vault exec __username__ duration=1h
```

Initialize terraform configuration files.

```sh
make config/init
make deploy/init
```

### Running the app locally

Using docker compose.

```sh
make app/docker/run
```

Running the app directly.

```sh
make app/run
```

### Helper commands

Print terraform AWS resources data values. This will not print sensitive data.

```sh
docker compose --project-directory ./infra run --rm terraform -chdir=config output
```

Print terraform AWS resources sensitive data values. For this, you need to specify the variable name.

```sh
docker compose --project-directory ./infra run --rm terraform -chdir=config output __VAR_NAME__
```
