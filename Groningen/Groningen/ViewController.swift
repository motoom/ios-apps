
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Scroller: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Scroller.contentSize.width=5500;
        Scroller.contentSize.height=4388;
        Scroller.setContentOffset(CGPoint(x: 3060, y: 1280), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

