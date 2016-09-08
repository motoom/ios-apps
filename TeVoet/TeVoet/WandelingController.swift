
// WandelingController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import MapKit
import CoreLocation

let standaardIgnoreUpdates = 2

class WandelingController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var locations = [CLLocation]()
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
            // lm.allowDeferredLocationUpdatesUntilTraveled() // in combinatie met eerst de locationsupdates in een aparte buffer te loggen, ipv. ze direct in het totaal te verwerken
            lm.startUpdatingLocation()
            ignoreUpdates = standaardIgnoreUpdates
            // print("Location updating started") // Ook te zien aan het pijltje in de statusbalk.
            }
        }

    func locationManager(manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        if ignoreUpdates > 0 {
            ignoreUpdates -= 1
                // print("Genegeerde location update:", locations)
                return
            }
        locations.appendContentsOf(newLocations)
        // print("Location update:", locations)
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