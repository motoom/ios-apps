
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
        /*
        var distance = 0.0
        if let d = meta["distance"] {
            if let di = d as? Double {
                distance = di
                }
            }
        var steps = 0
        if let s = meta["steps"] {
            if let st = s as? Int {
                steps = st
                }
            }
        */
        let distance = meta["distance"]! as! Double
        let steps = meta["steps"]! as! Int

        let start = meta["start"]
        let end = meta["end"]

        let walkDate = meta["walkDate"]!
        let walkTimes = meta["walkTimes"]!
        //
        let prettyDistance = sjiekeAfstand(distance)
        let prettySteps = localizedInt(steps)
        //
        let title = "\(walkDate), \(walkTimes)"
        var detail = ""
        if distance > 0 {
            detail += "\(prettyDistance)"
            // speed: km/hr
            if let st = start, let en = end {
                if let s = st as? Date, let e = en as? Date {
                    let durationSeconds = e.timeIntervalSince(s)
                    let durationHours = durationSeconds / 3600.0
                    let distanceKilometers = distance / 1000.0
                    let speed = distanceKilometers / durationHours
                    let fmt = NumberFormatter()
                    fmt.usesGroupingSeparator = true
                    fmt.minimumIntegerDigits = 1
                    fmt.minimumFractionDigits = 0
                    fmt.maximumFractionDigits = 1
                    let prettySpeed = fmt.string(from: NSNumber(value: speed))!
                    detail += ", \(prettySpeed) km/hr"
                    }
                }

            }
        if steps > 0 {
            detail += ", \(prettySteps) stappen"
            // Calculate (and display, if not outrageous), the stride: m/footstep
            let stride = distance / Double(steps)
            if stride < 2 {
                let prettyStride = sjiekeAfstand(stride)
                detail += ", \(prettyStride)/stap "
                }
            }

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
