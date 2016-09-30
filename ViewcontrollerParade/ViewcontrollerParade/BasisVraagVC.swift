
//  BasisVraagVC.swift

// Een UIViewController met een extra property voor een closure die als feedback functie gebruikt wordt voor wanneer de gebruiker op een button tapt. Zo wordt voorkomen dat we delegates en protocollen moeten gebruiken voor communicatie tussen viewcontrollers.

import UIKit

class BasisVraagVC: UIViewController {
    var onButton: (antwoord: String) -> Void = { _ in }
    }
