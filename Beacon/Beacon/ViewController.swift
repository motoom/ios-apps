
import UIKit
import CoreBluetooth
import CoreLocation

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    let uuid = NSUUID(UUIDString: "CB284D88-5317-4FB4-9621-C5A3A49E6155") // Same as Vicinity app.
    var pmgr : CBPeripheralManager?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pmgr = CBPeripheralManager(delegate: self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        if let mgr = pmgr {
            mgr.delegate = self
            }
        else {
            print("Can't get a peripheral manager")
            }
        }

    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?){
        if error == nil {
            print("Advertising as \(uuid!.UUIDString)")
            }
        else {
            print("Can't advertise: \(error)")
            }
        }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        peripheral.stopAdvertising()
        if peripheral.state == .PoweredOn {
            let ad: [String: AnyObject!] = [
                CBAdvertisementDataLocalNameKey : "Fridge with nice munchies",
                CBAdvertisementDataManufacturerDataKey : NSBundle.mainBundle().bundleIdentifier!,
                CBAdvertisementDataServiceUUIDsKey : [CBUUID(NSUUID: uuid!)]]
            peripheral.startAdvertising(ad)
            }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Bluetooth", message: "Please enable Bluetooth in Settings, and restart the app", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }

    }
