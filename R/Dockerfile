FROM r-base:3.4.4

RUN apt-get update && apt-get install --no-install-recommends --yes libfontconfig1-dev libcairo2-dev python3-pil python3-urllib3 python3-requests && apt-get clean

COPY install-packages.R /tmp/install-packages.R
RUN Rscript --file /tmp/install-packages.R

VOLUME /analytics
WORKDIR /analytics
