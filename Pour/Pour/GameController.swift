
import UIKit

class GameController: UIViewController {

    // Database of puzzles
    var puzzles = Puzzles()
    
    // Model
    var vessels = [Vessel(), Vessel(), Vessel(), Vessel(), Vessel()]

    // Views
    @IBOutlet var vesselViews: [VesselView]!

    // Controller
    var activeVessels = 3

    // GUI - for determining the height of the toolbar
    @IBOutlet weak var toolbar: UIToolbar!

    // GUI - for positioning of the leftmost vessel view
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!

    // GUI - for goal content and current state
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    // Sounds
    var soundManager = SoundManager()


    var firstRun = true
    var settingDifficulty = 6
    var targetContent = 0

    var needPositioning = true
    var sourceSelected: Int? // index of source vessel selected by player, nil if not (yet) selected
    var destinationSelected: Int? // index of destination vessel selected by player, nil if not (yet) selected
    var instructionsGiven = false

    var pouring: Bool = false
    var litresPerTick: CGFloat = 0
    var source = 0 // index of source vessel during a pour
    var destination = 0 // index of destination vessel during a pour
    var sourceFinalContents = 0
    var destinationFinalContents = 0
    var pourTimer: NSTimer? = nil

    var initiateDrainTimer: NSTimer? = nil
    var drainTimer: NSTimer? = nil


    // MARK: Vessel initialisation.

    override func viewDidLoad() {
        super.viewDidLoad()
        }


