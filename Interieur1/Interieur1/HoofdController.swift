
//  HoofdController.swift

import UIKit

class HoofdController: UIPageViewController, UIPageViewControllerDataSource  {

    var bladzijden: [UIViewController] = []


    override func viewDidLoad() {
        self.dataSource = self
        for identifier in ["eetkamer", "ikea", "klassiek"] {
            if let sub = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) {
                bladzijden.append(sub)
                }
            }
        setViewControllers([bladzijden[0]], direction: .Forward, animated: false, completion: nil)
        }


    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let index = bladzijden.indexOf(viewController) {
            return index > 0 ? bladzijden[index - 1] : nil
            }
        return nil
        }


    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let index = bladzijden.indexOf(viewController) {
            return index < bladzijden.count - 1 ? bladzijden[index + 1] : nil
            }
        return nil
        }
}
