FROM balenalib/raspberrypi3:build as builder
# https://www.balena.io/docs/reference/base-images/base-images/#building-arm-containers-on-x86-machines
RUN [ "cross-build-start" ]
RUN apt-get update && apt-get install -y git libusb-1.0.0-dev librtlsdr-dev rtl-sdr cmake automake

# Copy local code to the container image.
COPY . /tmp/rtl_433

WORKDIR /tmp/rtl_433
RUN mkdir -p build && \
    cd build && \
    cmake ../ && \
    make -j4 && \
    make install && \
    cd / && \
    rm -rf /tmp

# https://www.balena.io/docs/reference/base-images/base-images/#building-arm-containers-on-x86-machines
RUN [ "cross-build-end" ]

# Throw away the builder and put it into a 'run' dir. 62MB not 250MB+
FROM balenalib/raspberrypi3:run
COPY --from=builder /usr/local/bin/rtl_433 /usr/local/bin/rtl_433
ENTRYPOINT ["/usr/local/bin/rtl_433"]
