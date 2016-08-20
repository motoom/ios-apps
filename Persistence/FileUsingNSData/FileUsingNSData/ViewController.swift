
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!

    @IBAction func done() {
        let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let filename = docdir.URLByAppendingPathComponent("verhaal.txt").path!

        // Maak een NSData van de tekst in het textField, en save die.
        if let data = textField.text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                try data.writeToFile(filename, options: .AtomicWrite)
                textField.backgroundColor = UIColor.greenColor()
                }
            catch let error as NSError {
                print(error.localizedDescription)
                }
            }
        }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let docdir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let filename = docdir.URLByAppendingPathComponent("verhaal.txt").path!

        // Lees de inhoud van de file als een stel bytes in een NSData, decodeer met UTF8 naar een stel characters in een NSString, maak dan een Swift String van de NSString:
        if let data = NSData(contentsOfFile: filename) {
            if let ns = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let s = String(ns)
                textField.text = s
                }
            }

        // Het kan ook direct in een String constructor, omdat de file alleen maar tekst bevat.
        let s = try? String(contentsOfFile: filename, encoding: NSUTF8StringEncoding)
        if s != nil {
            textField.text = s
            }
        }
}

