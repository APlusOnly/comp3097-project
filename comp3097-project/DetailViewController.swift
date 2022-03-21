//
//  DetailViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-07.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    //var restaurant: Restaurant
    let cdMgr = CDManager.shared
    
    var id: NSManagedObjectID!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let restaurant: Restaurant? = cdMgr.getRestaurantById(id: id)
        if restaurant != nil {
            nameLabel.text = restaurant?.name
            cuisineLabel.text = restaurant?.cuisine
            addressLabel.text = restaurant?.address
            phonenumberLabel.text = restaurant?.phonenumber
            descriptionLabel.text = restaurant?.restaurantDescription
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

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let dest = segue.destination as! AddEditViewController
            dest.action = "edit"
            dest.id = id
        }
    }
}
