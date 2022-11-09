FROM redhat/ubi9-minimal

ARG REPO_ZIP

RUN INSTALL_PKGS="python3 python3-devel python3-setuptools openssl-devel unzip" && \
    microdnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    pip install twisted

WORKDIR /opt/mvn/

ADD ${REPO_ZIP} .
RUN unzip ${REPO_ZIP} && rm ${REPO_ZIP}

WORKDIR /opt/mvn/jboss-eap-8.0.0.Beta-maven-repository/maven-repository

ADD key.pem .
ADD server.pem .
ADD https.py .

EXPOSE 4443

CMD ["python3", "./https.py"]
