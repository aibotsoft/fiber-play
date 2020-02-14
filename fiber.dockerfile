FROM golang:1.13 as builder

WORKDIR /fiber

COPY ./src /fiber

#RUN go mod download
RUN go build -o server *.go

CMD ./server
