
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

