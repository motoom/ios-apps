
//  ViewController.swift

/* Hoe kun je het Sqlite3 framework toevoegen aan je project:

1. Ga naar je project setting, 'General' tab.
2. Bij Linked Frameworks op de + drukken en 'libsqlite3.tbd' toevoegen.
3. Voeg een header file toe aan het project, noem deze 'BridgingHeader.h', en zet hierin één regel: #include <sqlite3.h>
4. Ga naar je project setting, 'Build Settings', en vind 'Objective-C Bridging Header' (via zoek mogelijkheid).
5. Dubbelklik op de lege ruimte erachter en vul daar 'BridgingHeader.h' in.
6. Sleep 'SqliteDb.swift' in je project.
*/

// Uitzoeken: Hoe ga je om met INTEGER, DOUBLE, DECIMALS en DATE velden in je tabel?

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var naamText: UITextField!
    @IBOutlet weak var nummerText: UITextField!
    @IBOutlet weak var overzichtView: UITextView!
    
    @IBAction func add() {
        let db = TelefoonDb.sharedInstance
        let naam = naamText.text!
        let nummer = nummerText.text!
        db.execute("insert into Nummers(naam, nummer) values('\(naam)', '\(nummer)')")
        naamText.text = ""
        nummerText.text = ""
        updateUI()
        }


    override func viewDidLoad() {
        let db = TelefoonDb.sharedInstance
        if !db.tableExists("Nummers") {
            print("Tabel 'Nummers' bestaat nog niet, aanmaken dus.")
            db.execute("create table Nummers(naam text, nummer text)")
            db.execute("insert into Nummers values('Koen', '061273281')")
            db.execute("insert into Nummers values('Piet', '020128723')")
            }
        updateUI()
        }


    func updateUI() {
        overzichtView.text = "Dit is de inhoud van de database:\n\n"
        let db = TelefoonDb.sharedInstance
        if let rs = db.query("select * from Nummers") {
            for r in rs {
                let naam = r["naam"] ?? ""
                let nummer = r["nummer"] ?? ""
                let regel = "Bel \(naam) op \(nummer)\n"
                overzichtView.text = overzichtView.text + regel
                }
            }
        }
}
