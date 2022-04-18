//
//  AddEditViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-08.
//

import UIKit
import CoreData

class AddEditViewController: UIViewController {
    
    var action: String!
    
    var restaurant: Restaurant?
    var id: NSManagedObjectID!
    
    let cdMgr = CDManager.shared
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCuisine: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPhonenumber: UITextField!
    @IBOutlet weak var txtTag: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblTag: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if action == "edit" {
            restaurant = cdMgr.getRestaurantById(id: id)
            print("edit")
            if restaurant != nil {
                txtName.text = restaurant?.name
                txtCuisine.text = restaurant?.cuisine
                txtAddress.text = restaurant?.address
                txtDescription.text = restaurant?.restaurantDescription
                txtPhonenumber.text = restaurant?.phonenumber
                if let unwrappedRating = restaurant?.rating{
                    ratingSlider.value = Float(unwrappedRating)
                    lblRating.text = String(unwrappedRating) + "/5"
                }
                let tags = restaurant?.tag?.allObjects
                var tagsToDisplay = ""
                for tag in tags ?? [] {
                    if let t = tag as? Tag {
                        tagsToDisplay += t.name! + "\n"
                    }
                }
                lblTag.text = tagsToDisplay
            }
        } else {
            print("add")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTag(_ sender: Any) {
        if let text = txtTag.text {
            // txtTag not empty
            cdMgr.saveRestaurantTag(res: restaurant, tagName: text)
            print("clicked")
            lblTag.text! += text + "\n"
            txtTag.text = ""
        } else {
        }
    }
    
    @IBAction func ratingChange(_ sender: Any) {
        lblRating.text = String(Int(self.ratingSlider.value)) + "/5"
    }
    // change id and rating
    @IBAction func save(_ sender: Any) {
        // validate values, need better method, this aborts if value is nil
        let nameStr = txtName.text!
        let addressStr = txtAddress.text!
        let cuisineStr = txtCuisine.text!
        let descriptionStr = txtDescription.text!
        let phonenumberStr = txtPhonenumber.text!
        let ratingInt = Int32(ratingSlider.value)
        if action == "add" {
            cdMgr.saveRestaurant(id: 1, name: nameStr, address: addressStr, cuisine: cuisineStr, phonenumber: phonenumberStr, desc: descriptionStr, rating: ratingInt)
            print("saved")
            self.dismiss(animated: true, completion: nil)
        } else {
            restaurant?.name = nameStr
            restaurant?.address = addressStr
            restaurant?.cuisine = cuisineStr
            restaurant?.restaurantDescription = descriptionStr
            restaurant?.phonenumber = phonenumberStr
            restaurant?.rating = Int32(ratingSlider.value)
            cdMgr.updateRestaurant()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if action == "edit" {
            let dest = segue.destination as! DetailViewController
            dest.id = restaurant?.objectID
        }

    }
    

}
