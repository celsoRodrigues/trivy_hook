# syntax=docker/dockerfile:1

# Build the application from source
FROM golang:1.22.1 AS build-stage

WORKDIR /app

COPY *.go ./

COPY go.* ./
RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o /server


# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS build-release-stage

COPY --from=build-stage /server /server

EXPOSE 8000

USER nonroot:nonroot

ENTRYPOINT ["/server"]
