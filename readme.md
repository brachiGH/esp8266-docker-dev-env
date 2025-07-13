# ESP8266 Docker Development Environment

Containerized development environment for the ESP8266, using the official Espressif ESP8266 RTOS SDK.

## How to Use

### 1. Build the Docker Image

This command will create an image named `esp8266-dev-env`.

```bash
docker build -t esp8266-dev-env .
```

### 2. Run the Docker Container

Once the image is built, you can run a container. You need to mount your local project directory into the `/projects` directory inside the container. This allows you to edit files on your host machine and compile them inside the container.

You also need to pass your ESP8266 device (e.g., `/dev/ttyUSB0`) to the container to flash the firmware.

#### Option A: Mount a specific project path

Replace `<PATH_TO_YOUR_OWN_PROJECT>` with the absolute path to your project directory.

```bash
docker run -it --rm \
--device=/dev/ttyUSB0 \
-v <PATH_TO_YOUR_OWN_PROJECT>:/projects \
esp8266-dev-env
```

#### Option B: Mount the current working directory

This is useful if you are working on a project in your current terminal session. It mounts the directory you are in (`$(pwd)`) to the `/projects` directory in the container.

```bash
docker run -it --rm \
--device=/dev/ttyUSB0 \
-v "$(pwd)":/projects \
esp8266-dev-env
```
## Flash and run RTOS examples

You can find examples in (the offical esp8266 rtos sdk)[https://github.com/espressif/ESP8266_RTOS_SDK/tree/master/examples], which you can flash using the `flashnow` command. But fist configuring the Project using `make menuconfig`

```bash
flashnow
make menuconfig
```

> note:
>  - `flashnow` is an aleas for `make -j4 app-flash monitor`
>  - `Ctrl + ]` Exit the monitoring program
>  - To find information on your esp configuration you can install `esptool` using `python -m pip install esptool` and run `esptool chip-id ` then look up your Chip type datasheet.
