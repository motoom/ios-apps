
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var naamText: UITextField!
    @IBOutlet weak var adresText: UITextField!
    @IBOutlet weak var plaatsText: UITextField!

    @IBAction func save(knop: UIButton) {
        let adressering = Adressering(naamText.text!, adresText.text!, plaatsText.text!)
        if Archiver.save(adressering, "datafile.archive") {
            knop.setTitle("Saved!", forState: .Normal)
            }
        }

    override func viewWillAppear(animated: Bool) {
        if let adressering = Archiver.load("datafile.archive") as? Adressering {
            naamText.text = adressering.naam
            adresText.text = adressering.adres
            plaatsText.text = adressering.plaats
            }
        }
    }

