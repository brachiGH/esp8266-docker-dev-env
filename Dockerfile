FROM ubuntu:22.04

LABEL version="1.0"
LABEL maintainer="BrachiGH <https://github.com/brachiGH>"

# Install dependencies in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential git wget curl unzip tar sudo sed \
        libncurses5-dev libncursesw5-dev flex bison gperf libusb-0.1-4 pkg-config \
        python3 python-is-python3 python3-pip python3-setuptools \
        python3-cryptography python3-serial python3-click \
        python3-future python3-pyelftools \
        cmake gcc g++ nano neovim zsh \
    && pip install "pyparsing>=2.0.3,<2.4.0" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create for a shared the projects directory
VOLUME /projects

# Clone SDK && ESPRESSIF environment install
RUN mkdir /esp
WORKDIR /esp

RUN git clone --recursive https://github.com/espressif/ESP8266_RTOS_SDK.git
ENV IDF_PATH=/esp/ESP8266_RTOS_SDK

ARG XTENSAFILE=xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz
RUN wget https://dl.espressif.com/dl/$XTENSAFILE
RUN tar xzf ./$XTENSAFILE
RUN rm $XTENSAFILE
ENV PATH="/esp/xtensa-lx106-elf/bin:${PATH}"

#Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

WORKDIR /projects
CMD ["zsh"]