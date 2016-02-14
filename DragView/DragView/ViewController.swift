//
//  ViewController.swift
//  DragView
//
//  Created by User on 2016-02-14.
//  Copyright © 2016 motoom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fieldView: FieldView!
    @IBOutlet weak var dragView: DragView!
    @IBOutlet weak var dragLabel: UILabel!
    @IBOutlet var tap: UITapGestureRecognizer!

    var dragging: Int? // hashValue of UITouch dragging the view
    var dragoffset: CGPoint = CGPoint()

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if dragView == touch.view {
                dragging = touch.hashValue
                dragLabel.text = String(touch.hashValue)
                dragoffset = touch.locationInView(dragView)
                }
            }
        }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.hashValue == dragging {
                let x = touch.locationInView(fieldView).x - dragoffset.x
                let y = touch.locationInView(fieldView).y - dragoffset.y
                dragView.frame.origin = CGPoint(x: x, y: y)
                let middle = CGPoint(x: dragView.center.x, y: dragView.center.y)
                let snapped = gridsnap(middle, CGPoint(x: 2, y: 2), CGPoint(x: 30, y: 30))
                fieldView.registerPoint(snapped)
                fieldView.setNeedsDisplay()
                }
            }
        }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.hashValue == dragging {
                dragLabel.text = ""
                dragging = nil
                }
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        tap.cancelsTouchesInView = false
        }

    @IBAction func tapped(sender: UITapGestureRecognizer) {
        fieldView.reset()
        fieldView.setNeedsDisplay()
        }



}

