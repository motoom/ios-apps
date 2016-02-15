
import UIKit

class VesselView: UIView
{
    var capacity: CGFloat = 8
    var contents: CGFloat = 4

    var pointsperliter: CGFloat = 0
    var tilt: CGFloat = 0
    var rim: CGFloat = 0
    var tickwidth: CGFloat = 0
    var contentstextsize: CGFloat = 0
    var capacitytextsize: CGFloat = 0

    // TODO: Naar globale settings
    let maxcapacity: CGFloat = 15.0
    let insetmargin: CGFloat = 4.0
    let outlineWidth: CGFloat = 1.2

    override init(frame: CGRect) {
        super.init(frame: frame)
        recalcMetrics()
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        recalcMetrics()
    }

    func recalcMetrics() {
        pointsperliter = (frame.height - tilt * 2 - insetmargin * 2) / maxcapacity
        tilt = pointsperliter * 1.5
        rim = pointsperliter * 0.2
        tickwidth = pointsperliter * 0.3
        contentstextsize = pointsperliter * 2.0
        capacitytextsize = pointsperliter
        }

    override func drawRect(rect: CGRect) {
        let paintrect = CGRectInset(rect, insetmargin, insetmargin)

        var path: UIBezierPath!

        // Textual contents in liters
        let textContentsRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y,
            width: paintrect.width,
            height: tilt * 2 // TODO: should be height of text string, in theory
            )

        // Upper rim vessel
        let topRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height - capacity * pointsperliter - tilt * 2 - rim,
            width: paintrect.width,
            height: tilt * 2)

        // Textual capacity in liters
        let textCapacityRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height - capacity * pointsperliter - rim,
            width: paintrect.width,
            height: tilt * 2 // TODO: should be height of text string, in theory
            )

        // Top of fluid (only used when contents > 0)
        let fluidtopRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height - contents * pointsperliter - tilt * 2,
            width: paintrect.width,
            height: tilt * 2)

        // Fluid (only used when contents > 0)
        let fluidRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height - contents * pointsperliter - tilt,
            width: paintrect.width,
            height: contents * pointsperliter)

        // Bottom of vessel
        let bottomRect = CGRect(
            x: paintrect.origin.x,
            y: paintrect.origin.y + paintrect.height - tilt * 2,
            width: paintrect.width,
            height: tilt * 2)

        // Draw bottom of vessel
        path = UIBezierPath(ovalInRect: CGRectInset(bottomRect, outlineWidth, outlineWidth))
        path.lineWidth = outlineWidth
        UIColor.blackColor().setStroke()
        if contents > 0 {
            // Clear if empty, fluid color if not empty.
            UIColor(red: 128.0/255.0, green: 0, blue: 0, alpha: 1).setFill()
            path.fill()
            }
        path.stroke()

        if contents > 0 {
            // Fluid
            path = UIBezierPath(rect: CGRectInset(fluidRect, outlineWidth, outlineWidth))
            UIColor(red: 128.0/255.0, green: 0, blue: 0, alpha: 1).setFill()
            path.fill()

            // Draw top of fluid (with highlight)
            path = UIBezierPath(ovalInRect: CGRectInset(fluidtopRect, outlineWidth, outlineWidth))
            path.lineWidth = outlineWidth
            UIColor(red: 192.0/255.0, green: 0, blue: 0, alpha: 1).setStroke()
            UIColor(red: 128.0/255.0, green: 0, blue: 0, alpha: 1).setFill()
            path.fill()
            path.stroke()
            }

        // Draw upper rim of vessel
        path = UIBezierPath(ovalInRect: CGRectInset(topRect, outlineWidth, outlineWidth))
        path.lineWidth = outlineWidth
        UIColor.blackColor().setStroke()
        path.stroke()

        // Walls
        path = UIBezierPath()
        // Left wall
        path.moveToPoint(CGPoint(x: topRect.origin.x + outlineWidth, y: topRect.origin.y + tilt))
        path.addLineToPoint(CGPoint(x: topRect.origin.x + outlineWidth, y: bottomRect.origin.y + tilt))
        // Right wall
        path.moveToPoint(CGPoint(x: topRect.origin.x + topRect.width - outlineWidth, y: topRect.origin.y + tilt))
        path.addLineToPoint(CGPoint(x: topRect.origin.x + topRect.width - outlineWidth, y: bottomRect.origin.y + tilt))

        // Ticks
        var liter: CGFloat = 1
        while liter < capacity  {
            path.moveToPoint(CGPoint(x: bottomRect.origin.x + bottomRect.width - outlineWidth, y: bottomRect.origin.y + bottomRect.height - tilt - liter * pointsperliter))
            path.addLineToPoint(CGPoint(x: bottomRect.origin.x + bottomRect.width - tickwidth, y: bottomRect.origin.y + bottomRect.height - tilt - liter * pointsperliter + tickwidth))
            liter += 1
            }

        path.lineWidth = outlineWidth
        UIColor.blackColor().setStroke()
        path.stroke()

        // Contents and capacity, in liters
        let flooredCapacity = String(Int(floor(capacity)))
        if flooredCapacity != "0" {
            drawString(textCapacityRect, text: flooredCapacity, fontSize: capacitytextsize)
            }
        let flooredContents = String(Int(floor(contents)))
        if flooredContents != "0" {
            drawString(textContentsRect, text: flooredContents, fontSize: contentstextsize, fontColor: UIColor.grayColor())
            }
        }


    func drawString(rect: CGRect, text: String, fontName: String = "AppleSDGothicNeo-Bold", fontSize: CGFloat = 18.0, fontColor: UIColor = UIColor.blackColor()) {
        // Also nice: "IowanOldStyle-Bold", "ArialRoundedMTBold", "Avenir-Book", "Helvetica Neue"
        if let font = UIFont(name: fontName, size: fontSize) {
            let style = NSMutableParagraphStyle()
            style.alignment = .Center
            let fontAttributes: [String : AnyObject] = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: fontColor,
                NSParagraphStyleAttributeName: style
                ]
            text.drawInRect(rect, withAttributes: fontAttributes)
            }
        }

}
