FROM ubuntu:bionic

# Note: zipp and venusian are deps that don't support python2 any more.

RUN apt-get update \
  && apt-get install -y \
    python3-pip \
    git \
 && pip3 install \
      devpi-client \
      devpi-server \
      devpi-web \
      zipp==1.1.1 \
      venusian==1.2.0 \
  && pip3 install more-itertools==5.0.0 \
  && mkdir -p /devpi  /etc/breqwatr


ENV \
  PORT='3141' \
  HOST='0.0.0.0' \
  DEVPI_PASSWORD='BREQwatr' \
  DEVPI_SERVERDIR='/devpi'
#
## NOTE: Devpi will always run with serverdir=/devpi

COPY image-files/start.sh /start.sh
COPY image-files/packages /etc/breqwatr/packages

# download the packages
RUN devpi-server --start --host 127.0.0.1 --port 3141 --init \
 && devpi use http://localhost:3141 \
 && devpi login root --password='' \
 && devpi index -c core bases=root/pypi \
 && devpi use root/core \
 && mkdir -p /deleteme \
 && cat /etc/breqwatr/packages | while read package; do \
      echo "Downloading package: $package"; \
      pip3 download -d /deleteme/ --trusted-host 127.0.0.1 -i http://127.0.0.1:3141/root/core/+simple/ $package; \
    done \
 && devpi-server --stop \
 && rm -rf /deleteme

# start will configure the users password
CMD /start.sh

