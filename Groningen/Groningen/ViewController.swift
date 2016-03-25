
//  ViewController.swift

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.delegate = self
        scroller.contentSize.width=5500;
        scroller.contentSize.height=4388;
        scroller.setContentOffset(CGPoint(x: 3060, y: 1280), animated: false)
    }

    // Zooming

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        print("viewForZoomingInScrollView")
        return mapView
        }

    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        print("scrollViewWillBeginZooming")
        }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        }

    // Scrolling

    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        }

    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
        }


    // Panning/dragging

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        }
}

