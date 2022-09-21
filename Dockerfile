FROM python:3.8-slim

RUN apt update && \
    apt install -y wget

RUN mkdir /build && \
    cd /build && \
    wget https://github.com/manjaro-arm/rpi4-images/releases/download/22.08/Manjaro-ARM-minimal-rpi4-22.08.img.xz

RUN apt install -y sudo qemu-user-static xz-utils git

RUN pip install pytz requests

COPY docker_overlay/ /
RUN chmod ugo+x -R /scripts/
RUN chmod ugo+x -R /overlays/

RUN mkdir -p /build
RUN mkdir -p /output

ENV OUTPUT_DIR=/output
ENV BUILD_DIR=/build

CMD ["/scripts/install_and_build.sh"]
