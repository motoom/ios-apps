
//  Utils.swift

import UIKit
import CoreLocation


func docdirfilenaam(filenaam: String) -> String {
    let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    return docdir.URLByAppendingPathComponent(filenaam).path!
    }


func sjiekeAfstand(m: Double) -> String {
    let fmt = NSNumberFormatter()
    fmt.usesGroupingSeparator = true
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


func localizedInt(i: Int) -> String {
    let fmt = NSNumberFormatter()
    fmt.usesGroupingSeparator = true
    return fmt.stringFromNumber(i)!
    }


// "yyyymmddhhmm" -> "23 aug 2016, 12:03"
func nicedatetime(s: String) -> String
{
    let yyyymmddhhmm = NSDateFormatter()
    yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
    if let stamp = yyyymmddhhmm.dateFromString(s) {
        return NSDateFormatter.localizedStringFromDate(stamp, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
    else {
        return s
        }
}


func documentfiles() -> [String] {
    let directory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    if let urlArray = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(directory, includingPropertiesForKeys: [NSURLNameKey], options: NSDirectoryEnumerationOptions.SkipsHiddenFiles) {
        return urlArray.map{$0.lastPathComponent!}.filter{$0.hasSuffix(".v1.locations")}.sort()
        }
    else {
        return []
        }
    }


func totalDistance(locations: [CLLocation]) -> Double {
    var total = 0.0
    var prevLocation: CLLocation? = nil
    for location in locations {
            if prevLocation ==  nil {
                prevLocation = location
                }
            else {
                total += location.distanceFromLocation(prevLocation!)
                prevLocation = location
                }
        }
    return total
    }


