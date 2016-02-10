
//  ViewController.swift

import UIKit

class ViewController: UIViewController {
}


class MyView: UIView {
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let (rectw, recth) = (rect.size.width, rect.size.height)
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(rectw, recth))
        path.stroke()
        }
}
