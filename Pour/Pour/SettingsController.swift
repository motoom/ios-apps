
import UIKit

class SettingsController: UIViewController {
    var vesselCount = 3
    var difficulty = 5

    @IBOutlet weak var vesselSlider: UISlider!
    @IBOutlet weak var difficultySlider: UISlider!


    @IBAction func adjustVessels(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        vesselCount = Int(sender.value)
        }

    @IBAction func adjustDifficulty(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        difficulty = Int(sender.value)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        vesselSlider.value = Float(vesselCount)
        difficultySlider.value = Float(difficulty)
        }


    }

