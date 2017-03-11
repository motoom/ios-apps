
//  SettingsViewController.swift

import UIKit

protocol SettingsProtocol {
    func getFootstepsGoal() -> Int
    func setFootstepsGoal(value: Int)
    }

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let stappen = [1000, 2000, 5000, 10000, 15000]
    var settingDelegate: SettingsProtocol? = nil

    @IBOutlet weak var stepsPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate=settingDelegate, let row = stappen.index(of: delegate.getFootstepsGoal()) {
            stepsPicker.selectRow(row, inComponent: 0, animated: false)
            }
        }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stappen.count
        }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localizedInt(stappen[row]) // TODO uitzoeken waarom niet werkt op simulator
        }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingDelegate?.setFootstepsGoal(value: stappen[row])
        }

}
