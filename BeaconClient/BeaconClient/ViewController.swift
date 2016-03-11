
import UIKit
import CoreBluetooth
import CoreLocation

// Good reads:
// https://community.estimote.com/hc/en-us/articles/203914068-Is-it-possible-to-use-beacon-ranging-in-the-background-
// http://stackoverflow.com/questions/19141779/ranging-beacons-only-works-when-app-running

// https://community.estimote.com/hc/en-us/articles/203356607-What-are-region-Monitoring-and-Ranging-

// http://developer.radiusnetworks.com/2013/10/21/corebluetooth-doesnt-let-you-see-ibeacons.html

// http://stackoverflow.com/questions/28582532/major-and-minor-on-altbeacons-under-ios

// https://community.estimote.com/hc/en-us/articles/203776266-What-is-a-beacon-region-

// http://stackoverflow.com/questions/24352764/how-to-detect-nearby-devices-with-bluetooth-le-in-ios-7-1-both-in-background-and/24352964#24352964

/*
Required background modes: 
    App shares data using CoreBluetooth
    App registers for location updates"
Project Capabilities, Background Modes:
    Location update
    Acts as a Bluetooth LE accessory
    Uses bluetooth LE accessories
*/

class ViewController: UIViewController, CLLocationManagerDelegate {

    // static let myuuid = NSUUID(UUIDString: "CB284D88-5317-4FB4-9621-C5A3A49E6155") // Vicinity

    static let myuuid = NSUUID(UUIDString: "D71842D3-376D-4C53-BB54-E1C041759305") // Particle Locator

    var myregion = CLBeaconRegion(proximityUUID: myuuid!, major: 123, minor: 456, identifier: "motoom-beacon")

    var lmgr = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        lmgr.delegate = self
        lmgr.pausesLocationUpdatesAutomatically = false
        lmgr.allowsBackgroundLocationUpdates = true

        // lmgr.distanceFilter = kCLDistanceFilterNone //whenever we move
        // lmgr.desiredAccuracy = kCLLocationAccuracyBest
        // lmgr.requestWhenInUseAuthorization()
        // lmgr.startUpdatingLocation()

        switch UIApplication.sharedApplication().backgroundRefreshStatus {
            case .Available:
                print("Background updates are available for the app.")
            case .Denied:
                print("The user explicitly disabled background behavior for this app or for the whole system.")
            case .Restricted:
                print("Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.")
            }
        }


    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("locationManager did change authorization status to \(status.rawValue)")
        if status == .NotDetermined {
            lmgr.requestAlwaysAuthorization()
            print("LocationManager authorization status is not determined, request always authorization")
            }
        else if status == .AuthorizedAlways {
            // myregion.notifyOnEntry = true // is default true already
            // myregion.notifyOnExit = true // is default true already
            // myregion.notifyEntryStateOnDisplay = true // is default false

            lmgr.startMonitoringForRegion(myregion)
            // print("Start monitoring for region")
            // print("Currently monitoring regions: ", lmgr.monitoredRegions)

            // lmgr.startUpdatingLocation()
            // print("startUpdatingLocation")

            // lmgr.startMonitoringVisits()
            // lmgr.startMonitoringForRegion(myregion)
            }
        }

    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons {
            // verbose: print(beacon), distance in cm, error estimate, etc...
            switch beacon.proximity {
                case .Far:
                    print("Beacon \(beacon.major).\(beacon.minor) is far")
                case .Immediate:
                    print("Beacon \(beacon.major).\(beacon.minor) is immediate")
                case .Near:
                    print("Beacon \(beacon.major).\(beacon.minor) is near")
                default:
                    print("Distance to beacon \(beacon.major).\(beacon.minor) is unknown")
                }
            }
        }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering region \(region.identifier)")
        }

    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exiting region \(region.identifier)")
        }

    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Did start monitoring for region \(region.identifier)")
        }

    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        var stateMsg = ""
        switch state {
            case .Unknown:
                stateMsg = "Unknown"
            case .Inside:
                stateMsg = "Inside"
            case .Outside:
                stateMsg = "Outside"
            }
        print("State for region \(region.identifier) changed to \(stateMsg)")
        if state == .Inside && region.identifier == myregion.identifier {
            lmgr.startRangingBeaconsInRegion(myregion)
            print("Start ranging beacons in region \(myregion.identifier)")
            }
        else if state == .Outside && region.identifier == myregion.identifier {
            lmgr.stopRangingBeaconsInRegion(myregion)
            print("Stop ranging beacons in region \(myregion.identifier)")
            }
        }

    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("locationManager:monitoringDidFailForRegion")
        }

    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print("locationManager:rangingBeaconsDidFailForRegion")
        }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager:didUpdateLocations")
        }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager:didFailWithError")
        }

    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print("locationManager:didFinishDeferredUpdatesWithError")
        }

    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
        }

    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
        }

    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
        print("locationManager:didVisit")
        }

    }

