FROM golang:1.25 AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app .

FROM debian:bookworm-slim
WORKDIR /srv
COPY --from=build /app /srv/app
COPY --from=build /src/migrations ./migrations
COPY --from=build /src/gundam.db ./gundam.db
CMD ["/srv/app"]
