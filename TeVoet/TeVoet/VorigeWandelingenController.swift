
// VorigeWandelingenController.swift
//
// Software by Michiel Overtoom, motoom@xs4all.nl

import UIKit


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


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowWalk" {
            let showWalkVC = segue.destinationViewController as! BekijkWandelingController
            let selectedCell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(selectedCell)!
            showWalkVC.filenaam = files[indexPath.row]
            }
        }


    }
