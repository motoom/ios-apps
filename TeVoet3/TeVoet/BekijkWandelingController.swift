
//  BekijkWandelingController.swift

import UIKit
import MapKit
import CoreLocation

class BekijkWandelingController: UIViewController {

    var locations = [CLLocation]()
    var meta = [String: Any]()

    var rotatorStrings = [String]()
    var rotatorPhase = 0
    var rotatorTimer: Timer? = nil

    var filenaam: String = "" {
        didSet {
            (locations, meta) = loadWaypoints(filenaam)
            }
        }


    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false

        // Statusbar button to cycle map type.
        let m = UIBarButtonItem(image: UIImage(named: "menu3"), style: .plain, target: self, action: #selector(BekijkWandelingController.cycleMapType))
        self.navigationItem.rightBarButtonItem = m

        // Texts for rotator.
        let (walkDate, walkTimes) = prettyDateTimes(locations.first, locations.last)

        // Prepare & start information label rotator.
        rotatorStrings.removeAll()
        rotatorStrings.append(sjiekeAfstand(totalDistance(locations)))
        rotatorStrings.append(walkDate)
        rotatorStrings.append(walkTimes)
        infoLabel.text = rotatorStrings.first
        rotatorPhase = 1
        rotatorTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(BekijkWandelingController.rotatorNext), userInfo: nil, repeats: true)

        // Create the route as a polyline overlay.
        var polylinecoords = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let polyline = MKPolyline(coordinates: &polylinecoords, count: locations.count)
        mapView.add(polyline)

        // Calculate extents of the route, position map to show entire route.
        var zoomRect: MKMapRect = MKMapRectNull
        for location in locations {
            let annotationPoint = MKMapPointForCoordinate(location.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x - 0.5, annotationPoint.y - 0.5, 1, 1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(150,150,150,150), animated: true)
        }


    override func viewWillDisappear(_ animated: Bool) {
        rotatorTimer?.invalidate()
        }


    func cycleMapType() {
        switch (mapView.mapType) {
            case .standard:
                mapView.mapType = .hybrid
            case .hybrid:
                mapView.mapType = .satellite
            default: // must be .Satellite
                mapView.mapType = .standard
            }
        }

    // Draw the polyline.
    func mapView(_ mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let route: MKPolyline = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline:route)
            routeRenderer.lineWidth = 5.0
            routeRenderer.strokeColor = UIColor.red
            return routeRenderer
            }
        return nil
        }


    func rotatorNext() {
        if rotatorPhase >= rotatorStrings.count {
            rotatorPhase = 0
            }
        if rotatorPhase < rotatorStrings.count {
            infoLabel.text = rotatorStrings[rotatorPhase]
            }
        else {
            infoLabel.text = ""
            }
        rotatorPhase += 1
        }


    }
















/*
TODO: Better than code above?
CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(49, -123);
MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
[mapView setRegion:adjustedRegion animated:YES];
*/

/*
var zoomLevel = 15.0
let center = CLLocationCoordinate2DMake(38.894368, -77.036487)
let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0, 360 / (pow(2, zoomLevel) * (mapView.frame.size.width / 256))))
mapView.setRegion(region, animated: true)
*/

/*
let sw = CLLocationCoordinate2D(latitude: 45.5087, longitude: -122.6903)
let ne = CLLocationCoordinate2D(latitude: 45.5245, longitude: -122.6503)
let swPoint = MKMapPointForCoordinate(sw)
let nePoint = MKMapPointForCoordinate(ne)
let swRect = MKMapRectMake(swPoint.x, swPoint.y, 0, 0)
let neRect = MKMapRectMake(nePoint.x, nePoint.y, 0, 0)
let mapRect = MKMapRectUnion(swRect, neRect)
mapView.setVisibleMapRect(mapRect, animated: false)
*/


/* Camera animation
let coordinate = CLLocationCoordinate2DMake(35.5494, 139.77765)
let camera = MKMapCamera(lookingAtCenterCoordinate: coordinate, fromDistance: 5000, pitch: 40, heading: 90)
mapView.setCamera(camera, animated: true)
*/


