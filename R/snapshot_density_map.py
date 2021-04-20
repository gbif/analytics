#!/usr/bin/python3
#
# Read 0.1° occurrence density counts from a CSV, which is assumed to be ordered by snapshot.
#
# For each new snapshot, create a matrix of 3600×1800 pixels.
#
# Colour the pixels in the matrix according to density.
#
# Write the coloured pixels over the appropriate basemap and output as a PNG.
#

import csv
import os
import sys
import requests
from PIL import Image

inputFile = sys.argv[1]
print("Reading occurrence density data from", inputFile)

outputDir = sys.argv[2] + "/figure/"
os.makedirs(outputDir, exist_ok=True)

outputPattern = sys.argv[3]

outputFilenameFormat = outputDir + outputPattern + '.png'
print("PNG maps will be written as", outputFilenameFormat)

size = (3600, 1800)

west = Image.open(requests.get('http://tile.gbif-dev.org/4326/omt/0/0/0@1800p.png?style=gbif-classic&srs=EPSG%3A4326', stream=True).raw)
east = Image.open(requests.get('http://tile.gbif-dev.org/4326/omt/0/1/0@1800p.png?style=gbif-classic&srs=EPSG%3A4326', stream=True).raw)

def writeImage(matrix, snapshot):
    print('Writing', outputFilenameFormat % snapshot)

    dots = Image.new("RGBA", size)
    dots.putdata(matrix)

    image = Image.new("RGB", size)
    image.paste(west, (0, 0, 1800, 1800))
    image.paste(east, (1800, 0, 3600, 1800))
    image.paste(dots, (0, 0, 3600, 1800), dots)
    image.save(outputFilenameFormat % snapshot)

with open(inputFile, 'r', newline='') as tsvin:
    tsvin = csv.DictReader(tsvin, delimiter=',', quotechar='"')

    curSnapshot = ''
    matrix = [(0,0,0,0)] * 3600 * 1800

    for row in tsvin:
        #print(row['snapshot'], row['longitude'], row['latitude'], row['count'])
        snapshot = row['snapshot']

        if (curSnapshot == ''):
            curSnapshot = snapshot
            #print(curSnapshot)

        if (row['longitude'] == '\\Nx' or row['latitude'] == '\\Nx;'):
            print("Null row")
            aoeu = 1
        else:

            # Map longitudes -180.0–179.9 to 0–3599
            x = 1800 + int(float(row['longitude'])*10)
            # Map latitudes -90.0–89.9 to 1799–0
            y = 1800 - 901 - int(float(row['latitude'])*10)

            if (curSnapshot != snapshot):
                writeImage(matrix, curSnapshot)

                curSnapshot = snapshot
                matrix = [(0,0,0,0)] * 3600 * 1800

            if (x < 3600 and y < 1800):
                count = int(float(row['count']))

                #                [total <=    10] { dot-fill: #FFFF00;  }
                # [total >    10][total <=   100] { dot-fill: #FFCC00;  }
                # [total >   100][total <=  1000] { dot-fill: #FF9900;  }
                # [total >  1000][total <= 10000] { dot-fill: #FF6600;  }
                # [total > 10000]                 { dot-fill: #D60A00;  }

                matrix[y * 3600 + x] = (0xFF, 0xFF, 0x00, 0xFF)
                if (count > 10):
                    matrix[y * 3600 + x] = (0xFF, 0xCC, 0x00, 0xFF)
                if (count > 100):
                    matrix[y * 3600 + x] = (0xFF, 0x99, 0x00, 0xFF)
                if (count > 1000):
                    matrix[y * 3600 + x] = (0xFF, 0x66, 0x00, 0xFF)
                if (count > 10000):
                    matrix[y * 3600 + x] = (0xD6, 0x0A, 0x00, 0xFF)
            else:
                print("Out of range:", row['snapshot'], row['longitude'], row['latitude'], row['count'], x, y)

# Output final image
writeImage(matrix, curSnapshot)
