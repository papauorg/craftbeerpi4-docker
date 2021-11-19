FROM alpine:latest as download
RUN apk --no-cache add curl && mkdir /downloads
# Download installation files
RUN curl https://github.com/avollkopf/craftbeerpi4/archive/master.zip -L -o ./downloads/cbpi.zip && \
    curl https://github.com/avollkopf/craftbeerpi4-ui/archive/main.zip -L -o ./downloads/cbpi-ui.zip

FROM python:3.7

# Install dependencies
RUN     apt-get update \
    &&  apt-get upgrade -y
RUN apt-get install --no-install-recommends -y \
    libatlas-base-dev \
    libffi-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /cbpi
# Create non-root user working directory
RUN groupadd -g 1000 -r craftbeerpi \
    && useradd -u 1000 -r -s /bin/false -g craftbeerpi craftbeerpi \
    && chown craftbeerpi:craftbeerpi /cbpi

# Install craftbeerpi
COPY --from=download /downloads /downloads
RUN pip3 install --no-cache-dir /downloads/cbpi.zip
RUN pip3 install --no-cache-dir /downloads/cbpi-ui.zip
RUN rm -rf /downloads

USER craftbeerpi

RUN cbpi setup

EXPOSE 8000

# Start cbpi
CMD ["cbpi", "start"]

