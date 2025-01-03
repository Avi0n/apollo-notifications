# To build the image, run `docker build` command from the root of the
# repository:
#
#    docker build -f docker/Dockerfile .
#

##
## Create build image
##

# We use an initial docker container to build all of the runtime dependencies,
# then transfer those dependencies to the container we're going to ship,
# before throwing this one away

FROM python:3-slim-bookworm AS build-image
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    gcc \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libxml2-dev \
    libxslt-dev \
    python3-dev \
    python3-venv \
    python3-pip \
    python3-wheel \
    libolm-dev

RUN python3 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Install requirements
COPY requirements.txt .
RUN pip3 install --upgrade pip && pip3 install setuptools wheel && pip3 install -r requirements.txt

##
## Create the runtime container
##

FROM python:3-slim-bookworm
ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8

RUN apt-get update && apt-get install -y python3-venv libolm-dev cron

# Copy venv from build-image
COPY --from=build-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy script and config
WORKDIR /root
COPY notify.py .
COPY config.yaml .

# cron
COPY crontab /etc/cron.d/scriptcron
RUN chmod 0644 /etc/cron.d/scriptcron
RUN crontab /etc/cron.d/scriptcron
RUN touch /var/log/cron.log

# Run cron
CMD [ "cron", "-f" ]
