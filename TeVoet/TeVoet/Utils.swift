
//  Utils.swift

import UIKit

func docdirfilenaam(filenaam: String) -> String {
    let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    return docdir.URLByAppendingPathComponent(filenaam).path!
    }

func sjiekeAfstand(m: Double) -> String {
    let fmt = NSNumberFormatter()
    if m < 1000 {
        fmt.minimumFractionDigits = 1
        fmt.maximumFractionDigits = 0
        return fmt.stringFromNumber(m)! + "m"
        }
    else {
        fmt.minimumFractionDigits = 1
        fmt.maximumFractionDigits = 1
        return fmt.stringFromNumber(m/1000)! + "km"
        }
    }
