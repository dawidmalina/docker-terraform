FROM ubuntu:20.04

ENV TF_VERSION=0.13.1 \
    TF_IN_AUTOMATION=true \
    TF_WARN_OUTPUT_ERRORS=1 \
    TF_INPUT=0

RUN set -x \
### Install basic tools
    && apt-get update \
    && apt-get install --no-install-recommends --yes bash curl unzip git-core jq openssh-client python3-pip \
### Install terraform
    && curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/ \
    && rm terraform_${TF_VERSION}_linux_amd64.zip \
### Install terraform addons
    && curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/bin/ \
    && curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip \
    && unzip tflint.zip \
    && rm tflint.zip \
    && mv tflint /usr/bin/ \
    && pip3 install --no-cache-dir checkov \
    && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && /aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm awscliv2.zip \
### Install terraform-module-versions
    # && curl -L "$(curl -s https://api.github.com/repos/keilerkonzept/terraform-module-versions/releases/latest | grep -o -E "https://.+?_linux_x86_64.tar.gz")" > terraform-module-versions.tar.gz \
    && curl -L "$(curl -s https://api.github.com/repos/dawidmalina/terraform-module-versions/releases/latest | grep -o -E "https://.+?_linux_x86_64.tar.gz")" > terraform-module-versions.tar.gz \
    && tar xvf terraform-module-versions.tar.gz \
    && mv terraform-module-versions /usr/bin/ \
    && rm terraform-module-versions.tar.gz \
### Cleanup
    && apt-get purge --yes unzip python3-pip \
    && apt-get install --no-install-recommends --yes python3-minimal \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT ["terraform"]
