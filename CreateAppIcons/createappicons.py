
# Software by Michiel Overtoom, motoom@xs4all.nl

import glob
from PIL import Image # pip install pillow
import sys

resolutions = (
    (180, "60x60_3x"),
    (120, "60x60_2x"),
    (120, "40x40_3x"),
    (80, "40x40_2x"),
    (87, "29x29_3x"),
    (58, "29x29_2x"),
    )
        
def createappicons(fn):
    for resolution, prefix in resolutions:
        im = Image.open(fn)
        im.thumbnail((resolution, resolution), Image.ANTIALIAS)
        ofn = "%s_%s" % (prefix, fn)
        im.save(ofn, "png")
        
if len(sys.argv) < 2:
    print "Usage: %s <imagefilename> Make copies of image in 180, 120, 87, 80 and 58 pixels." % sys.args[0]
else:
    createappicons(sys.argv[1])