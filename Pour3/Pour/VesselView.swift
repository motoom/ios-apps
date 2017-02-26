
import UIKit

class VesselView: UIView
{
    var capacity: CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
            }
        }
    var contents: CGFloat = 4 {
        didSet {
            self.setNeedsDisplay()
            }
        }

    // Metrics dependent on view frame (calculated)
    var pointsperliter: CGFloat = 0
    var tilt: CGFloat = 0
    var rim: CGFloat = 0
    var tickwidth: CGFloat = 0
    var contentstextsize: CGFloat = 0
    var heightContentsText: CGFloat = 0
    var capacitytextsize: CGFloat = 0
    var heightCapacityText: CGFloat = 0
    var origBounds: CGRect!

    override init(frame: CGRect) {
        super.init(frame: frame)
        recalcMetrics()
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        recalcMetrics()
        }

    func recalcMetrics() {
        tickwidth = frame.width * Design.tickwidth
        tilt = frame.width * Design.tiltFactor
        contentstextsize = frame.height * Design.contentsTextsizeFactor
        capacitytextsize = frame.height * Design.capacityTextsizeFactor
        heightContentsText = contentstextsize // fontLineHeight(fontSize: contentstextsize)
        heightCapacityText = capacitytextsize // fontLineHeight(fontSize: capacitytextsize)
        pointsperliter = (frame.height - tilt * 2 - Design.insetmargin * 2 - heightContentsText - heightCapacityText) / Design.maxcapacity
        rim = pointsperliter * Design.rimHeight
        // print("VesselView.recalcMetrics frame=", frame, " pointsperliter=", pointsperliter, " heightContentsText=", heightContentsText, " heightCapacityText=", heightCapacityText)
        }

    func debugRect(_ rect: CGRect, color: UIColor) {
        let dp = UIBezierPath.init(rect: rect)
        color.setStroke()
        dp.lineWidth = 0.5
        dp.stroke()
        }

    override func draw(_ rect: CGRect) {
        let paintrect = rect.insetBy(dx: Design.insetmargin, dy: Design.insetmargin)
        // debugRect(paintrect, color: UIColor.brownColor())
        // print("VesselView.drawRect frame=", frame, " rect=", rect)

        var path: UIBezierPath!

        // Textual contents in liters
        let textContentsRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y  + paintrect.height + Design.insetmargin - heightContentsText,
            width: paintrect.width,
            height: heightContentsText
            )

        // Upper rim vessel
        let topRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height + Design.insetmargin - heightContentsText - tilt * 2 - capacity * pointsperliter - rim,
            width: paintrect.width,
            height: tilt * 2)
        // debugRect(topRect, color: UIColor.orangeColor())

        // Textual capacity in liters
        let textCapacityRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height + Design.insetmargin - heightContentsText - tilt * 2 - capacity * pointsperliter - rim - heightCapacityText,
            width: paintrect.width,
            height: heightCapacityText
            )

        // Top of fluid (only used when contents > 0)
        let fluidtopRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height + Design.insetmargin - heightContentsText - tilt * 2 - contents * pointsperliter,
            width: paintrect.width,
            height: tilt * 2)

        // Fluid (only used when contents > 0)
        let fluidRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height + Design.insetmargin - heightContentsText - tilt - contents * pointsperliter,
            width: paintrect.width,
            height: contents * pointsperliter)

        // Bottom of vessel
        let bottomRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height + Design.insetmargin - heightContentsText - tilt * 2,
            width: paintrect.width,
            height: tilt * 2)

        // Draw bottom of vessel
        path = UIBezierPath(ovalIn: bottomRect.insetBy(dx: Design.outlineWidth, dy: Design.outlineWidth))
        path.lineWidth = Design.outlineWidth
        UIColor.black.setStroke()
        if contents > 0 {
            // Clear if empty, fluid color if not empty.
            Design.colorFluid.setFill()
            path.fill()
            }
        path.stroke()

        if contents > 0 {
            // Fluid
            path = UIBezierPath(rect: fluidRect.insetBy(dx: Design.outlineWidth, dy: Design.outlineWidth))
            Design.colorFluid.setFill()
            path.fill()

            // Draw top of fluid (with highlight)
            path = UIBezierPath(ovalIn: fluidtopRect.insetBy(dx: Design.outlineWidth, dy: Design.outlineWidth))
            path.lineWidth = Design.outlineWidth
            Design.colorFluidMeniscus.setStroke()
            Design.colorFluid.setFill()
            path.fill()
            path.stroke()
            }

        // Draw upper rim of vessel
        path = UIBezierPath(ovalIn: topRect.insetBy(dx: Design.outlineWidth, dy: Design.outlineWidth))
        path.lineWidth = Design.outlineWidth
        UIColor.black.setStroke()
        path.stroke()

        // Walls and ticks
        path = UIBezierPath()
        // Left wall
        path.move(to: CGPoint(x: topRect.origin.x + Design.outlineWidth, y: topRect.origin.y + tilt))
        path.addLine(to: CGPoint(x: topRect.origin.x + Design.outlineWidth, y: bottomRect.origin.y + tilt))
        // Right wall
        path.move(to: CGPoint(x: topRect.origin.x + topRect.width - Design.outlineWidth, y: topRect.origin.y + tilt))
        path.addLine(to: CGPoint(x: topRect.origin.x + topRect.width - Design.outlineWidth, y: bottomRect.origin.y + tilt))

        // Ticks
        var liter: CGFloat = 1
        while liter < capacity  {
            path.move(to: CGPoint(
                x: bottomRect.origin.x + bottomRect.width / 2 - tickwidth,
                y: bottomRect.origin.y - Design.outlineWidth + tilt * 2 - liter * pointsperliter))
            path.addLine(to: CGPoint(
                x: bottomRect.origin.x + bottomRect.width / 2 + tickwidth,
                y: bottomRect.origin.y - Design.outlineWidth + tilt * 2 - liter * pointsperliter))
            liter += 1
            }

        path.lineWidth = Design.outlineWidth
        UIColor.black.setStroke()
        path.stroke()

        // Textual contents and capacity, in liters
        let flooredCapacity = String(Int(floor(capacity + 0.2)))
        if flooredCapacity != "0" {
            drawString(textCapacityRect, text: flooredCapacity, fontSize: capacitytextsize)
            }

        let flooredContents = String(Int(floor(contents + 0.2)))
        if flooredContents != "0" {
            drawString(textContentsRect, text: flooredContents, fontSize: contentstextsize, fontColor: UIColor.gray)
            }
        }

    func fontLineHeight(_ fontName: String = "AppleSDGothicNeo-Bold", fontSize: CGFloat = 18.0) -> CGFloat {
        if let font = UIFont(name: fontName, size: fontSize) {
            return font.lineHeight
            }
        return 0
        }

    func drawString(_ rect: CGRect, text: String, fontName: String = "AppleSDGothicNeo-Bold", fontSize: CGFloat = 18.0, fontColor: UIColor = UIColor.black) {
        // Also nice: "IowanOldStyle-Bold", "ArialRoundedMTBold", "Avenir-Book", "Helvetica Neue"
        if let font = UIFont(name: fontName, size: fontSize) {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let fontAttributes: [String : AnyObject] = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: fontColor,
                NSParagraphStyleAttributeName: style
                ]
            text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
            }
        }

    func textExtent(_ text: String, fontName: String = "AppleSDGothicNeo-Bold", fontSize: CGFloat = 18.0) -> CGRect {
        if let font = UIFont(name: fontName, size: fontSize) {
            let textString = text as NSString
            let textAttributes = [NSFontAttributeName: font]
            return textString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
            }
        return CGRect(x: 0, y: 0, width: 0, height: 0)
        }

        func animShrink()
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bounds = self.origBounds.insetBy(dx: 5, dy: 5)
                }, completion: { (done) -> Void in
                self.bounds = self.origBounds.insetBy(dx: 5, dy: 5)
                }) 
        }

        func animGrow()
        {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.bounds = self.origBounds.insetBy(dx: -5, dy: -5)
                }, completion: { (done) -> Void in
                self.bounds = self.origBounds.insetBy(dx: -5, dy: -5)
                }) 
        }

        func animNormal(_ duration: TimeInterval = 0.2)
        {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.bounds = self.origBounds
                }, completion: { (done) -> Void in
                self.bounds = self.origBounds
                }) 
        }



    }
