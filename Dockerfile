FROM golang:1.23-alpine AS builder

WORKDIR /app
RUN apk --no-cache add ca-certificates wget
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
FROM alpine:latest
RUN apk --no-cache add ca-certificates wget

WORKDIR /root/
COPY --from=builder /app/main .

ENV GOOGLE_API_KEY_ENV="<your_api_key_here>"
ENV GOOGLE_CSE_ID_ENV="<your_cse_id_here>"

EXPOSE 8080
ENV PORT=8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

CMD ["./main"]