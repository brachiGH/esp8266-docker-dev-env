FROM ubuntu:25.04

LABEL version="1.0"
LABEL maintainer="BrachiGH <https://github.com/brachiGH>"

ARG USER=esp8266

RUN apt-get update && apt-get install -y \
        build-essential git wget curl unzip sudo sed \
        libncurses-dev flex bison gperf libusb-0.1-4 \
        python3 python-is-python3 python3-pip python3-setuptools \
        python3-cryptography python3-serial cmake \
        gcc g++ nano neovim zsh \ 
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd -g 1001 -r $USER
RUN useradd -u 1001 -g 1001 --create-home -r $USER

#Change password
RUN echo "$USER:$USER" | chpasswd

#Make sudo passwordless
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER

RUN mkdir ~/esp && cd ~/esp && git clone https://github.com/espressif/ESP8266_RTOS_SDK.git

ENV IDF_PATH=/home/$USER/esp/ESP8266_RTOS_SDK

RUN mkdir /projects
VOLUME /projects
RUN chown $USER:$USER /projects

USER $USER

WORKDIR /projects


RUN touch ~/.zshrc && \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

CMD ["zsh"]