
//  UitslagVC.swift

import UIKit

class UitslagVC: BasisVraagVC {

    override func viewWillAppear(animated: Bool) {
        if let nav = self.navigationController as? NavController {
            print("De gegeven antwoorden zijn:", nav.antwoorden)
            }
        }

    @IBAction func ok(sender: UIButton) {
        onButton(antwoord: "ok")
        }

    }
