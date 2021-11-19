FROM python:3.7

# Install dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    libatlas-base-dev \
    curl \
    libffi-dev \
    python3-pip

# Create working directory
RUN mkdir -p /cbpi/downloads
WORKDIR /cbpi

# Download installation files
RUN curl https://github.com/avollkopf/craftbeerpi4/archive/master.zip -L -o ./downloads/cbpi.zip && \
    curl https://github.com/avollkopf/craftbeerpi4-ui/archive/main.zip -L -o ./downloads/cbpi-ui.zip

# Install craftbeerpi
RUN pip3 install ./downloads/cbpi.zip
RUN pip3 install ./downloads/cbpi-ui.zip

RUN cbpi setup

RUN rm -rf ./downloads

EXPOSE 8000

CMD ["cbpi", "start"]

