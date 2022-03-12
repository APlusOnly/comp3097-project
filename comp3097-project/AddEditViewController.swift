//
//  AddEditViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-08.
//

import UIKit

class AddEditViewController: UIViewController {
    
    var action: String!
    
    var restaurant: Restaurant?
    
    let cdMgr = CDManager.shared
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCuisine: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPhonenumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if action == "edit" {
            print("edit")
        } else {
            print("add")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // change id and rating
    @IBAction func save(_ sender: Any) {
        // validate values, need better method, this aborts if value is nil
        let nameStr = txtName.text!
        let addressStr = txtAddress.text!
        let cuisineStr = txtCuisine.text!
        let descriptionStr = txtDescription.text!
        let phonenumberStr = txtPhonenumber.text!
        if action == "add" {
            cdMgr.saveRestaurant(id: 1, name: nameStr, address: addressStr, cuisine: cuisineStr, phonenumber: phonenumberStr, desc: descriptionStr, rating: 3)
            print("saved")
            self.dismiss(animated: true, completion: nil)
        }
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
