//
//  MapViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-04-11.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {

    var restaurant: Restaurant!
    @IBOutlet weak var routeView: MKMapView!
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    var localSearch: MKLocalSearch!
    var localSearchRequest: MKLocalSearch.Request!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var resCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        routeView.delegate = self
        
        self.setMapView()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        if let unwrappedAddress = restaurant.address {
            self.getCoordinate(addressString: unwrappedAddress)
        }
    }
    
    func getCoordinate(addressString: String) {
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = addressString
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start(completionHandler: { (searchResponse, error) in
            if searchResponse != nil {
                print("in")
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.restaurant.name
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: searchResponse!.boundingRegion.center.latitude,
                                                                         longitude: searchResponse!.boundingRegion.center.longitude)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.routeView.centerCoordinate = self.pointAnnotation.coordinate
                self.pinAnnotationView.pinTintColor = UIColor.green
                self.routeView.addAnnotation(self.pinAnnotationView.annotation!)
                
                self.resCoordinate = self.pointAnnotation.coordinate
                let coordinateRegion = MKCoordinateRegion(center: searchResponse!.boundingRegion.center,
                                                          latitudinalMeters: self.regionRadius * 2.0, longitudinalMeters: self.regionRadius * 2.0)
                self.routeView.setRegion(coordinateRegion, animated: true)
            }
        })
    }
    
    func setMapView(){
        routeView.showsUserLocation = true
        routeView.isPitchEnabled = true
        routeView.mapType = MKMapType.standard
        routeView.isZoomEnabled = true
        routeView.isScrollEnabled = true
    }
    
    func getDirections() {
        if let destCoordinate = self.pointAnnotation.coordinate as? CLLocationCoordinate2D {
            
            let sourceCoordinate = (locationManager.location?.coordinate)!
            //let sourceCoordinate = CLLocationCoordinate2D(latitude: 43.642, longitude: 79.3871)
            //let destCoordinate = CLLocationCoordinate2D(latitude: 50.642, longitude: 79.3871)

            
            
            let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
            let destPlaceMark = MKPlacemark(coordinate: destCoordinate)
            
            let sourceItem = MKMapItem(placemark: sourcePlaceMark)
            let destItem = MKMapItem(placemark: destPlaceMark)
            
            let destinationRequest = MKDirections.Request()
            destinationRequest.source = sourceItem
            destinationRequest.destination = destItem
            destinationRequest.transportType = .automobile
            destinationRequest.requestsAlternateRoutes = true
            
            
            let directions = MKDirections(request: destinationRequest)
            
            directions.calculate(completionHandler: {(response, error) in

                if error != nil {
                    print(error)
                } else {
                    if let unwrappedResponse = response {
                        self.showRoute(unwrappedResponse)
                        self.routeView.userTrackingMode = .follow
                    }
                }
            })
        }
    }
    
    func showRoute(_ response: MKDirections.Response) {

        for route in response.routes {

            routeView.addOverlay(route.polyline)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
            overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    @IBAction func getDirectionsButton(_ sender: Any) {
        self.getDirections()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
