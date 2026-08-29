FROM golang:1.24-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /prometheus-exporter

FROM alpine:3.22

RUN apk add --no-cache ca-certificates

COPY --from=build /prometheus-exporter /prometheus-exporter

USER nobody
EXPOSE 9000

ENTRYPOINT ["/prometheus-exporter"]
