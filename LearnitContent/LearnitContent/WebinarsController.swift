
// http://stackoverflow.com/questions/24065536/downloading-and-parsing-json-in-swift

// https://www.learnit.nl/api3/lastminutes
// https://www.learnit.nl/api3/webinars
// Doorgangsgaranties (met zoek + uitklap UI)
// Locaties (met UIMapView en routeplanner integratie?)

import UIKit

class WebinarsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var webinarsSpinner: UIActivityIndicatorView!

    @IBOutlet weak var webinarsTable: UITableView!

    var webinarData: [Dictionary<String, AnyObject>]?

    override func viewDidLoad() {
        super.viewDidLoad()
        webinarsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        webinarsTable.hidden = true
        webinarsTable.delegate = self
        webinarsTable.dataSource = self
        }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let url = "https://www.learnit.nl/api3/webinars/"

        let ses = NSURLSession.sharedSession()
        ses.dataTaskWithURL(NSURL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    self.webinarData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [Dictionary<String, AnyObject>]
                    dispatch_async(dispatch_get_main_queue(), {
                        sleep(1) // Emulate slow fetch from webserver
                        self.webinarsSpinner.stopAnimating()
                        self.webinarsTable.hidden = false
                        self.webinarsTable.reloadData()
                        })
                    }
                catch {
                    print("Error, can't fetch")
                    }
                }
        }).resume()
        }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.webinarData {
            return data.count
            }
        return 0
        }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
    if let data = self.webinarData {
        let webinar = data[indexPath.row]
        if let naam = webinar["naam"] as? String {
            cell.textLabel!.text = naam
            }
        if let langedatum = webinar["langedatum"] as? String, aanvangstijd = webinar["aanvangstijd"] as? String {
            cell.detailTextLabel!.text = "\(langedatum), \(aanvangstijd)"
            }
        }
    else {
        cell.textLabel!.text = "Onbekend"
        }
    return cell
    }

}
