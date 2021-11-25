# Docker image for CraftBeerPi 4

This is a docker image for the CraftBeerPi 4. It is built by using the
installation instructions from here:
https://openbrewing.gitbook.io/craftbeerpi4_support/master/server-installation

## Build
This image is only published for arm64 and amd64 architectures.
I could not get it to build for arm/v7. You can try to build it yourself.
You can do this directly on your raspberry to get an arm image.

```bash
docker build . -t papauorg/craftbeerpi4:dev
```

## Usage

The image contains an already created config directory. But to be able
to recreate the container without loosing the configuration you should
create a config folder on the host (or volume) and use it when starting
the container. You only have to do this once to initialize your configs.

The group (with gid 1000) that runs craftbeerpi in the container
needs write permissions to the config directory.
```bash
mkdir config && chown :1000 config
docker run --rm -v "$(pwd)/config:/cbpi/config" ghcr.io/papauorg/craftbeerpi4:latest cbpi setup
```

After creating the configs you can then start the docker container. In this sample the
raspberries gpiomem device is passed to the container so it can make use of the gpio pins.
See: https://stackoverflow.com/questions/30059784/docker-access-to-raspberry-pi-gpio-pins
**Attention**: I did not test GPIO functionality with this image I can't say for sure that this
works.

```bash
docker run -d -v "$(pwd)/config:/cbpi/config" -p 8000:8000 --device /dev/gpiomem ghcr.io/papauorg/craftbeerpi4:latest
```

### docker-compose
```yml
version: "3.7"
services:
    craftbeerpi:
        image: ghcr.io/papauorg/craftbeerpi4:latest
        volumes:
            - "./config:/cbpi/config"
        ports:
            - 8000:8000
        devices:
            - "/dev/gpiomem:/dev/gpiomem"
```