    // This also gets called if label texts change. Inconvenient!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstRun {
            three(UIBarButtonItem()) // Initial puzzle.
            firstRun = false
            }
        if needPositioning {
            positionVessels()
            needPositioning = false
            }
        for i in 0 ..< vesselViews.count {
            vesselViews[i].origBounds = vesselViews[i].bounds
            }
        }


    func positionVessels() {
        let spacing: CGFloat = 4
        let aspect: CGFloat = 2.2
        var vesselw = round((view.frame.width - 5 * spacing) / 5)
        var vesselh = vesselw * aspect
        let availableh = view.frame.height - toolbar.frame.height
        if vesselh > availableh {
            vesselh = availableh * 0.95
            vesselw = vesselh / aspect
            }
        let vesselsw = CGFloat(activeVessels) * (vesselw + spacing)
        width.constant = vesselw
        height.constant = vesselh
        leading.constant = view.frame.width / 2 - vesselsw / 2 + 4
        top.constant = view.frame.height / 2 - toolbar.frame.height / 2 - vesselh / 2
        // The other vessel views will position them after the first one.
        }


    func updateVessels(fromPuzzle puzzle: Puzzle) {
        activeVessels = puzzle.vesselCount

        if !instructionsGiven {
            stateLabel.text = "move your finger from source to destination"
            }
        targetContent = puzzle.targetContent
        targetLabel.text = "measure \(targetContent) litres"
        for i in 0 ..< puzzle.vesselCount {
            vessels[i].capacity = CGFloat(puzzle.capacity[i])
            vessels[i].contents = CGFloat(puzzle.content[i])
            }

        for i in 0 ..< puzzle.vesselCount {
            vesselViews[i].capacity = vessels[i].capacity
            vesselViews[i].contents = vessels[i].contents
            }
        }


    // MARK: Player input


    @IBAction func three(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = true
        vesselViews[4].hidden = true
        let puzzle = puzzles.randomPuzzle(3, difficulty: settingDifficulty)
        needPositioning = true
        view.setNeedsUpdateConstraints()
        updateVessels(fromPuzzle: puzzle)
        }


    @IBAction func four(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = true
        let puzzle = puzzles.randomPuzzle(4, difficulty: settingDifficulty)
        needPositioning = true
        view.setNeedsUpdateConstraints()
        updateVessels(fromPuzzle: puzzle)
        }


    @IBAction func five(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = false
        let puzzle = puzzles.randomPuzzle(5, difficulty: settingDifficulty)
        needPositioning = true
        view.setNeedsUpdateConstraints()
        updateVessels(fromPuzzle: puzzle)
        }


    @IBAction func pan(sender: UIPanGestureRecognizer) {
        // Dragging from source to destination vessel
        if pouring {
            return
            }
        if sender.state == .Began {
            let point = sender.locationOfTouch(0, inView: nil)
            let subview = view.hitTest(point, withEvent: nil)
            if let aboveVesselView = subview as? VesselView {
                // Began dragging on a vessel
                if vessels[aboveVesselView.tag].contents > 0 {
                    sourceSelected = aboveVesselView.tag
                    if !instructionsGiven {
                        stateLabel.text = "point to the destination"
                        }
                    }
                }
            }
        else if sender.state == .Changed {
            if sourceSelected == nil {
                return
                }
            let point = sender.locationOfTouch(0, inView: nil)
            let subview = view.hitTest(point, withEvent: nil)
            if let aboveVesselView = subview as? VesselView {
                destinationSelected = aboveVesselView.tag
                }
            else {
                destinationSelected = nil
                }
            }
        else if sender.state == .Ended {
            if sourceSelected == nil {
                return
                }
            if let src = sourceSelected, dst = destinationSelected {
                if pourValid(src, dst) {
                    initiatePouring(src, dst)
                    stateLabel.text = ""
                    if !instructionsGiven {
                        instructionsGiven = true
                        }
                    }
                }
            sourceSelected = nil
            destinationSelected = nil
            }
        }


    @IBAction func start(sender: UIBarButtonItem) {
        initiateRandomPouring()
        }


    // MARK: Gameplay logic


    func pourValid(src: Int, _ dst: Int) -> Bool {
        if src == dst {
            // Pouring a vessel into itself.
            return false
            }
        if vessels[src].contents == 0 {
            // Source vessel is empty.
            return false
            }
        if vessels[dst].contents >= vessels[dst].capacity {
            // Destination vessel is full.
            return false
            }
        return true
        }


    func initiatePouring(src: Int, _ dst: Int) {
        // How much can we pour?
        let room = vessels[dst].capacity - vessels[dst].contents
        var quantity = vessels[src].contents
        if quantity > room {
            quantity = room
            }

        // The goals, in integer, to avoid accumulating floating point roundoff errors.
        sourceFinalContents = Int(vessels[src].contents) - Int(quantity)
        destinationFinalContents = Int(vessels[dst].contents) + Int(quantity)

        // Calculate how long should the pouring animation should take, and Go!
        source = src
        destination = dst
        litresPerTick = quantity / 10
        pouring = true
        soundManager.sndPour()

        // Start pouring timer.
        if pourTimer == nil {
            pourTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "timerTick", userInfo: nil, repeats: true)
            }
        }


    // Small animation step, called about 20 times per second.
    func timerTick() {
        if !pouring {
            return
            }
        vessels[source].contents -= litresPerTick
        vessels[destination].contents += litresPerTick

        // Update views.
        vesselViews[source].contents = vessels[source].contents
        vesselViews[destination].contents = vessels[destination].contents

        // Test whether the end of the pour is reached.
        if vessels[source].contents <= CGFloat(sourceFinalContents) ||
            vessels[destination].contents >= CGFloat(destinationFinalContents) {
                vessels[source].contents = CGFloat(sourceFinalContents)
                vessels[destination].contents = CGFloat(destinationFinalContents)
                pouring = false
                if let tim = pourTimer {
                    tim.invalidate()
                    pourTimer = nil
                    }
                soundManager.sndStop()
                // Look if any vessel contains the target contents.
                var winningVessel: Int?
                for i in 0 ..< activeVessels {
                    if Int(vessels[i].contents) == targetContent {
                        winningVessel = i
                        break
                        }
                    }

                // If so, player solved the puzzle.
                if let win = winningVessel {
                    // Animate some winning animation on the vessel that contains the targetCapacity
                    vesselViews[win].animGrow()
                    initiateDrainTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "initiateDrain", userInfo: nil, repeats: false)
                    }
                }
        }


    func initiateDrain() {
        // Drain. Aim to complete in 4 seconds; the drain sound lasts 3 seconds.
        soundManager.sndDrain()
        var largestContents: CGFloat = 0
        for i in 0 ..< activeVessels {
            largestContents = max(vessels[i].contents, largestContents)
            }
        litresPerTick = largestContents / 20
        drainTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "drainTick", userInfo: nil, repeats: true)
        }


    // Small animation step, called about 20 times per second.
    func drainTick() {
        // Drain a bit from all vessels
        var totalContents: CGFloat = 0
        for i in 0 ..< activeVessels {
            vessels[i].contents -= litresPerTick
            if vessels[i].contents < 0 {
                vessels[i].contents = 0
                }
            vesselViews[i].contents = vessels[i].contents
            totalContents += vessels[i].contents
            }

        // Test whether the end of the pour is reached.
        if totalContents <= 0 {
            if let tim = drainTimer {
                tim.invalidate()
                drainTimer = nil
                }
            }
        }




    // MARK: Demo functions


    // Pick any vessel which has some fluid in it.
    func randomVesselWithContent() -> Int {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isEmpty() {
                return i
                }
            }
        }


    // Pick any vessel which is not entirely filled.
    func randomVesselNotFull() -> Int {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isFull() {
                return i
                }
            }
        }


    // Pick two eligible vessels, and pour between them.
    func initiateRandomPouring() {
        repeat {
            source = randomVesselWithContent()
            destination = randomVesselNotFull()
            } while (source == destination)
        initiatePouring(source, destination)
        }


    @IBAction func backFromPreview(segue: UIStoryboardSegue) {
        }

    }
