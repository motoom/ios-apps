
import UIKit

class MazeView: UIView {
    var maze: Maze!

    override func drawRect(rect: CGRect) {
        // Determine size of maze in points.
        let ruimte = min(frame.width, frame.height) * 0.95
        let cellsize = Int(ruimte) / maze.colcount
        let mazew = cellsize * maze.colcount
        let mazeh = cellsize * maze.rowcount

        // Center maze on view.
        let offx = Int(frame.width) / 2 - mazew / 2
        let offy = Int(frame.height) / 2 - mazeh / 2

        // Draw maze.
        let p = UIBezierPath()

        // North wall.
        p.moveToPoint(CGPoint(x: offx, y: offy))
        p.addLineToPoint(CGPoint(x: offx + mazew - cellsize, y: offy))

        var r = 0
        while r < maze.rowcount {
            var c = 0
            let celly = offy + cellsize * r
            let cellx = offx + cellsize * c
            // West wall.
            if r < maze.rowcount - 1 {
                p.moveToPoint(CGPoint(x: cellx, y: celly))
                p.addLineToPoint(CGPoint(x: cellx, y: celly + cellsize))
                }
            while c < maze.colcount {
                let cellx = offx + cellsize * c
                if maze.cells[r][c] & WALLSOUTH != 0 {
                    if maze.cells[r][c] & WALLEAST != 0 {
                        // South and east wall.
                        p.moveToPoint(CGPoint(x: cellx, y: celly + cellsize))
                        p.addLineToPoint(CGPoint(x: cellx + cellsize, y: celly + cellsize))
                        p.addLineToPoint(CGPoint(x: cellx + cellsize, y: celly))
                        }
                    else {
                        // South wall only.
                        p.moveToPoint(CGPoint(x: cellx, y: celly + cellsize))
                        p.addLineToPoint(CGPoint(x: cellx + cellsize, y: celly + cellsize))
                        }
                    }
                else {
                    if maze.cells[r][c] & WALLEAST != 0 {
                        // East wall only.
                        p.moveToPoint(CGPoint(x: cellx + cellsize, y: celly))
                        p.addLineToPoint(CGPoint(x: cellx + cellsize, y: celly + cellsize))
                        }
                    }
                c++;
                }
            r++;
            }

        // UIColor(red: 0.09, green: 0.27, blue: 0.46, alpha: 1).setStroke() // Dark blue.
        p.lineWidth = 3
        p.lineCapStyle = .Round
        p.lineJoinStyle = .Round
        UIColor.darkGrayColor().setStroke()
        p.stroke()
        let translate = CGAffineTransformMakeTranslation(-1, -1)
        p.applyTransform(translate)
        UIColor.lightGrayColor().setStroke()
        p.stroke()
        }

}
