
import UIKit

class GameController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var vessels: [VesselView]!

    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!

    @IBAction func three(sender: UIBarButtonItem) {
        vessels[3].hidden = true
        vessels[4].hidden = true
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func four(sender: UIBarButtonItem) {
        vessels[3].hidden = false
        vessels[4].hidden = true
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func five(sender: UIBarButtonItem) {
        vessels[3].hidden = false
        vessels[4].hidden = false
        positionVessels()
        view.setNeedsUpdateConstraints()
        randomizeVessels()
        }

    @IBAction func start(sender: UIBarButtonItem) {
        }

    @IBAction func stop(sender: UIBarButtonItem) {
        }

    func randomizeVessels() {
        for vessel in vessels {
            let cap = arc4random_uniform(12) + 4
            print(cap)
            vessel.capacity = CGFloat(cap)
            vessel.contents = CGFloat(arc4random_uniform(cap))
            vessel.setNeedsDisplay()
            }
        }

    func positionVessels() {
        // Layout voor eerste vessel (aspect 2.7)
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
