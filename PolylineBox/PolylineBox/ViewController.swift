import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var rotationLabel: UILabel!

    var nr = 0

    override func viewWillLayoutSubviews() {
        let plural = nr != 1 ? "s" : ""
        rotationLabel.text = "\(nr) view layout event\(plural)"
        nr += 1
    }

}
