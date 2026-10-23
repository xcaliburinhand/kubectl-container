FROM proxy.containers.internal/library/alpine:3.24

RUN apk add -U openssl curl jq && \
    curl -L -o /usr/bin/kubectl "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/bin/kubectl && \
    kubectl version --client

ENTRYPOINT ["kubectl"]
CMD ["help"]
