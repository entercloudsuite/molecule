FROM ubuntu:latest

RUN apt-get update && apt-get install -y python python-pip \
    libssl-dev libffi-dev rsync openssh-client zip curl jq tree git \
    python-openstackclient \
    apt-transport-https \
    ca-certificates \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce

RUN apt-get clean && rm -rf /var/lib/apt/lists

COPY requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt

# Fix https://github.com/metacloud/molecule/issues/972
RUN apt-get --auto-remove --yes remove python-openssl
RUN pip install pyOpenSSL

ENTRYPOINT ["/bin/bash"]