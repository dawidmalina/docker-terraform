FROM debian:buster-slim

ENV TF_VERSION=0.14.4 \
    TF_IN_AUTOMATION=true \
    TF_WARN_OUTPUT_ERRORS=1 \
    TF_INPUT=0

RUN set -x \
### Install basic tools
    && apt-get update \
    && apt-get install --no-install-recommends --yes bash curl unzip git-core jq openssh-client python3-pip python3-setuptools \
### Install terraform
    && curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/ \
    && rm terraform_${TF_VERSION}_linux_amd64.zip \
### Install addons :: terraform-docs
    && curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/bin/ \
### Install addons :: tflint
    && curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip \
    && unzip tflint.zip \
    && mv tflint /usr/bin/ \
    && rm tflint.zip \
### Install addons :: infracost
    && curl -L "$(curl -s https://api.github.com/repos/infracost/infracost/releases/latest | grep -o -E "https://.+?-linux-amd64.tar.gz")" > infracost.tar.gz \
    && tar xvf infracost.tar.gz \
    && mv infracost-linux-amd64 /usr/bin/infracost \
    && rm infracost.tar.gz \
### Install addons :: checkov
    && pip3 install --no-cache-dir checkov \
### Install addons :: awscli
    && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && /aws/install -i /usr/local/aws-cli -b /usr/local/bin \
    && rm awscliv2.zip \
### Install addons :: terraform-module-versions
    && curl -L "$(curl -s https://api.github.com/repos/keilerkonzept/terraform-module-versions/releases/latest | grep -o -E "https://.+?_linux_x86_64.tar.gz")" > terraform-module-versions.tar.gz \
    && tar xvf terraform-module-versions.tar.gz \
    && mv terraform-module-versions /usr/bin/ \
    && rm terraform-module-versions.tar.gz \
### Cleanup
    && rm -fv /usr/local/aws-cli/v2/*/dist/aws_completer \
    && rm -fv /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
    && rm -frv /usr/local/aws-cli/v2/*/dist/awscli/examples \
    && rm -frv /usr/share/doc/* \
    && apt-get purge --yes unzip python3-pip \
    && apt-get install --no-install-recommends --yes python3-minimal \
    && apt-get update \
    && apt-get autoremove --yes \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT ["terraform"]
