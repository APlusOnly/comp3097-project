//
//  MainViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-21.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var cuisineLabel: UILabel!
    
    let cdMgr = CDManager.shared
    var data:[Restaurant] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        data = cdMgr.loadRestaurants()
        self.tableView.reloadData()
        
    }
    
    @IBAction func search(_ sender: Any) {
        let searchParam = searchText.text
        if let unwrappedSearch = searchParam {
            data = cdMgr.searchRestaurantByName(name: unwrappedSearch)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = cdMgr.loadRestaurants()
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "add" {
            let dest = segue.destination as! AddEditViewController
            dest.action = "add"
        }
    }
    

}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.id = data[indexPath.row].objectID
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = data[indexPath.row].name
        cell.detailTextLabel?.text = data[indexPath.row].cuisine

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cdMgr.deleteRestaurant(res: data[indexPath.row])
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.data = cdMgr.loadRestaurants()
            self.tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
