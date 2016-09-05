
//  QuotesController.swift

import UIKit

class QuotesController: UITableViewController, QuoteProtocol {

    var db: QuotesDatabase!
    var quoteids: [Int] = []
    var needids = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // De database
        db = QuotesDatabase.sharedInstance

        // Dynamically sized table cells.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Fetch array of quote id's to show
        if needids {
            quoteids = db.select("")
            needids = false
            print(quoteids)
            }
        return quoteids.count
        }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuoteCell", forIndexPath: indexPath) as! QuoteCell
        if let q = db.fetchone(quoteids[indexPath.row]) { // TODO: Record id
            cell.authorLabel.text = q.author
            cell.quoteLabel.text = q.quote
            }
        else {
            cell.authorLabel.text = "Program error"
            cell.quoteLabel.text = "Record id #\(indexPath.row) not found in database"
            }
        return cell
        }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
        }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            db.delete(quoteids[indexPath.row])
            quoteids.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }

    var quoteId: Int? = nil

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? QuoteController {
            vc.delegate = self
            if segue.identifier == "Edit" {
                let tableView = self.view as! UITableView
                self.quoteId = quoteids[tableView.indexPathForSelectedRow!.row]
                }
            else if segue.identifier == "Add" {
                self.quoteId = nil
                }
            }
        }

    func getId() -> Int? {
        return self.quoteId
        }

    func getQuote(id: Int) -> Quote? {
        return db.fetchone(id)
        }

    func updateQuote(id: Int, _ author: String, _ quote: String) {
        db.update(id, author, quote)
        if let quoterow = quoteids.indexOf(id) {
            let indexPath = NSIndexPath(forRow: quoterow, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }

    func addQuote(author: String, _ quote: String) -> Int {
        let recordid = db.insert(author, quote)
        quoteids.append(recordid)
        print(quoteids)
        tableView.reloadData()
        let indexPath = NSIndexPath(forRow: quoteids.count - 1, inSection: 0)
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            })
        return recordid
        }

    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

