
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var naamText: UITextField!
    @IBOutlet weak var omschrijvingText: UITextField!

    @IBAction func klaar() {
        // Bewaar in User Defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(naamText.text, forKey: "naam")
        defaults.setObject(omschrijvingText.text, forKey: "omschrijving")
        titelLabel.text = "Gegevens zijn opgeslagen"
        }

    override func viewWillAppear(animated: Bool) {
        // Haal gegevens uit User Defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        naamText.text = defaults.objectForKey("naam") as? String ?? ""
        omschrijvingText.text = defaults.objectForKey("omschrijving") as? String ?? ""
        }
    }

// Lees ook: https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-nsuserdefaults

