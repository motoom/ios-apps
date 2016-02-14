
import UIKit

class MazeView: UIView {
    var maze: Maze!

    override func drawRect(rect: CGRect) {
        // Determine size of maze in points.
        let rw = Double(rect.width)
        let rh = Double(rect.height)
        let ruimte = min(rw, rh) * 0.95
        let cellsize = ruimte / Double(maze.colcount)
        let mazew = cellsize * Double(maze.colcount)
        let mazeh = cellsize * Double(maze.rowcount)

        // Center maze on view.
        let offx = rw / 2 - mazew / 2
        let offy = rh / 2 - mazeh / 2

        // Draw maze.
        let p = UIBezierPath()

        // North wall.
        p.moveToPoint(CGPoint(x: offx, y: offy))
        p.addLineToPoint(CGPoint(x: offx + mazew - cellsize, y: offy))

        var r = 0
        while r < maze.rowcount {
            var c = 0
            let celly = offy + cellsize * Double(r)
            let cellx = offx + cellsize * Double(c)
            // West wall.
            if r < maze.rowcount - 1 {
                p.moveToPoint(CGPoint(x: cellx, y: celly))
                p.addLineToPoint(CGPoint(x: cellx, y: celly + cellsize))
                }
            while c < maze.colcount {
                let cellx = offx + cellsize * Double(c)
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
        // Thinner line width for more complex mazes.
        let busiest = max(Double(maze.rowcount), Double(maze.colcount))
        p.lineWidth = CGFloat(lerp2d(Double(minDifficulty), 3,  Double(maxDifficulty), 1, busiest))

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
