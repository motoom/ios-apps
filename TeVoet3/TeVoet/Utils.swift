
//  Utils.swift

import UIKit
import CoreLocation


func docdirfilenaam(_ filenaam: String) -> String {
    let docdir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return docdir.appendingPathComponent(filenaam).path
    }


func sjiekeAfstand(_ m: Double) -> String {
    let fmt = NumberFormatter()
    fmt.usesGroupingSeparator = true
    if m < 1000 {
        fmt.minimumFractionDigits = 1
        fmt.maximumFractionDigits = 0
        return fmt.string(from: NSNumber(value: m))! + "m"
        }
    else {
        fmt.minimumFractionDigits = 1
        fmt.maximumFractionDigits = 1
        return fmt.string(from: NSNumber(value: m / 1000))! + "km"
        }
    }


func localizedInt(_ i: Int) -> String {
    let fmt = NumberFormatter()
    fmt.usesGroupingSeparator = true
    return fmt.string(from: NSNumber(value: i))!
    }


// "yyyymmddhhmm" -> "23 aug 2016, 12:03"
func nicedatetime(_ s: String) -> String
{
    let yyyymmddhhmm = DateFormatter()
    yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
    if let stamp = yyyymmddhhmm.date(from: s) {
        return DateFormatter.localizedString(from: stamp, dateStyle: .medium, timeStyle: .short)
        }
    else {
        return s
        }
}


func documentfiles() -> [String] {
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    if let urlArray = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [URLResourceKey.nameKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) {
        return urlArray.map{$0.lastPathComponent}.filter{$0.hasSuffix(".v2.locations")}.sorted()
        }
    else {
        return []
        }
    }


func totalDistance(_ locations: [CLLocation]) -> Double {
    var total = 0.0
    var prevLocation: CLLocation? = nil
    for location in locations {
            if prevLocation ==  nil {
                prevLocation = location
                }
            else {
                total += location.distance(from: prevLocation!)
                prevLocation = location
                }
        }
    return total
    }


func prettyDateTimes(_ begin: CLLocation?, _ end: CLLocation?) -> (String, String) {
    let walkDate = DateFormatter.localizedString(from: (begin?.timestamp)!, dateStyle: .long, timeStyle: .none)
    var walkTimes = DateFormatter.localizedString(from: (begin?.timestamp)!, dateStyle: .none, timeStyle: .short)
    walkTimes += " - "
    walkTimes += DateFormatter.localizedString(from: (end?.timestamp)!, dateStyle: .none, timeStyle: .short)
    return (walkDate, walkTimes)
    }


