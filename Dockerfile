FROM alpine:latest

### Run the following commands as super user (root):
USER root

#######################
### GCC ENVIRONMENT ###
#######################

RUN apk add \
    git \
    zlib-dev \
    wget \
    tar \
    g++ \
    make \
    cmake \
    file \
    bzip2-dev \
    libusb-compat-dev \
    linux-headers \
    which

RUN mkdir code
ADD . /code
WORKDIR code
RUN cmake . -Bbuild
RUN cmake --build build -- -j8

CMD ["/bin/sh"]