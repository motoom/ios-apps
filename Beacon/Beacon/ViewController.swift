
import UIKit
import CoreBluetooth
import CoreLocation

/* Reads
http://www.blendedcocoa.com/blog/2013/11/02/mavericks-as-an-ibeacon/
https://github.com/Instrument/Vicinity/issues/5
https://willd.me/posts/getting-started-with-ibeacon-a-swift-tutorial
*/

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    // let uuid = NSUUID(UUIDString: "CB284D88-5317-4FB4-9621-C5A3A49E6155") // UUID used in Vicinity app. (Vicinity detectes BLE devices, not iBeacons!)
    let uuid = NSUUID(UUIDString: "D71842D3-376D-4C53-BB54-E1C041759305") // One of the UUIDs used in Particle Locator app.
    var pmgr: CBPeripheralManager?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pmgr = CBPeripheralManager(delegate: self, queue: nil)
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
        if peripheral.state == .PoweredOn {

            // This works for Particle Detector, but not for Vicinity:
            let region = CLBeaconRegion(proximityUUID: uuid!, major: 123, minor: 456, identifier: "motoom-beacon")

            let ad: [String: AnyObject!] = region.peripheralDataWithMeasuredPower(nil) as NSDictionary as! [String : AnyObject!]

            /*
            // This works for Vicinity, but not for Particle Detector:
            let ad: [String: AnyObject!] = [
                CBAdvertisementDataLocalNameKey: "vicinity-peripheral",
                CBAdvertisementDataManufacturerDataKey: NSBundle.mainBundle().bundleIdentifier!,
                CBAdvertisementDataServiceUUIDsKey: [CBUUID(NSUUID: uuid!)]]
            */

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
