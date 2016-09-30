
//  DerdeVraagVC.swift

import UIKit

class DerdeVraagVC: BasisVraagVC {

    @IBAction func helemaalOneens(sender: UIButton) {
        onButton(antwoord: "ho")
        }

    @IBAction func oneens(sender: UIButton) {
        onButton(antwoord: "o")
        }

    @IBAction func eens(sender: UIButton) {
        onButton(antwoord: "e")
        }

    @IBAction func helemaalEens(sender: UIButton) {
        onButton(antwoord: "he")
        }

    }
