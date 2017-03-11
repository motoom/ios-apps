
//  Persistence.swift

import UIKit
import CoreLocation


func filenametimestamp(_ locations: [CLLocation]) -> String {
    let yyyymmddhhmm = DateFormatter()
    yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
    return yyyymmddhhmm.string(from: locations[0].timestamp)
    }


func saveWaypoints(_ locations: [CLLocation]) {
    // Filename voor save bepalen
    let tijdstamp = filenametimestamp(locations)
    let filenaam = "\(tijdstamp).v2.locations" // v2 = versie file format
    let fullfilenaam = docdirfilenaam(filenaam)
    // Determine some metadata.
    let (walkDate, walkTimes) = prettyDateTimes(locations.first, locations.last)
    let distance = totalDistance(locations)
    // Save as dict containing the metadata (in its own separate dict), and locations array.
    var d = [String: Any]()
    var meta = [String: Any]()
    meta["walkDate"] = walkDate
    meta["walkTimes"] = walkTimes
    meta["totalDistance"] = sjiekeAfstand(distance)
    d["meta"] = meta
    d["locations"] = locations
    try? NSKeyedArchiver.archivedData(withRootObject: d).write(to: URL(fileURLWithPath: fullfilenaam), options: [.atomic])
    }


func loadWaypoints(_ filename: String) -> ([CLLocation], [String: Any]) {
    if let d = NSKeyedUnarchiver.unarchiveObject(withFile: docdirfilenaam(filename)) as? [String: Any] {
        let locs = d["locations"] as! [CLLocation]
        let meta = d["meta"] as! [String: Any]
        return (locs, meta)
        }
    else {
        return ([CLLocation](), [:])
        }
    }


func saveWaypointsCSV(_ locations: [CLLocation]) {
    let tijdstamp = filenametimestamp(locations)
    let filenaam = "\(tijdstamp).csv"
    let fullfilenaam = docdirfilenaam(filenaam)
    // CSV header
    var csv = "\"unix timestamp\", \"datetime\", \"latitude\", \"longitude\", \"horizontal accuracy\", \"altitude\", \"vertical accuracy\", \"distance\", \"cumulative distance\"\n"
    var cumulDistance: Double = 0, delta: Double = 0
    var prevLocation: CLLocation?
    for location in locations {
        // Calculate distance and cumulative distance
        if prevLocation ==  nil {
            prevLocation = location
            }
        else {
            delta = location.distance(from: prevLocation!)
            cumulDistance += delta
            prevLocation = location
            }
        // Format for output.
        let regel = "\(location.timestamp.timeIntervalSince1970), \"\(location.timestamp)\", \(location.coordinate.latitude), \(location.coordinate.longitude), \(location.horizontalAccuracy), \(location.altitude), \(location.verticalAccuracy), \(delta), \(cumulDistance)\n"
        csv += regel
        }
    do {
        try csv.write(toFile: fullfilenaam,  atomically: true, encoding: String.Encoding.utf8)
        }
    catch {
        let err = error as NSError
        print(err.localizedDescription)
        }
    }


