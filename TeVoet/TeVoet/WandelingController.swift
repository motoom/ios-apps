
//  WandelingController.swift

import UIKit
import MapKit
import CoreLocation

let standaardIgnoreUpdates = 2

class WandelingController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var locations = [CLLocation]()
    var ignoreUpdates = standaardIgnoreUpdates // de eerste 'ignoreupdates' meldingen negeren, vanwege initiele onnauwkeurigheid

    var totaal = 0.0 // Actueel totaal aantal meteres afgelegd.
    var prevLocation: CLLocation? = nil // De laatst verwerkte location in 'totaal'.

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setUserTrackingMode(.Follow, animated: true)
        }

    override func viewDidAppear(animated: Bool) {
        startTracking()
        }

    override func viewWillDisappear(animated: Bool) {
        stopTracking()
        saveWaypoints()
        }

    // Zie ook  allowDeferredLocationUpdatesUntilTraveled:timeout: en deferredLocationUpdatesAvailable
    func startTracking() {
        locations.removeAll()
        if !CLLocationManager.locationServicesEnabled() {
            return
            }
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        if let lm = apd.lm {
            lm.delegate = self
            lm.activityType = .Fitness
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // of '-Best'
            lm.distanceFilter = 10 // default is dit None
            // lm.allowDeferredLocationUpdatesUntilTraveled() // in combinatie met eerst de locationsupdates in een aparte buffer te loggen, ipv. ze direct in het totaal te verwerken
            lm.startUpdatingLocation()
            ignoreUpdates = standaardIgnoreUpdates
            print("Location updating started") // Ook te zien aan het pijltje in de statusbalk.
            }
        }

    func locationManager(manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        if ignoreUpdates > 0 {
            ignoreUpdates -= 1
                print("Genegeerde location update:", locations)
                return
            }
        locations.appendContentsOf(newLocations)
        print("Location update:", locations)
        print("Aantal waypoints:", locations.count)
        // Running totaal bijhouden.
        for location in newLocations {
            if prevLocation ==  nil {
                prevLocation = location
                }
            else {
                let delta = location.distanceFromLocation(prevLocation!)
                totaal += delta
                print("Delta van ", prevLocation, "naar", location, "is", delta, "meter, cumulatief=", totaal)
                prevLocation = location
                dispatch_async(dispatch_get_main_queue()) {
                    let saf = self.sjiekeAfstand(self.totaal)
                    self.statusLabel.text = "afgelegd: \(saf)"
                    }
                }
            }
        }

    func stopTracking() {
        if !CLLocationManager.locationServicesEnabled() {
            return
            }
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        if let lm = apd.lm {
            lm.stopUpdatingLocation()
            print("Location updating stopped")
            }
        }

    func saveWaypoints() {
        if locations.count < 2 {
            return
            }
        /*
        // Totaal gelopen afstand bepalen (in meters).
        // TODO: Als running total bijhouden in de class, want ook leuk om tussendoor te laten zien.
        print("\nAfstandberekening met", locations.count, "waypoints")
        var totaal = 0.0
        var prevwaypoint: CLLocation? = nil
        for waypoint in locations {
            if prevwaypoint ==  nil {
                prevwaypoint = waypoint
                }
            else {
                let delta = waypoint.distanceFromLocation(prevwaypoint!)
                totaal += delta
                print("Delta van ", prevwaypoint, "naar", waypoint, "is", delta, "meter, cumulatief=", totaal)
                prevwaypoint = waypoint
                }
            }
        */
        print("Totaal afgelegd: \(totaal)")
        // Filename voor save bepalen
        let yyyymmddhhmm = NSDateFormatter()
        yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
        let tijdstamp = yyyymmddhhmm.stringFromDate(locations[0].timestamp)
        let filenaam = "\(tijdstamp).v1.locations" // v1 = versie file format
        let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullfilenaam = docdir.URLByAppendingPathComponent(filenaam).path!
        // Saven
        let data = NSKeyedArchiver.archivedDataWithRootObject(locations) // TODO: Ook pedometer data saven
        data.writeToFile(fullfilenaam, atomically: true)
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
    }