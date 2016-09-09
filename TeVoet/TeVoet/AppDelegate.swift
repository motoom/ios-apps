
//  AppDelegate.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

// TODO: Alle filenamen, typenamen, variablene, outlets etc... in English
// TODO: i18n and l10n naar Dutch
// TODO: Delete of selected walks


import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var lm: CLLocationManager? = nil
    }



    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus:", status)
        }
    */
    

    // https://developer.apple.com/reference/coremotion/cmpedometer
    // http://pinkstone.co.uk/how-to-access-the-step-counter-and-pedometer-data-in-ios-9/


        /*
        var errorgiven = false

        if !CMPedometer.isStepCountingAvailable() && !errorgiven {
            let alert = UIAlertController(title: "Sorry",  message: "Deze iPhone bevat geen voetstappenteller", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
            self.errorgiven = true
            }
        */
        

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
        print("Totaal afgelegd: \(totaal)")
        */



        /*
        print("Availability:")
        print("StepCounting", CMPedometer.isStepCountingAvailable())
        print("Distance", CMPedometer.isDistanceAvailable())
        print("FloorCounting", CMPedometer.isFloorCountingAvailable())
        print("Pace", CMPedometer.isPaceAvailable())
        print("Cadence", CMPedometer.isCadenceAvailable())
        */
