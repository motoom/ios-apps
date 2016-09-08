
//  Utils.swift

import UIKit

func docdirfilenaam(filenaam: String) -> String {
    let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    return docdir.URLByAppendingPathComponent(filenaam).path!
    }
