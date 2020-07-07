FROM ubuntu:18.04

RUN apt update && apt install -y \
    wget git \
    build-essential autoconf libtool pkg-config \
    libssl-dev

RUN wget -q -O cmake-linux.sh \
    https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh && \
    sh cmake-linux.sh -- --skip-license --prefix=/usr && \
    rm cmake-linux.sh

ENV GRPC_RELEASE_TAG v1.30.0

RUN git clone --recurse-submodules -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc && \
    mkdir -p /grpc/cmake/build && cd /grpc/cmake/build && \
    cmake -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/usr \
    ../.. && \
    make -j4 && make install && \
    rm -r /grpc && \
    rm -r /var/lib/apt/lists/*
