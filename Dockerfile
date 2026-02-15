FROM golang:1.24-alpine AS build-env

# Build phase
RUN apk add build-base git

ADD ./ /workspace/eclipso
WORKDIR /workspace/eclipso

RUN make build

# Lightweight runtime image
FROM alpine
WORKDIR /workspace/eclipso
RUN apk add ca-certificates
COPY --from=build-env /workspace/eclipso/bin/ /workspace/eclipso/bin/

# DNS ports: UDP, TCP, DoT
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 853/tcp

ENTRYPOINT ["/workspace/eclipso/bin/eclipso"]
