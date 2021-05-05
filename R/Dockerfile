FROM r-base:3.4.4

RUN apt-get update && apt-get install --no-install-recommends --yes \
    libfontconfig1-dev libcairo2-dev python3-pil && apt-get clean

COPY install-packages.R /tmp/install-packages.R
RUN Rscript --file /tmp/install-packages.R

# When python3-gdal is version ≥ 3.2.3, remove use of gdalwarp from
# occ_density.py and remove gdal-bin
RUN apt-get update && apt-get install --no-install-recommends --yes \
    python3-pandas python3-numpy python3-gdal gdal-bin \
    python3-urllib3 python3-requests python3-mapnik \
    && apt-get clean

VOLUME /analytics
WORKDIR /analytics
