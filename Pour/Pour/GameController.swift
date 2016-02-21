
import UIKit

class GameController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var vessels: [VesselView]!
    var activeVessels = 5

    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!

    @IBAction func three(sender: UIBarButtonItem) {
        pouring = false
        vessels[3].hidden = true
        vessels[4].hidden = true
        activeVessels = 3
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func four(sender: UIBarButtonItem) {
        pouring = false
        vessels[3].hidden = false
        vessels[4].hidden = true
        activeVessels = 4
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func five(sender: UIBarButtonItem) {
        pouring = false
        vessels[3].hidden = false
        vessels[4].hidden = false
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
            src.contents -= litresPerTick
            dst.contents += litresPerTick
            // Test end of pouring
            if src.contents <= CGFloat(sourceFinalContents) ||
                dst.contents >= CGFloat(destinationFinalContents) {
                    src.contents = CGFloat(sourceFinalContents)
                    dst.contents = CGFloat(destinationFinalContents)
                    pouring = false
                    }
            src.setNeedsDisplay()
            dst.setNeedsDisplay()
            }
        }


    func randomVesselWithContent() -> VesselView? {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isEmpty() {
                return vessels[i]
                }
            }
        }


    func randomVesselNotFull() -> VesselView? {
        while true {
            let i = Int(arc4random_uniform(UInt32(activeVessels)))
            if !vessels[i].isFull() {
                return vessels[i]
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
        let room = destinationVessel!.capacity - destinationVessel!.contents
        var quantity = sourceVessel!.contents
        if quantity > room {
            quantity = room
            }
        //
        litresPerTick = quantity / 10
        sourceFinalContents = Int(sourceVessel!.contents) - Int(quantity)
        destinationFinalContents = Int(destinationVessel!.contents) + Int(quantity)
        pouring = true
        }

    func randomizeVessels() {
        var totalContents: CGFloat = 0
        for vessel in vessels {
            let cap = arc4random_uniform(12) + 4
            vessel.capacity = CGFloat(cap)
            let cont = CGFloat(arc4random_uniform(cap))
            totalContents += cont
            vessel.contents = cont
            vessel.setNeedsDisplay()
            }
        // Make sure there is at least 1 litre of fluid in the system.
        if totalContents < 1 {
            vessels[0].contents = 1
            vessels[0].setNeedsDisplay()
            }
        }


    func positionVessels() {
        var activevessels = 0
        for vessel in vessels {
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
        positionVessels()
        randomizeVessels()
        }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        }

    @IBAction func backFromPreview(segue: UIStoryboardSegue) {
        }
    }
