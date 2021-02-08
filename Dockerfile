FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

MAINTAINER Thipok Cholsaipant

WORKDIR /

ENV TZ="America/New_York"

# Package and dependency setup
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && apt update \
    && apt install -y git \
    cmake \
    mesa-common-dev \
    libdbus-1-dev \
    

# Git repo set up
RUN git clone https://github.com/no-fee-ethereum-mining/nsfminer.git; \
    cd nsfminer; \
    git checkout tags/v1.3.2; \
    git submodule update --init --recursive

# Build
RUN mkdir build; \
    cd build; \
    cmake .. -DETHASHCUDA=ON -DETHASHCL=OFF -DETHSTRATUM=ON; \
    cmake --build .; \
    make install;

# Env setup
ENV GPU_FORCE_64BIT_PTR=0
ENV GPU_MAX_HEAP_SIZE=100
ENV GPU_USE_SYNC_OBJECTS=1
ENV GPU_MAX_ALLOC_PERCENT=100
ENV GPU_SINGLE_ALLOC_PERCENT=100

ENTRYPOINT ["/usr/local/bin/nsfminer", "-U"]
