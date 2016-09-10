
//  Persistence.swift

import UIKit
import CoreLocation


func filenametimestamp(locations: [CLLocation]) -> String {
    let yyyymmddhhmm = NSDateFormatter()
    yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
    return yyyymmddhhmm.stringFromDate(locations[0].timestamp)
    }


func saveWaypoints(locations: [CLLocation]) {
    // Filename voor save bepalen
    let tijdstamp = filenametimestamp(locations)
    let filenaam = "\(tijdstamp).v1.locations" // v1 = versie file format
    let fullfilenaam = docdirfilenaam(filenaam)
    // Saven. TODO: Saven als dict met keys "meta" met pedometerdata, en "locations", en opname kwaliteit (nearest10m, best, bestfornavigation en reporting distance). Meta ook exporteren naar CSV. 
    NSKeyedArchiver.archivedDataWithRootObject(locations).writeToFile(fullfilenaam, atomically: true)
    }


func loadWaypoints(filename: String) -> [CLLocation]? {
    return NSKeyedUnarchiver.unarchiveObjectWithFile(docdirfilenaam(filename)) as? [CLLocation]
    }


func saveWaypointsCSV(locations: [CLLocation]) {
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
            delta = location.distanceFromLocation(prevLocation!)
            cumulDistance += delta
            prevLocation = location
            }
        // Format for output.
        let regel = "\(location.timestamp.timeIntervalSince1970), \"\(location.timestamp)\", \(location.coordinate.latitude), \(location.coordinate.longitude), \(location.horizontalAccuracy), \(location.altitude), \(location.verticalAccuracy), \(delta), \(cumulDistance)\n"
        csv += regel
        }
    do {
        try csv.writeToFile(fullfilenaam,  atomically: true, encoding: NSUTF8StringEncoding)
        }
    catch {
        let err = error as NSError
        print(err.localizedDescription)
        }
    }


