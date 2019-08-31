//
//  SightsTableViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 30/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit

class SightsTableViewController: UITableViewController,AddSightDelegate ,UISearchResultsUpdating {
    
    func addSight(newSight: Sight) -> Bool {
        sights.append(newSight)
        filteredSights.append(newSight)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredSights.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_COUNT], with: .automatic)
        return true
    }
    
    let SECTION_SIGHT = 0
    let SECTION_COUNT = 1
    let CELL_SIGHT = "sightCell"
    let CELL_COUNT = "sightSizeCell"

    var sights : [Sight] = []
    var filteredSights: [Sight] = []
    weak var addSightDelegate: AddSightDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultSights()
        filteredSights = sights
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sights"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredSights = sights.filter({(sight: Sight) -> Bool in
                return sight.name.lowercased().contains(searchText)
            })
        }
        else {
            filteredSights = sights;
        }
        tableView.reloadData();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_SIGHT {
            return filteredSights.count
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SIGHT {
            let sightCell = tableView.dequeueReusableCell(withIdentifier: CELL_SIGHT, for: indexPath) as!
            SightTableViewCell
            let sight = filteredSights[indexPath.row]
            sightCell.sightName.text = sight.name
            sightCell.sightDesc.text = sight.desc
            sightCell.sightImage.image = sight.image
            return sightCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countCell.textLabel?.text = "\(sights.count) sights in the database"
        countCell.selectionStyle = .none
        return countCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
//        if addSightDelegate!.addSight(newSight: filteredSights[indexPath.row]) {
//            navigationController?.popViewController(animated: true)
//            return
//        }
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        displayMessage(title: "Party Full", message: "Cannot add any more members to party")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addSightSegue" {
            let destination = segue.destination as! NewSightViewController
            destination.addSightDelegate =  self
        }
        
    }
    
    func createDefaultSights() {
        sights.append(Sight(image: #imageLiteral(resourceName: "Old Treasury"), name: "Shrine of Remembrance", desc: "Shrine of Remembrance desc", lat: "100", lon: "100"))
        sights.append(Sight(image: #imageLiteral(resourceName: "Melbourne Museum"), name: "Mebourne Museum", desc: "Mebourne Museum desc", lat: "100", lon: "100"))
    }
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler:
            nil))
        self.present(alertController, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
}
