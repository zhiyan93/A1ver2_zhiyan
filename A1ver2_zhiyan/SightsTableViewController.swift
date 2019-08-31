//
//  SightsTableViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 30/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import CoreData

class SightsTableViewController: UITableViewController,UISearchResultsUpdating ,DatabaseListener{
    //AddSightDelegate
//    func addSight(newSight: Sight) -> Bool {
//        sights.append(newSight)
//        filteredSights.append(newSight)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: filteredSights.count - 1, section: 0)], with: .automatic)
//        tableView.endUpdates()
//        tableView.reloadSections([SECTION_COUNT], with: .automatic)
//        return true
//    }
    
    let SECTION_SIGHT = 0
    let SECTION_COUNT = 1
    let CELL_SIGHT = "sightCell"
    let CELL_COUNT = "sightSizeCell"

    var sights : [SightEntity] = []  //Sight
    
    var filteredSights: [SightEntity] = []
    weak var addSightDelegate: AddSightDelegate?
    weak var databaseController : DatabaseProtocol?  //coredata
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
      //  createDefaultSights()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    var listenerType = ListenerType.sight
//    func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero]) {
//        // Won't be called.
//    }
    
    @IBAction func sortBtn(_ sender: Any) {
        showActionSheet()
        
    }
    
    func onSightListChange(change: DatabaseChange, sightsDB : [SightEntity]) {
        sights = sightsDB
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {  //lowercased()
            filteredSights = sights.filter({(sight: SightEntity) -> Bool in
                return sight.name!.contains(searchText)  //lowercased()
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
            sightCell.sightImage.image = UIImage(data: sight.image! as Data)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "addSightSegue" {
//            let destination = segue.destination as! NewSightViewController
//            destination.addSightDelegate =  self
//        }
//
//    }
    
 
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler:
            nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action1 = UIAlertAction(title: "A-Z", style: .default) { action in self.filteredSights.sort {$0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending}; self.tableView.reloadData() }
        
        let action2 = UIAlertAction(title: "Z-A", style: .default) { action in self.filteredSights.sort {$0.name!.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedDescending};
            self.tableView.reloadData()
        }
    
        
            
    
        actionSheet.addAction(cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
    
        
        present(actionSheet,animated: true, completion: nil)
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
