
// ViewController
import UIKit

class ViewController: UIViewController {
    @IBOutlet var arrowView: ArrowView!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            arrowView.start = sender.locationInView(arrowView)
            arrowView.end = nil
            arrowView.setNeedsDisplay()
            }
        else if sender.state == .Changed {
            arrowView.end = sender.locationInView(arrowView)
            arrowView.setNeedsDisplay()
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        }

}
