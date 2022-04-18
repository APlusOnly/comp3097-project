//
//  DetailViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-07.
//

import UIKit
import CoreData
import MapKit

class DetailViewController: UIViewController {
    
    //var restaurant: Restaurant
    let cdMgr = CDManager.shared
    
    var restaurant: Restaurant?
    
    var id: NSManagedObjectID!
    
    // resraurant info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var tableData:[Tag] = []
    
    // map info
    let regionRadius: CLLocationDistance = 1000
    var localSearch: MKLocalSearch!
    var localSearchRequest: MKLocalSearch.Request!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var resCoordinate: CLLocationCoordinate2D!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        restaurant = cdMgr.getRestaurantById(id: id)
        
        tagTableView.delegate = self
        tagTableView.dataSource = self
        
        if let unwrappedRestaurant = restaurant {
            nameLabel.text = unwrappedRestaurant.name
            cuisineLabel.text = unwrappedRestaurant.cuisine
            addressLabel.text = unwrappedRestaurant.address
            phonenumberLabel.text = unwrappedRestaurant.phonenumber
            descriptionLabel.text = unwrappedRestaurant.restaurantDescription
            
            if let unwrappedTags = unwrappedRestaurant.tag?.allObjects as? [Tag]{
                self.tableData = unwrappedTags
            }
            
            if let unwrappedAddress = unwrappedRestaurant.address {
                self.getCoordinate(addressString: unwrappedAddress)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let restaurant: Restaurant? = cdMgr.getRestaurantById(id: id)
        if restaurant != nil {
            nameLabel.text = restaurant?.name
            cuisineLabel.text = restaurant?.cuisine
            addressLabel.text = restaurant?.address
            phonenumberLabel.text = restaurant?.phonenumber
            descriptionLabel.text = restaurant?.restaurantDescription
        }
         
    }

    @IBAction func sharePressed(_ sender: UIButton) {
        let tweetText = "your text"
        let tweetUrl = "http://stackoverflow.com/"

        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        let activityVC = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender
        activityVC.popoverPresentationController?.sourceRect = sender.frame
        present(activityVC, animated: true)
    }
    
    func getCoordinate(addressString: String) {
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = addressString
        
        localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start(completionHandler: { (searchResponse, error) in
            if searchResponse != nil {
                print("in")
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.restaurant?.name
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
    

        // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let dest = segue.destination as! AddEditViewController
            dest.action = "edit"
            dest.id = id
        } else if segue.identifier == "viewMap" {
            let dest = segue.destination as! MapViewController
            if restaurant != nil {
                dest.restaurant = restaurant
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do nothing
    }
}


extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tableData[indexPath.row].name

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
