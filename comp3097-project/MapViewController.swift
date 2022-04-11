//
//  MapViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-04-11.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {

    var restaurant: Restaurant!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    
    var localSearch: MKLocalSearch!
    var localSearchRequest: MKLocalSearch.Request!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var resCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapView()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
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
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.pinAnnotationView.pinTintColor = UIColor.green
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                
                self.resCoordinate = self.pointAnnotation.coordinate
                let coordinateRegion = MKCoordinateRegion(center: searchResponse!.boundingRegion.center,
                                                          latitudinalMeters: self.regionRadius * 2.0, longitudinalMeters: self.regionRadius * 2.0)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
        })
    }
    
    func setMapView(){
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    func getDirections() {
        if let destCoordinate = self.pointAnnotation.coordinate as? CLLocationCoordinate2D {
            let sourceCoordinate = (locationManager.location?.coordinate)!
            
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
            directions.calculate(completionHandler: { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print("something is wrong")
                    }
                    return
                }
                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            })
        }

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolygonRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    
    @IBAction func getDirectionsButton(_ sender: Any) {
        self.getDirections()
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
