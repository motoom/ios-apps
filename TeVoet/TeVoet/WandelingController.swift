
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
    var ignoreUpdates = standaardIgnoreUpdates // de eerste 'ignoreupdates' meldingen negeren, vanwege initiele onnauwkeurigheid
    var locationsBackgroundBuffer = [CLLocation]() // for collecting locations while in background state
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
        if locations.count >= 2 {
            saveWaypoints(locations)
            saveWaypointsCSV(locations)
            }
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
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // or '-Best'
            lm.distanceFilter = 10 // default None, but then many locations arrive, even without moving
            lm.allowsBackgroundLocationUpdates = true
            ignoreUpdates = standaardIgnoreUpdates
            lm.startUpdatingLocation()
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
        // Checken of in backgroundstate. Zoja, zo snel mogelijk bufferen en verder niets doen.
        if UIApplication.sharedApplication().applicationState == .Background {
            locationsBackgroundBuffer.appendContentsOf(newLocations)
            // print("didUpdateLocations: \(newLocations.count) locations recorded in background buffer")
            return
            }

        // In foreground: eventueel eerder opgenomen locations in background buffer appenden.
        if locationsBackgroundBuffer.count > 0 {
            locations.appendContentsOf(locationsBackgroundBuffer.filter{$0.horizontalAccuracy < 11})
            // print("didUpdateLocations: retrieved \(locationsBuffer.count) locations from background buffer")
            locationsBackgroundBuffer.removeAll()
            }
        // En daarna de nieuw binnenkomende locaties.
        locations.appendContentsOf(newLocations.filter{$0.horizontalAccuracy < 11})
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
                    self.statusLabel.text = "afgelegd: \(saf)" // TODO: Om de zoveels seconden roteren: totaal afstand afgelegd, totaal aantal stappen genomen (indien pedometerdata beschikbaar), snelheid in km/hr, tijdsduur.
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


    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let route: MKPolyline = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline:route)
            routeRenderer.lineWidth = 5.0
            routeRenderer.strokeColor = UIColor.redColor()
            return routeRenderer
            }
        return nil
        }



    }