
import UIKit

class ArrowView: UIView {
    var start: CGPoint?
    var end: CGPoint?

    override func drawRect(rect: CGRect) {
        if let startpoint = start, endpoint = end {
            let path = UIBezierPath.bezierPathWithArrowFromPoint(startpoint, endPoint: endpoint, tailWidth: 20, headWidth: 35, headLength: 40)
            path.fill()
            }
        }

    }
