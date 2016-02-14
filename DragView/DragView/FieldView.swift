
import UIKit

class FieldView: UIView
{
    var points: Array<CGPoint> = []

    func registerPoint(newpoint: CGPoint)
    {
        if points.count == 0 {
            points.append(newpoint)
            return
            }
        var newpoints: Array<CGPoint> = [points[0]]
        var first = true
        for point in points { // TODO: Slice [1:], eliminate 'first' flag.
            if first {
                first = false
                continue
                }
            if distance(point, newpoint) < 10 {
                break
                }
            newpoints.append(point)
            }
        newpoints.append(newpoint)
        points = newpoints
    }


    func reset()
    {
        points = []
    }


    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        var first = true
        for point in points {
            if first {
                path.moveToPoint(point)
                first = false
                }
            else {
                path.addLineToPoint(point)
                }
            }
        path.lineWidth = 2
        UIColor.grayColor().setStroke()
        path.stroke()
        }
}

