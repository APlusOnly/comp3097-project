//
//  MyUITableViewController.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-07.
//

import UIKit

class MyUITableViewController: UITableViewController {
    
    /*
    var tempData = [
        Restaurant(name: "McDonalds", address: "123 Street", cuisine: "Fast Food", description: "It's okay", phonenumber: "123-456-7890", rating: 3.5, tags: ["fast food", "burgers", "nuggets"]),
        Restaurant(name: "Wendy's", address: "4 Lane", cuisine: "Food", description: "it's good", phonenumber: "123", rating: 4, tags: ["spicy chicken", "fries"])
    ]
     */
    let cdMgr = CDManager.shared
    var tempData:[Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //cdMgr.saveRestaurant(id: 1, name: "Restaurant")
        tempData = cdMgr.loadRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tempData = cdMgr.loadRestaurants()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tempData[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.restaurant = tempData[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
