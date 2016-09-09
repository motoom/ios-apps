
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

