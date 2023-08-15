#FROM golang:1.18-alpine3.15 as builder
FROM registry.ci.openshift.org/stolostron/builder:go1.18-linux AS builder

WORKDIR /workspace

COPY . .

# RUN apk update && apk upgrade && apk add --no-cache alpine-sdk

RUN  make thanos-receive-controller

#FROM scratch
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

COPY --from=builder /workspace/thanos-receive-controller /usr/bin/thanos-receive-controller

RUN microdnf update -y && microdnf clean all

USER 65534

ENTRYPOINT ["/usr/bin/thanos-receive-controller"]
