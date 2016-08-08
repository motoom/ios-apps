
//  ViewController.swift

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var mapView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // print(mapView.bounds)
        // print(mapView.frame)
        // print(mapView.image)
        scroller.delegate = self
        // scroller.contentSize.width=5500;
        // scroller.contentSize.height=4388;
        scroller.contentSize.width=mapView.image!.size.width;
        scroller.contentSize.height=mapView.image!.size.height;
        scroller.setContentOffset(CGPoint(x: 3060, y: 1360), animated: false)
    }

    // Zooming

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        // print("zoom: viewForZoomingInScrollView")
        return mapView
        }

    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        print("zoom: scrollViewWillBeginZooming")
        }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("zoom: scrollViewDidEndZooming")
        }

    // Scrolling

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // print("scroll: scrollViewDidScroll")
        }

    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        print("scroll: scrollViewDidScrollToTop")
        }


    // Panning/dragging

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("drag: scrollViewWillBeginDragging")
        }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("drag: scrollViewDidEndDragging")
        }
}

