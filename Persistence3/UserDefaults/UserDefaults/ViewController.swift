
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var naamText: UITextField!
    @IBOutlet weak var omschrijvingText: UITextField!

    @IBAction func klaar() {
        // Bewaar in User Defaults
        let defaults = UserDefaults.standard
        defaults.set(naamText.text, forKey: "naam")
        defaults.set(omschrijvingText.text, forKey: "omschrijving")
        titelLabel.text = "Gegevens zijn opgeslagen"
        }


    override func viewWillAppear(_ animated: Bool) {
        // Haal gegevens uit User Defaults
        let defaults = UserDefaults.standard
        naamText.text = defaults.object(forKey: "naam") as? String ?? ""
        omschrijvingText.text = defaults.object(forKey: "omschrijving") as? String ?? ""
        }
    }

