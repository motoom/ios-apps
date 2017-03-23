# -*- coding: utf-8 -*-

# Software by Michiel Overtoom, motoom@xs4all.nl

from PIL import Image # pip install pillow
import sys
import os

resolutions = (
    (40, "20@2x"),
    (60, "20@3x"),

    (58, "29@2x"),
    (87, "29@3x"),

    (80, "40@2x"),
    (120, "40@3x"),

    (120, "60@2x"),
    (180, "60@3x"),
    )
        
def createappicons(fn):
    for resolution, suffix in resolutions:
        im = Image.open(fn)
        im.thumbnail((resolution, resolution), Image.ANTIALIAS)
        basename, extension = os.path.splitext(fn)
        ofn = "%s-%s%s" % (basename, suffix, extension)
        im.save(ofn, "png")
        
createappicons("vectorsneakers")
