
import UIKit

class GameController: UIViewController {

    // Model
    var vessels = [Vessel(), Vessel(), Vessel(), Vessel(), Vessel()]

    // Views
    @IBOutlet var vesselViews: [VesselView]!

    // Controller
    var activeVessels = 5

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!

    @IBAction func three(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = true
        vesselViews[4].hidden = true
        activeVessels = 3
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func four(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = true
        activeVessels = 4
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func five(sender: UIBarButtonItem) {
        pouring = false
        vesselViews[3].hidden = false
        vesselViews[4].hidden = false
        activeVessels = 5
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
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

    var pouring: Bool = false
    var litresPerTick: CGFloat = 0
    var sourceVessel: VesselView?
    var destinationVessel: VesselView?
    var sourceFinalContents = 0
    var destinationFinalContents = 0
    var timer: NSTimer? = nil

    func timerTick() {
        if !pouring {
            return
            }
        if let src = sourceVessel, dst = destinationVessel {
            src.vessel.contents -= litresPerTick
            dst.vessel.contents += litresPerTick
            // Test end of pouring
            if src.vessel.contents <= CGFloat(sourceFinalContents) ||
                dst.vessel.contents >= CGFloat(destinationFinalContents) {
                    src.vessel.contents = CGFloat(sourceFinalContents)
                    dst.vessel.contents = CGFloat(destinationFinalContents)
                    pouring = false
                    }
            src.setNeedsDisplay()
            dst.setNeedsDisplay()
            }
        }


    func randomVesselWithContent() -> VesselView? {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vesselViews[i].isEmpty() {
                return vesselViews[i]
                }
            }
        }


    func randomVesselNotFull() -> VesselView? {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vesselViews[i].isFull() {
                return vesselViews[i]
                }
            }
        }


    func initiateRandomPouring() {
        // Pick two eligible vessels
        repeat {
            sourceVessel = randomVesselWithContent()
            destinationVessel = randomVesselNotFull()
            } while (sourceVessel == destinationVessel)
        // How much can we pour?
        let room = destinationVessel!.vessel.capacity - destinationVessel!.vessel.contents
        var quantity = sourceVessel!.vessel.contents
        if quantity > room {
            quantity = room
            }
        //
        litresPerTick = quantity / 10
        sourceFinalContents = Int(sourceVessel!.vessel.contents) - Int(quantity)
        destinationFinalContents = Int(destinationVessel!.vessel.contents) + Int(quantity)
        pouring = true
        }

    func randomizeVessels() {
        var totalContents: CGFloat = 0
        for vesselView in vesselViews {
            let cap = arc4random_uniform(12) + 4
            vesselView.vessel.capacity = CGFloat(cap)
            let cont = CGFloat(arc4random_uniform(cap))
            totalContents += cont
            vesselView.vessel.contents = cont
            vesselView.setNeedsDisplay()
            }
        // Make sure there is at least 1 litre of fluid in the system.
        if totalContents < 1 {
            vesselViews[0].vessel.contents = 1
            vesselViews[0].setNeedsDisplay()
            }
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
        // The other vessels will position them after the first one.
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< Design.maxVesselCount {
            vesselViews[i].vessel = vessels[i]
            }
        positionVessels()
        randomizeVessels()
        }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        }

    @IBAction func backFromPreview(segue: UIStoryboardSegue) {
        }
    }
