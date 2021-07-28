FROM alpine:3.14

RUN apk add -U openssl curl && \
    curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/bin/kubectl && \
    kubectl version --client

ENTRYPOINT ["kubectl"]
CMD ["help"]
