FROM r-base:3.4.4

RUN apt update && apt install -y libfontconfig1-dev libcairo2-dev && apt clean

COPY install-packages.R /tmp/install-packages.R
RUN Rscript --file /tmp/install-packages.R

VOLUME /analytics
WORKDIR /analytics
