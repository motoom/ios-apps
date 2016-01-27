import Foundation
import UIKit

let MARGINPERC :Double = 2 // Some whitespace around the box (in percentage of screen).

class MainView: UIView {
    override func drawRect(rect: CGRect) {
        var margin, offsetx, offsety, boxw, boxh :Double;
        let (rectw, recth) = (Double(rect.size.width), Double(rect.size.height))

        // Determine margin.
        if rectw > recth {
            margin = recth * MARGINPERC / 100 // Landscape orientation.
            }
        else {
            margin = rectw * MARGINPERC / 100 // Portrait orientation.
            }

        boxw = rectw - 2 * margin
        boxh = recth - 2 * margin

        // Center horizontally and vertically.
        offsetx = rectw / 2 - boxw / 2;
        offsety = recth / 2 - boxh / 2;

        let path = UIBezierPath()

        path.moveToPoint(CGPointMake(CGFloat(offsetx), CGFloat(offsety)))
        path.addLineToPoint(CGPointMake(CGFloat(offsetx + boxw), CGFloat(offsety)));
        path.addLineToPoint(CGPointMake(CGFloat(offsetx + boxw), CGFloat(offsety + boxh)));
        path.addLineToPoint(CGPointMake(CGFloat(offsetx), CGFloat(offsety + boxh)));
        path.addLineToPoint(CGPointMake(CGFloat(offsetx), CGFloat(offsety)))

        path.moveToPoint(CGPointMake(CGFloat(offsetx), CGFloat(offsety)))
        path.addLineToPoint(CGPointMake(CGFloat(offsetx + boxw), CGFloat(offsety + boxh)));

        path.stroke()
        }
    }
