
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


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
        }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FileCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FileCell")
            }
        // Determine filename, read in metadata from saved locations file.
        let fn = files[indexPath.row]
        let (_, meta) = loadWaypoints(fn)
        // Nice title and detail text to display.
        let distance = meta["totalDistance"]!
        let walkDate = meta["walkDate"]!
        let walkTimes = meta["walkTimes"]!
        let title = "\(walkDate), \(walkTimes)"
        let detail = "\(distance)"
        //
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = detail
        return cell!
        }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let fn = docdirfilenaam(files[indexPath.row])
                try FileManager.default.removeItem(atPath: fn)
                files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                }
            catch {
                let err = error as NSError
                print(err.localizedDescription)
                }
            }
        }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWalk" {
            let showWalkVC = segue.destination as! BekijkWandelingController
            let selectedCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)!
            showWalkVC.filenaam = files[indexPath.row]
            }
        }


    }