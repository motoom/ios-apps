
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

    // GUI - for goal content and current state
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    var settingDifficulty = 6
    var firstRun = true
    var needPositioning = true
    var sourceTapped: Int?
    var destinationTapped: Int?
    var pouring: Bool = false
    var litresPerTick: CGFloat = 0
    var source = 0 // index of source vessel during a pour
    var destination = 0 // index of destination vessel during a pour
    var sourceFinalContents = 0
    var destinationFinalContents = 0
    var prePourTimer: NSTimer? = nil
    var pourTimer: NSTimer? = nil

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


    func updateVessels(fromPuzzle puzzle: Puzzle) {
        activeVessels = puzzle.vesselCount

        stateLabel.text = "tap the source"
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


    // MARK: Gameplay logic

    func pourValid(source: Int, destination: Int) -> Bool {
        if source == destination {
            // Pouring a vessel into itself.
            return false
            }
        if vessels[source].contents == 0 {
            // Source vessel is empty.
            return false
            }
        if vessels[destination].contents >= vessels[destination].capacity {
            // Destination vessel is full.
            return false
            }
        return true
        }

    func resetVesselSelection() {
        if let sourceIndex = sourceTapped {
            vesselViews[sourceIndex].animNormal()
            sourceTapped = nil
            }
        if let destinationIndex = destinationTapped {
            vesselViews[destinationIndex].animNormal()
            destinationTapped = nil
            }
        stateLabel.text = "tap the source"
        }

    @IBAction func tap(sender: UITapGestureRecognizer) {
        if pouring {
            return
            }
        let point = sender.locationOfTouch(0, inView: nil)
        let subview = view.hitTest(point, withEvent: nil)
        if let tappedView = subview as? VesselView {
            // Tapped on a vessel
            if sourceTapped == nil {
                if vessels[tappedView.tag].contents > 0 {
                    sourceTapped = tappedView.tag
                    tappedView.animShrink()
                    stateLabel.text = "tap the destination"
                    }
                }
            else if destinationTapped == nil {
                if vessels[tappedView.tag].contents >= vessels[tappedView.tag].capacity {
                    prePourTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "resetVesselSelection", userInfo: nil, repeats: false)
                    }
                else {
                    destinationTapped = tappedView.tag
                    source = sourceTapped!
                    destination = destinationTapped!
                    if pourValid(source, destination: destination) {
                        tappedView.animGrow()
                        sourceTapped = nil
                        destinationTapped = nil
                        prePourTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "initiatePouring", userInfo: nil, repeats: false)
                        }
                    else {
                        prePourTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "resetVesselSelection", userInfo: nil, repeats: false)
                        }
                    }
                }
            }
        else {
            // Tapped on anything but a vessel.
            resetVesselSelection()
            }
    }

    @IBAction func pan(sender: UIPanGestureRecognizer) {
        // TODO: Maybe dragging from source to destination vessel is better than tapping them?
        print("pan")
        }





    @IBAction func start(sender: UIBarButtonItem) {
        initiateRandomPouring()
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
                if let tim = pourTimer {
                    tim.invalidate()
                    pourTimer = nil
                    }
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

    func initiatePouring() {
        // Start pouring timer
        if pourTimer == nil {
            pourTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "timerTick", userInfo: nil, repeats: true)
            }
        // How much can we pour?
        let room = vessels[destination].capacity - vessels[destination].contents
        var quantity = vessels[source].contents
        if quantity > room {
            quantity = room
            }
        // Aim for one second
        litresPerTick = quantity / 10
        sourceFinalContents = Int(vessels[source].contents) - Int(quantity)
        destinationFinalContents = Int(vessels[destination].contents) + Int(quantity)
        vesselViews[source].animNormal(1.0)
        vesselViews[destination].animNormal(1.0)
        pouring = true
        }


    func initiateRandomPouring() {
        // Pick two eligible vessels
        repeat {
            source = randomVesselWithContent()
            destination = randomVesselNotFull()
            } while (source == destination)
        vesselViews[source].animShrink()
        vesselViews[destination].animGrow()
        prePourTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "initiatePouring", userInfo: nil, repeats: false)
        }



    @IBAction func backFromPreview(segue: UIStoryboardSegue) {
        }
    }
