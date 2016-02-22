
import UIKit

class Vessel
{
    var capacity: CGFloat = 8
    var contents: CGFloat = 4

    func isEmpty() -> Bool {
        return contents < CGFloat(1.0)
        }

    func isFull() -> Bool {
        return contents >= capacity
        }

}
