
//  ViewController.swift

import UIKit

// Nog uitzoeken: Hoe ga je om met schemawijzigingen in je property lists?

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var artikelEdit: UITextField! {
        didSet {artikelEdit.delegate = self}
        }

    @IBOutlet weak var kwaliteitEdit: UITextField! {
        didSet {kwaliteitEdit.delegate = self}
        }

    @IBOutlet weak var leverancierEdit: UITextField! {
        didSet {leverancierEdit.delegate = self}
        }

    @IBOutlet weak var opslaanButton: UIButton!


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }


    @IBAction func opslaan() {
        // Maak een dictionary van de ingevulde waarden.
        var d = [String: String]()
        d["artikel"] = artikelEdit.text
        d["kwaliteit"] = kwaliteitEdit.text
        d["leverancier"] = leverancierEdit.text

        // Sla op als property list in de app's Documents directory.
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = (dir as NSString).stringByAppendingPathComponent("artikel.plist")
        (d as NSDictionary).writeToFile(path, atomically: true)

        // TIP: run dit op een echt iDevice, dan in Xcode, Window/Devices kiezen, het iDevice kiezen en het tandwieltje 'Download Container'. Vervolgens op desktop opslaan, show package contents, en plist laten zien in Documents directory.

        opslaanButton.setTitle("Opgeslagen", forState: .Normal)
        }


    override func viewWillAppear(animated: Bool) {
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = (dir as NSString).stringByAppendingPathComponent("artikel.plist")

        if let d = NSDictionary(contentsOfFile: path) as? Dictionary<String,String> {
            artikelEdit.text = d["artikel"]
            kwaliteitEdit.text = d["kwaliteit"]
            leverancierEdit.text = d["leverancier"]
            }
        }

        
}

