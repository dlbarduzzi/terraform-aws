ARG GO_VERSION=1.22

FROM golang:${GO_VERSION} AS deps
LABEL org.opencontainers.image.source="https://github.com/dlbarduzzi/demo"

WORKDIR /app

COPY go.mod /app/go.mod
COPY go.sum /app/go.sum

RUN go mod download -x

FROM deps AS builder
LABEL org.opencontainers.image.source="https://github.com/dlbarduzzi/demo"

WORKDIR /app
COPY . /app

# Build the application binary file.
RUN CGO_ENABLED=0 go build -o /app/demo /app/cmd/demo

FROM debian:bullseye-slim AS runner
LABEL org.opencontainers.image.source="https://github.com/dlbarduzzi/demo"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

RUN groupadd --gid 1001 nonroot \
    && useradd --create-home --system --uid 1001 --gid 1001 nonroot

USER nonroot
WORKDIR /app

COPY --from=builder --chown=nonroot:nonroot /app/demo /app/demo

EXPOSE 8000

ENTRYPOINT ["/app/demo"]
