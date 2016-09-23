
// MainController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import CoreMotion
import CoreLocation

class MainController: UIViewController, CLLocationManagerDelegate {

    var pd: CMPedometer? = nil // Alleen in iPhone 5s en hoger...
    var footsteps = 0 // Aantal stappen vandaag gezet.
    var footstepsGoal = 11000 // Nr. of footsteps to set every day.

    let yyyymmdd = NSDateFormatter()
    let yyyymmddhhmm = NSDateFormatter()
    var lastPedometerUpdateStart = "" // date (yyyy-mm-dd) when the last queryPedometerDataFromDate was issued; to handle wraparounds to next day in the case this app runs for multiple days.

    @IBOutlet weak var voetstappenLabel: UILabel!
    @IBOutlet weak var goalVoetstappenLabel: UILabel!


    // Balk van de NavigationController verbergen op het eerste scherm.
    // TODO: misschien de balk op de vervolgschermen transparant maken, en niet-interactief (behalve de Back button, dan).
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        }


    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        yyyymmdd.dateFormat = "yyyy-MM-dd"
        yyyymmddhhmm.dateFormat = "yyyy-MM-dd HH:mm"
        }


    func initPedometer() -> Bool {
        if !CMPedometer.isStepCountingAvailable() {
            // This iDevice doesn't have a pedometer.
            return false
            }
        if pd != nil {
            // Already initialized.
            return true
            }

        pd = CMPedometer()

        // Vandaag, net na middernacht, dus heel vroeg: "2016-10-30 00:01".
        let today = yyyymmdd.stringFromDate(NSDate())
        let todayVeryEarly = today + " 00:01"
        let start = yyyymmddhhmm.dateFromString(todayVeryEarly)!

        // Initieel aantal stappen ophalen.
        pd?.queryPedometerDataFromDate(start, toDate: NSDate()) {
            (data, error) -> Void in
                if error == nil && data != nil {
                    self.footsteps = Int(data!.numberOfSteps)
                    self.verfrisVoetstappenLabels()
                    }
            }

        // En daarna ook periodiek aantal stappen ophalen.
        lastPedometerUpdateStart = today
        pd?.startPedometerUpdatesFromDate(start, withHandler: updateFootsteps)

        return true
        }


    func updateFootsteps(data: CMPedometerData?, error: NSError?) {
        if error != nil || data == nil {
            return
            }
        self.footsteps = Int(data!.numberOfSteps)
        self.verfrisVoetstappenLabels()
        // Detect when date wraps around to next day, since the count should be the steps today, not since yesterday or some day earlier.
        let today = yyyymmdd.stringFromDate(NSDate())
        if lastPedometerUpdateStart != today {
            pd?.stopPedometerUpdates()
            // Restart updating from today.
            let todayVeryEarly = today + " 00:01"
            let start = yyyymmddhhmm.dateFromString(todayVeryEarly)!
            pd?.startPedometerUpdatesFromDate(start, withHandler:  updateFootsteps)
            lastPedometerUpdateStart = today
            }
        }


    func verfrisVoetstappenLabels() {
        // Nu is er nog maar één label met het aantal voetstappen, maar dat worden er meer.
        dispatch_async(dispatch_get_main_queue()) {
            self.voetstappenLabel.text = String(self.footsteps) // TODO: Netjes localized number
            }
        }


    func initLocationManager() {
        let status = CLLocationManager.authorizationStatus()
        if status == .Restricted || status == .Denied {
            return
            }
        let apd = UIApplication.sharedApplication().delegate as! AppDelegate
        if apd.lm != nil {
            return
            }
        apd.lm = CLLocationManager()
        if status == .NotDetermined {
            apd.lm?.requestWhenInUseAuthorization() //  This seems to work for background execution. Alternative is:  requestAlwaysAuthorization.
            }
        }


    override func viewDidAppear(animated: Bool) {
        if initPedometer() {
            self.voetstappenLabel.text = localizedInt(footsteps)
            self.goalVoetstappenLabel.text = "van de " + localizedInt(footstepsGoal)
            }
        else {
            self.voetstappenLabel.text = ""
            self.goalVoetstappenLabel.text = ""
            }
        initLocationManager()
        }

}

