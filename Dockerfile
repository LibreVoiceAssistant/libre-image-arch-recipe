FROM manjarolinux/base:latest

RUN pacman --noconfirm -Syu wget

RUN mkdir /build && \
    cd /build && \
    wget http://downloads.openvoiceos.com/Manjaro-ARM-minimal-rpi4-22.08.img.gz

RUN pacman --noconfirm -Syu sudo manjaro-arm-qemu-static xz git gzip lsof psmisc python python-pip manjaro-tools-base-git

RUN pip install pytz requests

COPY docker_overlay/ /
RUN chmod ugo+x -R /scripts/
RUN chmod ugo+x -R /overlays/

RUN mkdir -p /build
RUN mkdir -p /output

ENV OUTPUT_DIR=/output
ENV BUILD_DIR=/build

CMD ["/scripts/install_and_build.sh"]
