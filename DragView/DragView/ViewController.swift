//
//  ViewController.swift
//  DragView
//
//  Created by User on 2016-02-14.
//  Copyright © 2016 motoom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet weak var dragLabel: UILabel!

    var dragging: Int? // hashValue of UITouch dragging the view
    var dragoffset: CGPoint = CGPoint()
    // var dragstart: CGPoint = CGPoint()

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if dragView == touch.view {
                print("BEGAN", touch.locationInView(fieldView))
                dragging = touch.hashValue
                dragLabel.text = String(touch.hashValue)
                dragoffset = touch.locationInView(dragView)
                // dragstart = touch.locationInView(fieldView)
                }
            }
        }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.hashValue == dragging {
                print("MOVE", touch.locationInView(fieldView))
                let x = touch.locationInView(fieldView).x - dragoffset.x
                let y = touch.locationInView(fieldView).y - dragoffset.y
                dragView.frame.origin = CGPoint(x: x, y: y)
                }
            }
        }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.hashValue == dragging {
                print("END")
                dragLabel.text = ""
                dragging = nil
                }
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // pan.delaysTouchesEnded = false
        pan.cancelsTouchesInView = false
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

