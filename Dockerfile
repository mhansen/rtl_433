FROM balenalib/raspberrypi3:build
# https://www.balena.io/docs/reference/base-images/base-images/#building-arm-containers-on-x86-machines
RUN [ "cross-build-start" ]
RUN apt-get update && apt-get install -y git libusb-1.0.0-dev librtlsdr-dev rtl-sdr cmake automake

# Copy local code to the container image.
COPY . /tmp/rtl_433

WORKDIR /tmp/rtl_433
RUN mkdir -p build && \
    cd build && \
    cmake ../ && \
    make -j4 rtl_433 && \
    make install && \
    cd / && \
    rm -rf /tmp

# https://www.balena.io/docs/reference/base-images/base-images/#building-arm-containers-on-x86-machines
RUN [ "cross-build-end" ]
