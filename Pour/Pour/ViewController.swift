//
//  ViewController.swift
//  Pour
//
//  Created by User on 2016-02-15.
//  Copyright © 2016 motoom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vesselView: VesselView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/* Als je labels wilt updaten:

When using AutoLayout you should not update the frame property, instead modify the contraints on a view. -> dus een outlet maken naar de constraint 'breedte van vesselview'?

On the other hand, you could also let AutoLayout work for you. Make sure the numberOfLines property of the label is set to 0 and the height constraint is of type Greater Than or Equal (>=). This way the layout will update automatically after setting new text on a label.

*/

    @IBAction func adjustWidth(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        var adjustedFrame = vesselView.frame;
        adjustedFrame.size.width = CGFloat(roundedValue)
        vesselView.frame = adjustedFrame
        vesselView.recalcMetrics()
        vesselView.setNeedsDisplay()
        }

    @IBAction func adjustHeight(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        var adjustedFrame = vesselView.frame;
        adjustedFrame.size.height = CGFloat(roundedValue)
        vesselView.frame = adjustedFrame
        vesselView.setNeedsDisplay()
        vesselView.recalcMetrics()
    }


    @IBAction func adjustCapacity(sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        vesselView.capacity = CGFloat(roundedValue)
        vesselView.setNeedsDisplay()
        vesselView.recalcMetrics()
    }


    @IBAction func adjustContents(sender: UISlider) {
        vesselView.contents = CGFloat(sender.value)
        vesselView.setNeedsDisplay()
        vesselView.recalcMetrics()
    }

}

