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
    
    var restaurant: Restaurant?
    
    var id: NSManagedObjectID!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var taglabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        restaurant = cdMgr.getRestaurantById(id: id)
        if restaurant != nil {
            nameLabel.text = restaurant?.name
            cuisineLabel.text = restaurant?.cuisine
            addressLabel.text = restaurant?.address
            phonenumberLabel.text = restaurant?.phonenumber
            descriptionLabel.text = restaurant?.restaurantDescription
        }
        let tags = restaurant?.tag?.allObjects
        var tagsToDisplay = ""
        for tag in tags ?? [] {
            if let t = tag as? Tag {
                tagsToDisplay += t.name! + "\n"
            }
        }
        taglabel.text = tagsToDisplay
        
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
