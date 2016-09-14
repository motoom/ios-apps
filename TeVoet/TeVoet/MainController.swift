
// MainController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit
import CoreMotion
import CoreLocation

class MainController: UIViewController, CLLocationManagerDelegate {

    var pd: CMPedometer? = nil // Alleen in iPhone 5s en hoger...
    var stappen = 0 // Aantal stappen vandaag gezet.

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
        // self.voetstappenLabel.text = "" // Ga ervanuit dat dit device géén pedometer heeft.
        // self.goalVoetstappenLabel.text = ""
        }


    func initPedometer() {
        if !CMPedometer.isStepCountingAvailable() {
            return // Dit iDevice bevat geen pedometer.
            }
        if pd != nil {
            return // Reeds geinitaliseerd.
            }

        pd = CMPedometer()

        // Vandaag, net na middernacht, dus heel vroeg: "2016-10-30 00:01".
        let yyyymmdd = NSDateFormatter()
        yyyymmdd.dateFormat = "yyyy-MM-dd"
        let vandaag = yyyymmdd.stringFromDate(NSDate())
        let vandaagheelvroeg = vandaag + " 00:01"

        let yyyymmddhhmm = NSDateFormatter()
        yyyymmddhhmm.dateFormat = "yyyy-MM-dd HH:mm"
        let start = yyyymmddhhmm.dateFromString(vandaagheelvroeg)!

        // Initieel aantal stappen ophalen.
        pd?.queryPedometerDataFromDate(start, toDate: NSDate()) {
            (data, error) -> Void in
                if error == nil && data != nil {
                    self.stappen = Int(data!.numberOfSteps)
                    self.verfrisVoetstappenLabels()
                    }
            }

        // En daarna ook periodiek aantal stappen ophalen.
        // TODO: Bug when date wraps around to next day, the count should be the steps TODAY, not since YESTERDAY
        pd?.startPedometerUpdatesFromDate(start) {
            (data, error) -> Void in
                if error == nil && data != nil {
                    self.stappen = Int(data!.numberOfSteps)
                    self.verfrisVoetstappenLabels()
                    }
                }
        }


    func verfrisVoetstappenLabels() {
        // Nu is er nog maar één label met het aantal voetstappen, maar dat worden er meer.
        dispatch_async(dispatch_get_main_queue()) {
            self.voetstappenLabel.text = String(self.stappen) // TODO: Netjes localized number
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
            apd.lm?.requestWhenInUseAuthorization() //  or requestAlwaysAuthorization
            }
        }


    override func viewDidAppear(animated: Bool) {
        initPedometer()
        initLocationManager()
        }

}

