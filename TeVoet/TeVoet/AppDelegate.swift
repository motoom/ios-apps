
//  AppDelegate.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lm: CLLocationManager? = nil


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
        }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


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
