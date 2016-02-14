

import UIKit

class ViewController: UIViewController {

    var difficulty = minDifficulty + 10 // Initial maze difficulty
    var rows = 0  // Maze size in cells
    var cols = 0
    var maze: Maze?
    var aspect = 0.0 // <0:portrait (320:480=0.6), >0=landscape (4:3 = 1.33)
    var startpinchscale = 0.0
    var startpinchdifficulty = 0


    @IBOutlet weak var mazeView: MazeView!


    @IBAction func githubTapped(sender: UIButton) {
        let url = sender.titleLabel!.text!
        UIApplication.sharedApplication().openURL(NSURL(string: "https://" + url)!)
        }


    @IBAction func pinchAction(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            startpinchscale = Double(sender.scale)
            startpinchdifficulty = rows
            }
        else if sender.state == .Changed {
            let zoom = startpinchscale / Double(sender.scale)
            difficulty = Int(Double(startpinchdifficulty) * zoom)
            difficulty = max(minDifficulty, min(difficulty, maxDifficulty))
            generateMaze()
            }
        }


    @IBAction func longpressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            generateMaze()
            }
        }


    @IBAction func tapAction(sender: UITapGestureRecognizer) {
        // generateMaze()
        }


    override func viewDidLayoutSubviews() {
        aspect = Double(mazeView.frame.width) / Double(mazeView.frame.height)
        generateMaze()
        }


    func generateMaze() {
        if aspect < 1 {
            // portrait: more rows than columns
            rows = difficulty
            cols = Int(Double(difficulty) * aspect)
            }
        else {
            // landscape: more columns than rows
            cols = difficulty
            rows = Int(Double(difficulty) / aspect)
            }
        maze = Maze(rows, cols)
        mazeView.maze = maze
        mazeView.setNeedsDisplay()
        }

}
