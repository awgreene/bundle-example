FROM quay.io/operator-framework/upstream-registry-builder AS builder

FROM scratch
LABEL operators.operatorframework.io.index.database.v1=./index.db
COPY database ./
COPY --from=builder /build/bin/registry-server /registry-server
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
EXPOSE 50051
ENTRYPOINT ["/registry-server"]
CMD ["--database", "index.db"]