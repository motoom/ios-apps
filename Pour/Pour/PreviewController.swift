
import UIKit

class PreviewController: UIViewController {

    var vessel: Vessel!
    
    @IBOutlet weak var vesselView: VesselView!
    @IBOutlet weak var capacitySlider: UISlider!
    @IBOutlet weak var contentsSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        }

/* When using AutoLayout you should not update the frame property, instead modify the contraints on a view.

    On the other hand, you could also let AutoLayout work for you. Make sure the numberOfLines property of the label is set to 0 and the height constraint is of type Greater Than or Equal (>=). This way the layout will update automatically after setting new text on a label.
*/

    @IBOutlet weak var vesselWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthValueLabel: UILabel!

    @IBAction func adjustWidth(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        vesselWidthConstraint.constant = CGFloat(roundedValue)
        vesselView.recalcMetrics()
        vesselView.setNeedsDisplay()
        widthValueLabel.text = String(Int(roundedValue)) + " points"
        }


    @IBOutlet weak var vesselHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightValueLabel: UILabel!

    @IBAction func adjustHeight(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        vesselHeightConstraint.constant = CGFloat(roundedValue)
        vesselView.recalcMetrics()
        vesselView.setNeedsDisplay()
        heightValueLabel.text = String(Int(roundedValue)) + " points"
        }


    @IBOutlet weak var capacityValueLabel: UILabel!

    @IBAction func adjustCapacity(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        vesselView.capacity = CGFloat(roundedValue)
        if vesselView.capacity < vesselView.contents {
            contentsSlider.value = roundedValue
            vesselView.contents = vesselView.capacity
            }
        // vesselView.setNeedsDisplay()
        vesselView.recalcMetrics()
        capacityValueLabel.text = String(Int(roundedValue)) + " litres"
        }


    @IBOutlet weak var contentsValueLabel: UILabel!

    @IBAction func adjustContents(sender: UISlider) {
        vesselView.contents = CGFloat(sender.value)
        if vesselView.capacity < vesselView.contents {
            let ceiledValue = ceil(sender.value)
            capacitySlider.value = ceiledValue
            vesselView.capacity = CGFloat(ceiledValue)
            }
        // vesselView.setNeedsDisplay()
        vesselView.recalcMetrics()
        contentsValueLabel.text = String(format: "%.01f litres", sender.value) // note the printf-like formatting.
        }

    @IBAction func sourceAnim(sender: UIButton) {
        let origFrame: CGRect = self.vesselView.frame
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.vesselView.frame=origFrame.insetBy(dx: 5, dy: 5)
            }) { (done) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.vesselView.frame=origFrame
                }, completion: { (done) -> Void in
                    self.vesselView.frame=origFrame
            })
            }
        }

    @IBAction func destAnim(sender: UIButton) {
          let origFrame: CGRect = self.vesselView.frame
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.vesselView.frame=origFrame.insetBy(dx: -5, dy: -5)
            }) { (done) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.vesselView.frame=origFrame
                }, completion: { (done) -> Void in
                    self.vesselView.frame=origFrame
            })
            }
        }


    }

