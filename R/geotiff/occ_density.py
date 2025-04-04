#!/usr/bin/python3
#
# Read 0.1° occurrence density counts from a CSV.  Split by country/gbifRegion etc, and further
# by about/publishedBy, and futher by snapshot.
#
# For each of these create a matrix of 3600×1800 pixels, with the value equal to the density.
#
# Write this as a GeoTIFF.
#

import csv
import numpy as np
import os, sys
import pandas as pd
from osgeo import gdal
from osgeo import osr

sourceDir = "/data/analytics/hadoop"
targetDir = "/data/analytics/report"

image_size = (1800, 3600)

# Extent of our data
lat = [-90,90]
lon = [-180,180]

def writeImage(r_pixels, outputFile):
    # set geotransform
    nx = image_size[1]
    ny = image_size[0]
    xmin, ymin, xmax, ymax = [min(lon), min(lat), max(lon), max(lat)]
    xres = (xmax - xmin) / float(nx)
    yres = (ymax - ymin) / float(ny)
    geotransform = (xmin, xres, 0, ymax, 0, -yres)

    # create the 3-band raster file
    dst_ds = gdal.GetDriverByName('GTiff').Create(outputFile, nx, ny, 1, gdal.GDT_UInt32, options=['COMPRESS=Deflate', 'PREDICTOR=1', 'TILED=YES'])

    dst_ds.SetGeoTransform(geotransform)    # specify coords
    srs = osr.SpatialReference()            # establish encoding
    srs.ImportFromEPSG(4326)                # WGS84 lat/long
    dst_ds.SetProjection(srs.ExportToWkt()) # export coords to file
    dst_ds.GetRasterBand(1).WriteArray(r_pixels)
    dst_ds.FlushCache()                     # write to disk
    dst_ds = None

def extractAreaGeoTIFF(areaType, sourceFile, sourceSchema, targetFile, group, groupLabel):
    inputFile = "/".join([sourceDir, sourceFile])
    print("Reading occurrence density data from", inputFile)
    df = pd.read_csv(inputFile, names=sourceSchema, keep_default_na=False)

    df_grouped = df.groupby(by=group)
    print("Writing group…", end=" ")
    for group in df_grouped.groups:
        print(group, end=" ", flush=True)
        dir = "/".join([targetDir, areaType, group, groupLabel, "geotiff"])
        os.makedirs(dir, exist_ok=True)
        data = df_grouped.get_group(group)

        df_group_snapshot = data.groupby(by='snapshot')
        for group_snapshot in df_group_snapshot.groups:
            snapshot_data = df_group_snapshot.get_group(group_snapshot)

            #  Create Each Channel
            r_pixels = np.zeros((image_size), dtype=np.uint32)

            for row in snapshot_data.itertuples(index=False):
                #print(row)
                (g_snapshot, g_group, latitude, longitude, count) = row

                if (longitude == '\\Nx' or latitude == '\\Nx;'):
                    print("Null row")
                else:

                    # Map longitudes -180.0–179.9 to 0–3599
                    x = 1800 + int(float(longitude)*10)
                    # Map latitudes -90.0–89.9 to 1799–0
                    y = 1800 - 901 - int(float(latitude)*10)

                    if (x < 3600 and y < 1800):
                        count = int(float(count))
                        r_pixels[y,x] = count

                    else:
                        print("Out of range:", group, group_snapshot, longitude, latitude, count, x, y)

            # Output final image
            writeImage(r_pixels, "/".join([dir, targetFile % group_snapshot]))
    print()

def extractGlobalGeoTIFF(sourceFile, sourceSchema, targetFile):
    inputFile = "/".join([sourceDir, sourceFile])
    print("Reading occurrence density data from", inputFile)
    df = pd.read_csv(inputFile, names=sourceSchema, keep_default_na=False)

    df_grouped = df.groupby(by='snapshot')
    print("Writing global…", end=" ")
    for snapshot in df_grouped.groups:
        print(snapshot, end=" ", flush=True)
        dir = "/".join([targetDir, "global", "geotiff"])
        os.makedirs(dir, exist_ok=True)
        data = df_grouped.get_group(snapshot)

        #  Create Each Channel
        r_pixels = np.zeros((image_size), dtype=np.uint32)

        for row in data.itertuples(index=False):
            #print(row)
            (g_snapshot, latitude, longitude, count) = row

            if (longitude == '\\Nx' or latitude == '\\Nx;'):
                print("Null row")
            else:

                # Map longitudes -180.0–179.9 to 0–3599
                x = 1800 + int(float(longitude)*10)
                # Map latitudes -90.0–89.9 to 1799–0
                y = 1800 - 901 - int(float(latitude)*10)

                if (x < 3600 and y < 1800):
                    count = int(float(count))
                    r_pixels[y,x] = count

                else:
                    print("Out of range:", snapshot, snapshot, longitude, latitude, count, x, y)

        # Output final image
        writeImage(r_pixels, "/".join([dir, targetFile % snapshot]))
    print()

# Density map, 0.1°, about country
extractAreaGeoTIFF(
  areaType = "country",
  sourceFile = "occ_density_country_point_one_deg.csv",
  sourceSchema = ["snapshot", "country", "latitude", "longitude", "count"],
  targetFile = "occ_density_point_one_deg_%s.tiff",
  group = "country",
  groupLabel = "about"
)

# Density map, 0.1°, published by country
extractAreaGeoTIFF(
  areaType = "country",
  sourceFile = "occ_density_publisherCountry_point_one_deg.csv",
  sourceSchema = ["snapshot", "publisherCountry", "latitude", "longitude", "count"],
  targetFile = "occ_density_point_one_deg_%s.tiff",
  group = "publisherCountry",
  groupLabel = "publishedBy"
)

# Density map, 0.1°, about region
extractAreaGeoTIFF(
  areaType = "gbifRegion",
  sourceFile = "occ_density_gbifRegion_point_one_deg.csv",
  sourceSchema = ["snapshot", "gbifRegion", "latitude", "longitude", "count"],
  targetFile = "occ_density_point_one_deg_%s.tiff",
  group = "gbifRegion",
  groupLabel = "about"
)

# Density map, 0.1°, published by region
extractAreaGeoTIFF(
  areaType = "gbifRegion",
  sourceFile = "occ_density_publisherGbifRegion_point_one_deg.csv",
  sourceSchema = ["snapshot", "publisherGbifRegion", "latitude", "longitude", "count"],
  targetFile = "occ_density_point_one_deg_%s.tiff",
  group = "publisherGbifRegion",
  groupLabel = "publishedBy"
)

# Density map, 0.1°, global
extractGlobalGeoTIFF(
  sourceFile = "occ_density_point_one_deg.csv",
  sourceSchema = ["snapshot", "latitude", "longitude", "count"],
  targetFile = "occ_density_point_one_deg_%s.tiff"
)
