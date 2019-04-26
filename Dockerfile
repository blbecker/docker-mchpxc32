FROM ubuntu:bionic

MAINTAINER Benjamin Becker <benjamin.becker@athenitas.com>

ENV DEBIAN_FRONTEND noninteractive
ENV COMPILER_VERSION 2.15
ENV PLIB_VERSION 1.40
ENV MPLAB_VERSION 5.15

RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends ca-certificates build-essential \
                                            bzip2 cpio curl python unzip wget \
                                            libc6:i386 libx11-6:i386 libxext6:i386 \
                                            libstdc++6:i386 libexpat1:i386 \
                                            libxext6 libxrender1 libxtst6 libgtk2.0-0 \
                                            libxslt1.1 libncurses5-dev check git

# Download and Install XC32 Compiler
RUN curl -fSL -A "Mozilla/5.0" -o /tmp/mplabxc32linux "http://www.microchip.com/mplabxc32linux" \
    && chmod a+x /tmp/mplabxc32linux \
    && /tmp/mplabxc32linux --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32 \
    && rm /tmp/mplabxc32linux

# Download and Install PLIBS
RUN curl -fSL -A "Mozilla/5.0" -o /tmp/plibs.tar "http://ww1.microchip.com/downloads/en/DeviceDoc/PIC32%20Legacy%20Peripheral%20Libraries%20Linux.tar" \
    && tar xf /tmp/plibs.tar -C /tmp \
    && chmod a+x "/tmp/PIC32 Legacy Peripheral Libraries.run" \
    && "/tmp/PIC32 Legacy Peripheral Libraries.run" --mode unattended --unattendedmodeui none --prefix /opt/microchip/xc32 \
    && rm /tmp/plibs.tar \
    && rm "/tmp/PIC32 Legacy Peripheral Libraries.run"

# Download and Install MPLABX IDE, Current Version
RUN curl -fSL -A "Mozilla/5.0" -o /tmp/mplabx-ide-linux-installer.tar "http://www.microchip.com/mplabx-ide-linux-installer" \
    && tar xf /tmp/mplabx-ide-linux-installer.tar \
    && rm /tmp/mplabx-ide-linux-installer.tar \
    && USER=root ./*-installer.sh --nox11 \
        -- --unattendedmodeui none --mode unattended --installdir /opt/microchip/mplabx/v${MPLAB_VERSION} \
    && rm ./*-installer.sh


ENV PATH $PATH:/opt/microchip/mplabx/mplab_ide/bin
