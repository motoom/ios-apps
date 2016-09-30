
//  NavController.swift

import UIKit

class NavController: UINavigationController {

    var antwoorden = [String: String]() // De gegeven antwoorden.


    // Beginnen met de eerste vraag.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("eerstevraag") as? EersteVraagVC {
            vc.onButton = feedback
            self.pushViewController(vc, animated: true)
            }
        }


    // Wordt aangeroepen als gebruiker op een button tapt.
    func feedback(antwoord: String) {
        let vanVc = topViewController!
        let vanVcTitel = vanVc.title!

        print("Gebruiker geeft antwoord '\(antwoord)' op viewcontroller '\(vanVcTitel)'")
        antwoorden[vanVcTitel] = antwoord

        if vanVcTitel == "Eerste" {
            if let vc = storyboard?.instantiateViewControllerWithIdentifier("tweedevraag") as? TweedeVraagVC {
                vc.onButton = feedback
                self.pushViewController(vc, animated: true)
                }
            }
        else if vanVcTitel == "Tweede" {
            if let vc = storyboard?.instantiateViewControllerWithIdentifier("derdevraag") as? DerdeVraagVC {
                vc.onButton = feedback
                self.pushViewController(vc, animated: true)
                }
            }
        else if vanVcTitel == "Derde" {
            if let vc = storyboard?.instantiateViewControllerWithIdentifier("uitslag") as? UitslagVC {
                vc.onButton = feedback
                self.pushViewController(vc, animated: true)
                }
            }
        else if vanVcTitel == "Uitslag" {
            self.dismissViewControllerAnimated(false, completion: nil)
            }
        }

}
