FROM ubuntu:22.04

LABEL version="1.1"
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

# Clone SDK && install SDK
RUN mkdir /esp
WORKDIR /esp

RUN git clone https://github.com/espressif/ESP8266_RTOS_SDK.git \
    && cd ESP8266_RTOS_SDK \
    && git submodule update --init --recursive
ENV IDF_PATH=/esp/ESP8266_RTOS_SDK
RUN cd ESP8266_RTOS_SDK && git switch release/v3.4 && chmod +x ./install.sh && ./install.sh

# create an entrypoint script.
RUN echo '#!/bin/bash\n. /esp/ESP8266_RTOS_SDK/export.sh\nexec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

#Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
# Custom alias for flashing and monitoring
RUN echo "alias flashnow='idf.py app-flash monitor'\nalias makenow='make -j4 app-flash monitor'" >> /root/.zshrc


WORKDIR /projects
CMD ["zsh"]
