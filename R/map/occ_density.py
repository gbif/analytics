#!/usr/bin/python3
#
# Read 0.1° occurrence density counts by snapshot from a GeoTIFF.
#
# Colour the pixels according to density.
#
# Write the coloured pixels over the appropriate basemap and output as PNGs in three sizes.
#

# NOTE: The maps are only rendered in the gbif-classic style.  The glacier and fire styles would be
# complicated to implement: Python Mapnik does not support the necessary composition operations
# (overlapping markers etc), and our implementation of these styles in Node Mapnik is closely tied
# to the browser-friendly (512px) resolutions used there.  (The analytics uses analysis-friendly 0.1°
# resolutions.)

import mapnik
import os, subprocess, sys, tempfile
import requests
from osgeo import gdal
from PIL import Image

# The GBIF Classic pixel map style
classic = mapnik.RasterSymbolizer()
# COLORIZER_DISCRETE is a binned/classified rendere. Other options are COLORIZER_LINEAR (stretched) and
# COLORIZER_EXACT (unique)
classic.colorizer = mapnik.RasterColorizer(mapnik.COLORIZER_DISCRETE, mapnik.Color(0, 0, 0, 0))
# "A stop has a value, which marks the stop as being applied to input values from its value, up until the next stops value."
classic.colorizer.add_stop(    1, mapnik.Color(0xFF, 0xFF, 0))
classic.colorizer.add_stop(   11, mapnik.Color(0xFF, 0xCC, 0))
classic.colorizer.add_stop(  101, mapnik.Color(0xFF, 0x99, 0))
classic.colorizer.add_stop( 1001, mapnik.Color(0xFF, 0x66, 0))
classic.colorizer.add_stop(10001, mapnik.Color(0xD6, 0x0A, 0))

#                [total <=    10] { dot-fill: #FFFF00;  }
# [total >    10][total <=   100] { dot-fill: #FFCC00;  }
# [total >   100][total <=  1000] { dot-fill: #FF9900;  }
# [total >  1000][total <= 10000] { dot-fill: #FF6600;  }
# [total > 10000]                 { dot-fill: #D60A00;  }

s = mapnik.Style()
r = mapnik.Rule()
r.symbols.append(classic)
s.rules.append(r)

# Assemble a 'classic' style map background
def mapBackground(width):
    height = int(width/2)
    west = mapnik.Image.fromstring(requests.get('http://tile.gbif-dev.org/4326/omt/0/0/0@'+str(height)+'p.png?style=gbif-classic&srs=EPSG%3A4326', stream=True).content)
    east = mapnik.Image.fromstring(requests.get('http://tile.gbif-dev.org/4326/omt/0/1/0@'+str(height)+'p.png?style=gbif-classic&srs=EPSG%3A4326', stream=True).content)

    im = mapnik.Image(width, height)
    im.composite(west, mapnik.CompositeOp.src_over, 1.0, 0, 0)
    im.composite(east, mapnik.CompositeOp.src_over, 1.0, height, 0)

    return im

# Load and render the raster data
def generateMap(sourceFile, renderFile, width):

    m = mapnik.Map(width, int(width/2))
    m.srs = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'

    m.append_style('Default', s)

    # Load the GeoTIFF via GDAL.
    ds = mapnik.Gdal(file=sourceFile, band=1)
    layer = mapnik.Layer('layer')

    # Layer SRS is NOT loaded automatically
    layer.srs = m.srs
    layer.datasource = ds
    layer.styles.append('Default')
    m.layers.append(layer)
    m.zoom_all()

    # This is the map without any background
    #mapnik.render_to_file(m, renderFile, 'png')

    im = mapBackground(width)
    mapnik.render(m, im)
    im.save(renderFile, 'png')


with tempfile.TemporaryDirectory() as tmpdir:
    for sourceFile in sys.argv[1:]:
        renderFile = sourceFile.replace('geotiff/', 'map/').replace('.tiff', '.png')
        print(renderFile)
        os.makedirs(os.path.dirname(renderFile), exist_ok=True)

        # 3600×1800 map, i.e 0.1°
        generateMap(sourceFile, renderFile, 3600)

        # 1800×900 map, i.e. 0.2°, better on slightly older screens
        halfSourceFile = tmpdir + '/' + os.path.basename(sourceFile)
        halfRenderFile = sourceFile.replace('geotiff/', 'map/').replace('.tiff', '.png').replace('one', 'two')
        # Due to the missing constant (https://github.com/OSGeo/gdal/issues/3724), this uses the command rather than the
        # Python binding.
        subprocess.call(['gdalwarp', '-q', '-ts', '1800', '900', '-r', 'sum', '-overwrite', sourceFile, halfSourceFile])
        #inDs = gdal.Open(sourceFile)
        #outDs = gdal.Warp(halfSourceFile, inDs, format='GTiff', width=1800, height=900, resampleAlg=gdal.GRA_Sum)
        generateMap(halfSourceFile, halfRenderFile, 1800)

        # 900×450 map, i.e. 0.4°, for presentations etc
        quarterSourceFile = tmpdir + '/' + os.path.basename(sourceFile)
        quarterRenderFile = sourceFile.replace('geotiff/', 'map/').replace('.tiff', '.png').replace('one', 'four')
        subprocess.call(['gdalwarp', '-q', '-ts', '900', '450', '-r', 'sum', '-overwrite', sourceFile, quarterSourceFile])
        generateMap(quarterSourceFile, quarterRenderFile, 900)
        # Double the size (so the 'pixels' are 2×2)
        Image.open(quarterRenderFile).resize((1800, 900), Image.NEAREST).save(quarterRenderFile)
