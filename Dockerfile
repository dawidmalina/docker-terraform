FROM alpine:3.11

ENV TF_VERSION=0.12.25 \
    TF_IN_AUTOMATION=true \
    TF_WARN_OUTPUT_ERRORS=1 \
    TF_INPUT=0

RUN set -x \
### Install basic tools
    && apk add --no-cache bash curl unzip git \
### Install terraform
    && curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/ \
    && rm terraform_${TF_VERSION}_linux_amd64.zip \
### Install terraform addons
    && curl -L "$(curl -s https://api.github.com/repos/segmentio/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/bin/ \
    && curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip \
    && unzip tflint.zip \
    && rm tflint.zip \
    && mv tflint /usr/bin/

ENTRYPOINT ["terraform"]
