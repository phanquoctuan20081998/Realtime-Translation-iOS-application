# reference: https://hub.docker.com/_/ubuntu/
FROM ubuntu:latest

# Adds metadata to the image as a key value pair example LABEL version="1.0"
LABEL maintainer="Phan Quoc Tuan <phanquoctuan20081998@gmail.com>"

##Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    build-essential \
    byobu \
    curl \
    git-core \
    pkg-config \
    python3-dev \
    python3-pip \
    unzip \
    && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Commands to run when the generated image gets launched.
CMD [ "top" ]
CMD ["ls", "-l"]

#Setup File System
RUN mkdir ds
ENV HOME=/ds
ENV SHELL=/bin/bash
VOLUME /ds
WORKDIR /ds


# Run the shell
CMD  ["/Server/APIServer.py"]