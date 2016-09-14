
//  BekijkWandelingController.swift

import UIKit
import MapKit
import CoreLocation

class BekijkWandelingController: UIViewController {

    var locations = [CLLocation]()

    var filenaam: String = "" {
        didSet {
            if let locs = loadWaypoints(filenaam) {
                locations = locs
                }
            }
        }


    @IBOutlet weak var mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false

        // Create the route as a polyline overlay.
        var polylinecoords = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let polyline = MKPolyline(coordinates: &polylinecoords, count: locations.count)
        mapView.addOverlay(polyline)

        // Calculate extents of the route, position map to show entire route.
        var zoomRect: MKMapRect = MKMapRectNull
        for location in locations {
            let annotationPoint = MKMapPointForCoordinate(location.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x - 0.5, annotationPoint.y - 0.5, 1, 1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(150,150,150,150), animated: true)
        }

    // Draw the polyline.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let route: MKPolyline = overlay as! MKPolyline
            let routeRenderer = MKPolylineRenderer(polyline:route)
            routeRenderer.lineWidth = 5.0
            routeRenderer.strokeColor = UIColor.redColor()
            return routeRenderer
            }
        return nil
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


