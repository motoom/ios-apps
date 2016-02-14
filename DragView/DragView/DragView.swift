
import UIKit

class DragView: UIView
{

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        // Filled disc
        // CGContextAddEllipseInRect(context, rect)
        // CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        // CGContextFillPath(context)

        // Outlined circle
        CGContextAddEllipseInRect(context, CGRectInset(rect, 4, 4))
        CGContextSetLineWidth(context, 4.0)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextStrokePath(context)


        }
}
