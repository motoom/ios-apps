
// WandelingController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import MapKit
import CoreLocation

let standaardIgnoreUpdates = 3
let minimumDistance: CLLocationDistance = 10

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
        mapView.showsCompass = false
        mapView.setUserTrackingMode(.followWithHeading, animated: false)
        mapView.delegate = self
        }


    override func viewDidAppear(_ animated: Bool) {
        startTracking()
        }


    override func viewWillDisappear(_ animated: Bool) {
        stopTracking()
        if locations.count >= 2 {
            saveWaypoints(locations)
            // TODO: alleen als debug: saveWaypointsCSV(locations)
            }
        }


    // Zie ook  allowDeferredLocationUpdatesUntilTraveled:timeout: en deferredLocationUpdatesAvailable
    func startTracking() {
        locations.removeAll()
        if !CLLocationManager.locationServicesEnabled() {
            return
            }
        let apd = UIApplication.shared.delegate as! AppDelegate
        if let lm = apd.lm {
            lm.delegate = self
            lm.activityType = .fitness
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // or '-Best'
            // lm.desiredAccuracy = kCLLocationAccuracyBest
            lm.distanceFilter = minimumDistance // standard 10, default None, but then many locations arrive, even without moving
            lm.allowsBackgroundLocationUpdates = true
            ignoreUpdates = standaardIgnoreUpdates
            lm.startUpdatingLocation()
            // print("Location updating started") // Ook te zien aan het pijltje in de statusbalk.
            }
        }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        // TODO: Dit moet beter. Bijvoorbeeld alle updates weggooien totdat ze een stabiele loopsnelheid laten zien.
        // TODO: De eerste tien seconden niets opslaan, zodat de location services zich eerst kunnen stabiliseren.
        if ignoreUpdates > 0 {
            ignoreUpdates -= 1
                // print("didUpdateLocations: Genegeerde location update:", locations)
                return
            }
        // Checken of in backgroundstate. Zoja, zo snel mogelijk bufferen en verder niets doen.
        if UIApplication.shared.applicationState == .background {
            locationsBackgroundBuffer.append(contentsOf: newLocations)
            // print("didUpdateLocations: \(newLocations.count) locations recorded in background buffer")
            return
            }

        // We're in foreground

        // Locations that need to be processed for updating distance
        var locationsToProcess = [CLLocation]()

        // Are there any locations previously recorded while we were in the background? If so, we have to deal with them first.
        if locationsBackgroundBuffer.count > 0 {
            let filteredLocations = locationsBackgroundBuffer.filter{$0.horizontalAccuracy <= minimumDistance && $0.verticalAccuracy <= 10}
            locationsBackgroundBuffer.removeAll()
            locations.append(contentsOf: filteredLocations) // Record for storage
            locationsToProcess.append(contentsOf: filteredLocations) // Record for distance processing
            }
        // Now deal with the new locations incoming to this invocation.
        let filteredLocations = newLocations.filter{$0.horizontalAccuracy <= minimumDistance && $0.verticalAccuracy <= 10}
        locations.append(contentsOf: filteredLocations) // For storage
        locationsToProcess.append(contentsOf: filteredLocations) // For distance processing

        // Update the polyline overlay. TODO: Read again http://stackoverflow.com/questions/27129639/rendering-multiple-polylines-on-mapview
        var polylinecoords = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let polyline = MKPolyline(coordinates: &polylinecoords, count: locations.count)
        if let pp = prevpolyline {
            mapView.remove(pp)
            }
        mapView.add(polyline)
        prevpolyline = polyline

        // Running totals like distance walked.
        for location in locationsToProcess {
            if prevLocation ==  nil {
                prevLocation = location
                }
            else {
                let delta = location.distance(from: prevLocation!)
                totaal += delta
                // print("Delta van ", prevLocation, "naar", location, "is", delta, "meter, cumulatief=", totaal)
                prevLocation = location
                DispatchQueue.main.async {
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
        let apd = UIApplication.shared.delegate as! AppDelegate
        if let lm = apd.lm {
            lm.stopUpdatingLocation()
            }
        }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let route: MKPolyline = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline:route)
            routeRenderer.lineWidth = 5.0
            routeRenderer.strokeColor = UIColor.red
            return routeRenderer
            }
        return MKOverlayRenderer()
        }


    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            if mode == .none {
                statusLabel.text = "kaart volgt niet"
                }
            else {
                statusLabel.text = "kaart volgt"
                }
            }


    @IBAction func titleButton(_ sender: UIButton) {
        if mapView.userTrackingMode != .followWithHeading {
            mapView.setUserTrackingMode(.followWithHeading, animated: false)
            }
        }


    }

