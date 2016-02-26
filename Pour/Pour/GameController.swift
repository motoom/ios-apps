
import UIKit

class GameController: UIViewController {

    // Database of puzzles
    var puzzles = Puzzles()
    
    // Model
    var vessels = [Vessel(), Vessel(), Vessel(), Vessel(), Vessel()]

    // Views
    @IBOutlet var vesselViews: [VesselView]!

    // Controller
    var activeVessels = 5

    // GUI - for determining the height of the toolbar
    @IBOutlet weak var toolbar: UIToolbar!

    // GUI - for positioning of the leftmost vessel view
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!

    // GUI - for goal content
    @IBOutlet weak var targetLabel: UILabel!

    var pouring: Bool = false
    var litresPerTick: CGFloat = 0
    var source = 0 // source vessel during a pour
    var destination = 0 // destination vessel during a pour
    var sourceFinalContents = 0
    var destinationFinalContents = 0
    var timer: NSTimer? = nil


    @IBAction func three(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = true
        vesselViews[4].hidden = true
        let puzzle = puzzles.randomPuzzle(3, difficulty: 5)
        positionVessels()
        view.setNeedsUpdateConstraints()
        updateVesselViews(puzzle)
        }

    @IBAction func four(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = true
        let puzzle = puzzles.randomPuzzle(4, difficulty: 5)
        positionVessels()
        view.setNeedsUpdateConstraints()
        updateVesselViews(puzzle)
        }

    @IBAction func five(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = false
        let puzzle = puzzles.randomPuzzle(5, difficulty: 5)
        positionVessels()
        view.setNeedsUpdateConstraints()
        updateVesselViews(puzzle)
        }

    func updateVesselViews(puzzle: Puzzle) {
        activeVessels = puzzle.vesselCount

        targetLabel.text = "measure \(puzzle.targetContent) litres"
        for i in 0 ..< puzzle.vesselCount {
            vessels[i].capacity = CGFloat(puzzle.capacity[i])
            vessels[i].contents = CGFloat(puzzle.content[i])
            }

        for i in 0 ..< puzzle.vesselCount {
            vesselViews[i].capacity = vessels[i].capacity
            vesselViews[i].contents = vessels[i].contents
            }
        }



    @IBAction func start(sender: UIBarButtonItem) {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "timerTick", userInfo: nil, repeats: true)
            }
        initiateRandomPouring()
        }

    @IBAction func stop(sender: UIBarButtonItem) {
        if let tim = timer {
            tim.invalidate()
            timer = nil
            }
        }

    func timerTick() {
        if !pouring {
            return
            }
        vessels[source].contents -= litresPerTick
        vessels[destination].contents += litresPerTick
        // Test end of pouring
        if vessels[source].contents <= CGFloat(sourceFinalContents) ||
            vessels[destination].contents >= CGFloat(destinationFinalContents) {
                vessels[source].contents = CGFloat(sourceFinalContents)
                vessels[destination].contents = CGFloat(destinationFinalContents)
                pouring = false
                }
        vesselViews[source].contents = vessels[source].contents
        vesselViews[destination].contents = vessels[destination].contents
        }


    func randomVesselWithContent() -> Int {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isEmpty() {
                return i
                }
            }
        }


    func randomVesselNotFull() -> Int {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isFull() {
                return i
                }
            }
        }


    func initiateRandomPouring() {
        // Pick two eligible vessels
        repeat {
            source = randomVesselWithContent()
            destination = randomVesselNotFull()
            } while (source == destination)
        // How much can we pour?
        let room = vessels[destination].capacity - vessels[destination].contents
        var quantity = vessels[source].contents
        if quantity > room {
            quantity = room
            }
        //
        litresPerTick = quantity / 10
        sourceFinalContents = Int(vessels[source].contents) - Int(quantity)
        destinationFinalContents = Int(vessels[destination].contents) + Int(quantity)
        pouring = true
        }


    func positionVessels() {
        var activevessels = 0
        for vessel in vesselViews {
            if !vessel.hidden {
                activevessels++
                }
            }
        let spacing: CGFloat = 4
        let aspect: CGFloat = 2.2
        var vesselw = round((view.frame.width - 5 * spacing) / 5)
        var vesselh = vesselw * aspect
        let availableh = view.frame.height - toolbar.frame.height
        if vesselh > availableh {
            vesselh = availableh * 0.95
            vesselw = vesselh / aspect
            }
        let vesselsw = CGFloat(activevessels) * (vesselw + spacing)
        width.constant = vesselw
        height.constant = vesselh
        leading.constant = view.frame.width / 2 - vesselsw / 2 + 4
        top.constant = view.frame.height / 2 - toolbar.frame.height / 2 - vesselh / 2
        // The other vessel views will position them after the first one.
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        positionVessels()
        three(UIBarButtonItem())
        }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        }

    @IBAction func backFromPreview(segue: UIStoryboardSegue) {
        }
    }
