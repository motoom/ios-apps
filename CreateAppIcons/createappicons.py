# -*- coding: utf-8 -*-

# Software by Michiel Overtoom, motoom@xs4all.nl

# TODO: Also include '-ipad-' and '-iphone-' in suffix
# TODO: Also create subdirectory 'AppIconXyz.appiconset' with all images + accompagnying catalog 'Contents.json'

''' Naming:

iOS has a simple, beautiful solution for handling Retina and Retina HD graphics, and in fact it does almost all the work for you – all you have to do is name your assets correctly.

Imagine you have an image called taylor.png, which is 100x100 pixels in size. That will look great on non-Retina devices, which means iPad 2 and the first-generation iPad Mini. If you want it to look great on Retina devices (which means iPad 3, 4, Air, Air 2, Mini 2 and Mini 3, plus iPhone 4s, 5, 5s, and 6) you need to provide a second image called taylor@2x.png that is 200x200 pixels in size – i.e., exactly twice the width and height.

Retina HD devices – at the time of writing that's just the iPhone 6 Plus – have an even higher resolution, so if you want your image to look great there you should provide a third image called taylor@3x.png that is 300x300 pixels in size – i.e., exactly three times the width and height of the original.

If you're not using an asset catalog, you can just drag these images into your project to have iOS use them. If you are using an asset catalog, drag them into your asset catalog and you should see Xcode correctly assign them to 1x, 2x and 3x boxes for the image. It's critical you name the files correctly because that's what iOS uses to load the correct resolution.

With that done, you just need to load taylor.png in your app, and iOS will automatically load the correct version of it depending on the user's device.

'''

import glob
from PIL import Image # pip install pillow
import sys
import os

resolutions = (
    # iPhone icons
    (180, "60@3x"),
    (120, "60@2x"),
    (120, "40@3x"),
    (80, "40@2x"),
    (87, "29@3x"),
    (58, "29@2x"),
    # additional iPad icons
    (167, "83.5@2x"),
    (152, "76@2x"),
    (76, "76@1x"),
    (40, "40@1x"),
    (29, "29@1x"),
    )
        
def createappicons(fn):
    for resolution, suffix in resolutions:
        im = Image.open(fn)
        im.thumbnail((resolution, resolution), Image.ANTIALIAS)
        basename, extension = os.path.splitext(fn)
        ofn = "%s-%s%s" % (basename, suffix, extension)
        im.save(ofn, "png")
        
if len(sys.argv) < 2:
    print "Usage: %s <imagefilename> Make copies of image in a diversity of sizes for iPhone and iPad icon sets." % sys.args[0]
else:
    createappicons(sys.argv[1])
