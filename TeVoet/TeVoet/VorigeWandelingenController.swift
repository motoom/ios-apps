
// VorigeWandelingenController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit


func documentfiles() -> [String] {
    let directory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    if let urlArray = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(directory, includingPropertiesForKeys: [NSURLNameKey], options: NSDirectoryEnumerationOptions.SkipsHiddenFiles) {
        return urlArray.map{$0.lastPathComponent!}.filter{$0.hasSuffix(".v1.locations")}.sort()
        }
    else {
        return []
        }
    }


// "yyyymmddhhmm" -> "23 aug 2016, 12:03"
func nicedatetime(s: String) -> String
{
    let yyyymmddhhmm = NSDateFormatter()
    yyyymmddhhmm.dateFormat = "yyyyMMddHHmm"
    if let stamp = yyyymmddhhmm.dateFromString(s) {
        return NSDateFormatter.localizedStringFromDate(stamp, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
    else {
        return s
        }
}




class VorigeWandelingenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var files = [String]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        files = documentfiles()
        }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
        }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("FileCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "FileCell")
            }
        cell?.detailTextLabel?.text = files[indexPath.row]
        let fn = files[indexPath.row]
        let stamp = fn.substringToIndex(fn.startIndex.advancedBy(12))
        cell?.textLabel?.text = nicedatetime(stamp)
        return cell!
        }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            do {
                let fn = docdirfilenaam(files[indexPath.row])
                try NSFileManager.defaultManager().removeItemAtPath(fn)
                files.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            catch {
                let err = error as NSError
                print(err.localizedDescription)
                }
            }
        }

    }
