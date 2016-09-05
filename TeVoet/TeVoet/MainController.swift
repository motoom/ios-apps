//
//  MainController.swift
//  TeVoet
//
//  Created by User on 2016-09-05.
//  Copyright © 2016 motoom. All rights reserved.
//

import UIKit
import CoreMotion

class MainController: UIViewController {

    // https://developer.apple.com/reference/coremotion/cmpedometer
    // http://pinkstone.co.uk/how-to-access-the-step-counter-and-pedometer-data-in-ios-9/

    var pd = CMPedometer() // Alleen in iPhone 5s en hoger...
    var errorgiven = false

    @IBOutlet weak var voetstappenLabel: UILabel!
    
    // Balk van de NavigationController verbergen op het eerste scherm.
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
        /*
        print("Availability:")
        print("StepCounting", CMPedometer.isStepCountingAvailable())
        print("Distance", CMPedometer.isDistanceAvailable())
        print("FloorCounting", CMPedometer.isFloorCountingAvailable())
        print("Pace", CMPedometer.isPaceAvailable())
        print("Cadence", CMPedometer.isCadenceAvailable())
        */

        let from = "2016-01-01 00:00"
        let fmt = NSDateFormatter()
        fmt.dateFormat = "YYYY-MM-DD HH:mm"
        print(fmt.stringFromDate(NSDate()))

        let start = fmt.dateFromString(from)!
        let end = NSDate()

        // CMErrorDomain 104 betekent Feature not supported
        pd.queryPedometerDataFromDate(start, toDate: end) {
            (data, error) -> Void in
                if error != nil {
                    // self.voetstappenLabel.text = "stappenteller niet beschikbaar"
                    print(data)
                    }
                else {
                    self.voetstappenLabel.text = "6.285 van de 12.000"
                    }
            }

        pd.startPedometerUpdatesFromDate(NSDate()) {
            (data, error) -> Void in
                print("Pedometer update:", data, error)
                if error == nil {
                    self.voetstappenLabel.text = "XYZ van de 12.000"
                    }
                }
        }

    override func viewDidAppear(animated: Bool) {
        if !CMPedometer.isStepCountingAvailable() && !errorgiven {
            let alert = UIAlertController(title: "Sorry",  message: "Deze iPhone bevat geen voetstappenteller", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
            self.errorgiven = true
            }
        }

}

