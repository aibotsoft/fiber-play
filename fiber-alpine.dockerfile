FROM golang:1-alpine as builder

RUN apk --no-cache --no-progress add git ca-certificates tzdata make \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

WORKDIR /go/src/fiber

# Download go modules
COPY ./src/go.mod .
#COPY ./src/go.sum .
RUN GO111MODULE=on GOPROXY=https://proxy.golang.org go mod download

COPY ./src .
RUN CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o server

FROM scratch

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/fiber .

ENTRYPOINT ["/server"]
EXPOSE 80