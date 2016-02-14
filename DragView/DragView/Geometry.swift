
import UIKit

func gridsnap(point: CGPoint, _ origin: CGPoint, _ cellsize: CGPoint) -> CGPoint
{
    let x = (CGFloat(Int((point.x - origin.x) / cellsize.x)) * cellsize.x) + origin.x
    let y = (CGFloat(Int((point.y - origin.y) / cellsize.y)) * cellsize.y) + origin.y
    return CGPoint(x: x, y: y)
}

func distance(from: CGPoint, _ to: CGPoint) -> Double
{
    let dx = Double(to.x - from.x)
    let dy = Double(to.y - from.y)
    return sqrt(dx * dx + dy * dy)
}