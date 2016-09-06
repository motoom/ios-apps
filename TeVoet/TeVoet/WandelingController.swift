
//  WandelingController.swift

import UIKit
import MapKit
import CoreLocation

class WandelingController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var waypoints = [CLLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setUserTrackingMode(.Follow, animated: true)
        }

    override func viewWillAppear(animated: Bool) {
        startTracking()
        }

    override func viewWillDisappear(animated: Bool) {
        stopTracking()
        }

    // Zie ook  allowDeferredLocationUpdatesUntilTraveled:timeout: en deferredLocationUpdatesAvailable
    func startTracking() {
        waypoints.removeAll()
        if !CLLocationManager.locationServicesEnabled() {
            return
            }
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        if let lm = apd.lm {
            lm.delegate = self
            lm.activityType = .Fitness
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // of Best
            lm.distanceFilter = 10 // default None
            lm.startUpdatingLocation()
            print("Location updating started")
            }
        }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location update:", locations)
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


    }