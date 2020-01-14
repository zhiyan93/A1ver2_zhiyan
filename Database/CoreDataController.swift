//
//  CoreDataController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 31/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject,DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    
    
    
    
    let DEFAULT_SIGHT_NAME = "Default Sight"
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var persistantContainer: NSPersistentContainer
    
    // Results
    var allSightsFetchedResultsController: NSFetchedResultsController<SightEntity>?
    //var teamHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    override init() {
        persistantContainer = NSPersistentContainer(name: "SightModel")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        
        // If there are no heroes in the database assume that the app is running
        // for the first time. Create the default team and initial superheroes.
        if fetchAllSights().count == 0 {
            createDefaultEntries()
        }
    }
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addSight(name: String, desc: String, image: UIImage, lat: String , lon: String, icon: String) -> SightEntity {
        let sight = NSEntityDescription.insertNewObject(forEntityName: "SightEntity", into:
            persistantContainer.viewContext) as! SightEntity
        sight.name = name
        sight.desc = desc
        sight.image = image.pngData() as NSData?
         sight.latitude = lat
        sight.longitude = lon
        sight.icon = icon
        // This less efficient than batching changes and saving once at end.
        saveContext()
        return sight
    }
    
    
    
    func deleteSight(sight: SightEntity) {
        persistantContainer.viewContext.delete(sight)
        // This less efficient than batching changes and saving once at end.
        saveContext()
    }
    
   
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.sight  {
            listener.onSightListChange(change: .update, sightsDB: fetchAllSights())
        }
    }
    
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func fetchAllSights() -> [SightEntity] {
        if allSightsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<SightEntity> = SightEntity.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allSightsFetchedResultsController = NSFetchedResultsController<SightEntity>(fetchRequest:
                fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil,
                              cacheName: nil)
            allSightsFetchedResultsController?.delegate = self
            do {
                try allSightsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var sights = [SightEntity]()
        if allSightsFetchedResultsController?.fetchedObjects != nil {
            sights = (allSightsFetchedResultsController?.fetchedObjects)!
        }
        
        return sights
    }
    
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSightsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.sight  {
                    listener.onSightListChange(change: .update, sightsDB: fetchAllSights())
                }
            }
        }
        
    }
    
  // var defaultList: SightEntity
    
    func createDefaultEntries() {
        //let _ = addSuperHero(name: "Bruce Wayne", abilities: "Is Rich")
        let _ = addSight(name: "National Aviation Museum", desc: "The Australian National Aviation Museum is an aviation museum at the Moorabbin Airport in Melbourne", image: #imageLiteral(resourceName: "Australian National Aviation Museum"), lat: "-37.9765", lon: "145.0919",icon: "museum")
        
       let _ = addSight(name: "Bundoora Homestead", desc: "The Board and staff of Bundoora Homestead Art Centre acknowledge the Wurundjeri people of the Kulin Nation as the traditional custodians of the land on which we meet, exhibit and celebrate art and heritage", image: #imageLiteral(resourceName: "Bundoora Homestead"), lat: "-37.7053", lon: "145.0505",icon: "music")
        
        let _ = addSight(name: "Chinese Museum", desc: "The Chinese Museum or Museum of Chinese Australian History is an Australian history museum located in Melbourne's Chinatown", image: #imageLiteral(resourceName: "Chinese Museum"), lat: "-37.8108", lon: "144.9691",icon: "museum")
        
        let _ = addSight(name: "Fire Services Museum of Victoria", desc: "The Fire Services Museum of Victoria is an organisation dedicated to the preservation and showcasing of fire-fighting memorabilia from Victoria, Australia and overseas", image: #imageLiteral(resourceName: "Fire Services Museum of Victoria"), lat: "-37.700142", lon: "145.285904",icon: "museum")
        
        let _ = addSight(name: "Her Majesty's Theatre", desc: "Her Majesty's Theatre is a 1,700 seat theatre in Melbourne's East End Theatre District, Australia", image: #imageLiteral(resourceName: "Her Majesty's Theatre"), lat: "-37.8110", lon: "144.9696",icon: "school")
        
        let _ = addSight(name: "Jewish Holocaust Centre", desc: "The Jewish Holocaust Centre was founded in Elsternwick, Melbourne, Australia, in 1984 by Holocaust survivors", image: #imageLiteral(resourceName: "Jewish Holocaust Centre"), lat: "-38.047240", lon: "145.309300",icon: "tank")
        
        let _ = addSight(name: "Melbourne Museum", desc: "Melbourne Museum is a natural and cultural history museum located in the Carlton Gardens in Melbourne, Australia", image: #imageLiteral(resourceName: "Melbourne Museum"), lat: "-37.8033", lon: "144.9717",icon: "museum")
        
        let _ = addSight(name: "Steam Traction Engine Club", desc: "The club's philosophy is to show it in action. Engines are restored to working order and operated regularly.", image: #imageLiteral(resourceName: "Melbourne Steam Traction Engine Club"), lat: "-37.9054", lon: "145.2143",icon: "navy")
        
        let _ = addSight(name: "Old Treasury", desc: "The Old Treasury Building on Spring Street in Melbourne, was once home to the Treasury Department of the Government of Victoria, but is now a museum of Melbourne history, known as the Old Treasury Building", image: #imageLiteral(resourceName: "Old Treasury"), lat: "-37.8132", lon: "144.9744",icon: "rocket")
        
        let _ = addSight(name: "Portable Iron Houses", desc: "The nineteenth century Portable Iron Houses provide an insight into life in Emerald Hill, now known as South Melbourne, during the gold rush years", image: #imageLiteral(resourceName: "Portable Iron Houses"), lat: "-37.8340", lon: "144.9533",icon: "music")
        
        let _ = addSight(name: "Public Record Office Victoria", desc: "Public Record Office Victoria holds an extraordinary array of records created by the Victorian Government from the mid-1830s to now", image: #imageLiteral(resourceName: "Public Record Office Victoria"), lat: "-37.7974", lon: "144.9414",icon: "school")
        
        let _ = addSight(name: "Shrine of Remembrance", desc: "The Shrine of Remembrance is Victoria's national war memorial", image: #imageLiteral(resourceName: "Shrine of Remembrance"), lat: "-37.8305", lon: "144.9734",icon: "tank")
        
        let _ = addSight(name: "Victoria Police Museum", desc: "The Victoria Police Museum is a law enforcement museum operated by the Historical Services Unit within the Media and Corporate Communications Department of Victoria Police", image: #imageLiteral(resourceName: "Victoria Police Museum"), lat: "-37.8223", lon: "144.9542",icon: "tank")
        
        let _ = addSight(name: "Parliament House of Victoria", desc: "Parliament House is the meeting place of the Parliament of Victoria, one of the parliaments of the Australian states and territories", image: #imageLiteral(resourceName: "Victoria's Parliament House"), lat: "-37.8110", lon: "144.9738",icon: "school")
        
        let _ = addSight(name: "Villa Alba Museum", desc: "Villa Alba Museum is a lavishly decorated 1880 Italianate mansion in Kew adjacent to Studley Park", image: #imageLiteral(resourceName: "Villa Alba Museum"), lat: "-37.8050", lon: "145.0112",icon: "navy")
    }
}
