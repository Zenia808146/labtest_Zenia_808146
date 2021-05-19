//
//  ViewController.swift
//  labtest_Zenia_808146
//
//  Created by Zenia Mangat on 19/05/21.
//

import UIKit

import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var drawRoute: UIButton!
    var count=0
    let annotation = [MKPointAnnotation()]
    override func viewDidLoad() {
        super.viewDidLoad()
        var locationMnager = CLLocationManager()
        // Do any additional setup after loading the view.
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        doubleTap.numberOfTapsRequired = 2
        map.addGestureRecognizer(doubleTap)
        map.delegate = self
        locationMnager.delegate = self
        
        // we define the accuracy of the location
        locationMnager.desiredAccuracy = kCLLocationAccuracyBest
        
        // rquest for the permission to access the location
        locationMnager.requestWhenInUseAuthorization()
        
        // start updating the location
        locationMnager.startUpdatingLocation()
        if count==3{
            self.map.showAnnotations([annotation[0],annotation[1]], animated: true) 
            addPolygon()
        }
        }
    
    
    @IBAction func drawRoute(_ sender: UIButton) {
        map.removeOverlays(map.overlays)
        
        
        
        let sourcePlaceMark = MKPlacemark(coordinate: annotation[count].coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: annotation[count+1].coordinate)
        
        // request a direction
        let directionRequest = MKDirections.Request()
        
        // assign the source and destination properties of the request
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        
        // transportation type
        directionRequest.transportType = .automobile
        
        // calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {return}
            // create the route
            let route = directionResponse.routes[0]
            // drawing a polyline
            self.map.addOverlay(route.polyline, level: .aboveRoads)
            
            // define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        
        }
    }
    func addPolyline() {
        let coordinates = annotation.map {$0.coordinate}
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(polyline)
    }
        func addPolygon() {
            let coordinates = annotation.map {$0.coordinate}
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            map.addOverlay(polygon)
        }
        
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
    let touchPoint = sender.location(in: map)
    let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
    
    // add annotation for the coordinatet
    
    annotation[0].title = "city" + String(count)
    annotation[0].coordinate = coordinate
    map.addAnnotation(annotation[0])
        
        count=count+1
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let rendrer = MKCircleRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 2
            return rendrer
        } else if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            return rendrer
        } else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red.withAlphaComponent(0.6)
            rendrer.strokeColor = UIColor.yellow
            rendrer.lineWidth = 2
            return rendrer
        }
        return MKOverlayRenderer()
    }
    }

// sir i dont know why my previous annotation disappears when i double click on map tp create new annotation and my button is also not appearing. Kindly do not deduct my 10% marks sir because i got access to map 3 days after the course was started andd was not able to watch beginning lectures properly. so it took me time to catch up while watching recordings. since i have just graduated from college i have no prior experience in ios so my project is kind of faulty. so plz do not deduct my marks for late submission i will be very grateful. 
