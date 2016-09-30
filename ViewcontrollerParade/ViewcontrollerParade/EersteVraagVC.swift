
//  EersteVraagVC.swift

// Let op: In storyboard moet het storyboard-id van deze viewcontroller gespecificeerd worden, anders werkt het niet.
// Ook de 'scrolling enabled' van het TextField op 'false' gezet ivm. variabele hoogte ervan in combinatie met autoconstraints.

import UIKit

class EersteVraagVC: BasisVraagVC {

    @IBAction func ja(sender: UIButton) {
        onButton(antwoord: "j")
        }

    @IBAction func nee(sender: UIButton) {
        onButton(antwoord: "n")
        }

    @IBAction func weetniet(sender: UIButton) {
        onButton(antwoord: "?")
        }

    }
