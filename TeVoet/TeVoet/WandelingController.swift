
// WandelingController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import MapKit
import CoreLocation

let standaardIgnoreUpdates = 3

class WandelingController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var locations = [CLLocation]()
    var locationsBuffer = [CLLocation]() // for collecting locations while in background state
    var ignoreUpdates = standaardIgnoreUpdates // de eerste 'ignoreupdates' meldingen negeren, vanwege initiele onnauwkeurigheid
    var prevpolyline: MKPolyline? = nil

    var totaal = 0.0 // Actueel totaal aantal meters afgelegd.
    var prevLocation: CLLocation? = nil // De laatst verwerkte location in 'totaal'.

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.delegate = self
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
            lm.allowsBackgroundLocationUpdates = true
            lm.startUpdatingLocation()
            ignoreUpdates = standaardIgnoreUpdates
            // print("Location updating started") // Ook te zien aan het pijltje in de statusbalk.
            }
        }

    func locationManager(manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        // TODO: Dit moet beter. Bijvoorbeeld alle updates weggooien totdat ze een stabiele loopsnelheid laten zien.
        // Of de eerste vijf seconden niets opslaan, of onnauwkeurige (>10m) locatiefixes negeren
        if ignoreUpdates > 0 {
            ignoreUpdates -= 1
                // print("didUpdateLocations: Genegeerde location update:", locations)
                return
            }
        // Checken of in backgroundstate. Zoja, bufferen en verder niets doen.
        if UIApplication.sharedApplication().applicationState == .Background {
            locationsBuffer.appendContentsOf(newLocations)
            // print("didUpdateLocations: \(newLocations.count) locations recorded in background buffer")
            return
            }

        // In foreground: eventueel eerder opgenomen locations in background buffer appenden.
        if locationsBuffer.count > 0 {
            locations.appendContentsOf(locationsBuffer)
            // print("didUpdateLocations: retrieved \(locationsBuffer.count) locations from background buffer")
            locationsBuffer.removeAll()
            }
        // En daarna de nieuw binnenkomende locaties.
        locations.appendContentsOf(newLocations)
        // print("didUpdateLocations: foreground update with \(newLocations.count) locations")

        // print("Aantal waypoints:", locations.count)
        // Nog goed lezen: http://stackoverflow.com/questions/27129639/rendering-multiple-polylines-on-mapview
        var polylinecoords = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let polyline = MKPolyline(coordinates: &polylinecoords, count: locations.count)
        if let pp = prevpolyline {
            mapView.removeOverlay(pp)
            }
        mapView.addOverlay(polyline)
        prevpolyline = polyline
        // Running totaal bijhouden.
        for location in newLocations {
            if prevLocation ==  nil {
                prevLocation = location
                }
            else {
                let delta = location.distanceFromLocation(prevLocation!)
                totaal += delta
                // print("Delta van ", prevLocation, "naar", location, "is", delta, "meter, cumulatief=", totaal)
                prevLocation = location
                dispatch_async(dispatch_get_main_queue()) {
                    let saf = sjiekeAfstand(self.totaal)
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
            // print("Location updating stopped")
            }
        }

    func saveWaypoints() {
        if locations.count < 2 {
            return
            }
        // Filename voor save bepalen
        let yyyymmddhhmm = NSDateFormatter()
        yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
        let tijdstamp = yyyymmddhhmm.stringFromDate(locations[0].timestamp)
        let filenaam = "\(tijdstamp).v1.locations" // v1 = versie file format
        let fullfilenaam = docdirfilenaam(filenaam)
        // Saven. TODO: Ook als CSV saven? Of een conversie-utility schrijven?
        // TODO: Saven als dict met keys "meta", "pedometer" en "locations"?
        let data = NSKeyedArchiver.archivedDataWithRootObject(locations) // TODO: Ook pedometer data saven
        data.writeToFile(fullfilenaam, atomically: true)
        }


    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let route: MKPolyline = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline:route)
            routeRenderer.lineWidth = 5.0
            routeRenderer.strokeColor = UIColor.redColor() // UIColor(red: 240.0/255.0, green: 68.0/255.0, blue: 0.0/255.0, alpha: 1);
            return routeRenderer
            }
        return nil
        }



    }