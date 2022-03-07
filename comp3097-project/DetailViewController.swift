//
//  DetailViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-07.
//

import UIKit

class DetailViewController: UIViewController {
    
    var restaurant: Restaurant!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = restaurant.name
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
